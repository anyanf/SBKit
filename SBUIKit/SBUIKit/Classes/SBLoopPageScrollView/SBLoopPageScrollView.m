//
//  SBLoopPageScrollView.m
//  SBUIKit
//
//  Created by 安康 on 2020/5/13.
//

#import "SBLoopPageScrollView.h"

#import "SBImageView.h"

#import "NSTimer+SBExtension.h"



static NSString *const kCellIdentifier = @"GMCLoopCollectionViewCell";
static NSInteger kMaxSections = 99;

/**
 *  CollectionViewCell类
 */
@interface SBLoopPageScrollViewCell : UICollectionViewCell
<UIGestureRecognizerDelegate>

/// cell主view
@property (nonatomic, weak) SBImageView *viewMainCell;


- (void)setModel:(id)model;

@end




@interface SBLoopPageScrollView()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>
{
    UICollectionView *_collectionView;
    UICollectionViewScrollDirection _scrollDirection;//滚动方向
    UICollectionViewScrollPosition _scrollPosition;//滚动方向
    
    NSIndexPath *currentIndexPathRest;//重置cell 的indexpath
        
    NSTimer *_timer;
    
    BOOL isTwoView_; //如果为YES,整个index>1时，需要-2；
}

/// cell占整个view宽度的百分比，默认为1
@property (nonatomic, assign) CGFloat cftCellPercent;

@end


@implementation SBLoopPageScrollView


- (instancetype)initWithFrame:(CGRect)frame
              scrollDirection:(SBLoopPageScrollDirection)scrollDirection
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (scrollDirection == SBLoopPageScrollDirection_Horizontal) {
            _scrollDirection = UICollectionViewScrollDirectionHorizontal;
        } else {
            _scrollDirection = UICollectionViewScrollDirectionVertical;
        }
        
        //初始化数据
        [self initVariable];
        
        //初始化view
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame scrollDirection:SBLoopPageScrollDirection_Horizontal];
}

//初始化数据
- (void)initVariable
{
    _isCanAutoScroll = YES;
    _isCanScroll = YES;
    _cftCellPercent = 1;
    _colorBackGround = [UIColor colorWithRed:244.0 green:244.0 blue:(CGFloat)244.0 alpha:1.0];
    
}

//初始化view
- (void)initViews
{
    [self createCollectionView];
}

/**
 *  创建main view
 */
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    flowLayout.scrollDirection = _scrollDirection;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width*self.cftCellPercent, self.frame.size.height);
    
    CGRect advertRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _collectionView = [[UICollectionView alloc] initWithFrame:advertRect collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[SBLoopPageScrollViewCell class]
        forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];

}



- (void)setMaryData:(NSArray *)maryData
{
    /// 解决当只有2个自定义view时，滚动出现白屏问题
    
    if (maryData.count == 2 &&
        ([maryData[0] isKindOfClass:UIView.class] ||
         [maryData[1] isKindOfClass:UIView.class])) {
        
        isTwoView_ = YES;
        NSMutableArray *mData = [NSMutableArray arrayWithArray:maryData];
        NSData * firstArchive = [NSKeyedArchiver archivedDataWithRootObject:maryData[0]];
        NSData * lastArchive = [NSKeyedArchiver archivedDataWithRootObject:maryData[1]];
        [mData insertObject:[NSKeyedUnarchiver unarchiveObjectWithData:firstArchive] atIndex:2];
        [mData insertObject:[NSKeyedUnarchiver unarchiveObjectWithData:lastArchive] atIndex:3];
        _maryData = mData;
    } else {
        isTwoView_ = NO;
        _maryData = maryData;
    }
    
    if (maryData.count == 0) {
        [self removeTimer];
        return;
    }
    
    
    if (maryData.count>1 && _isCanAutoScroll) {
        _collectionView.scrollEnabled = _isCanScroll;
        [self addTimer];//创建定时器
    } else {
        [self removeTimer];

        if (maryData.count > 1) {
            _collectionView.scrollEnabled = _isCanScroll;
        } else {
            _collectionView.scrollEnabled = NO;
        }
    }

    [_collectionView reloadData];
    
}
/**
 *  添加定时器
 */
- (void)addTimer {
    [self removeTimer];
    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [NSTimer sb_scheduledTimerWithTimeInterval:5.0 block:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf nextPage];
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}
/**
 *  删除定时器
 */
- (void)removeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 *  下一页
 */
//自动滚动
-(void)nextPage {
    //重置collectionview显示位置
    [self resetCurrentView];
    
    //计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathRest.item + 1;
    NSInteger nextSection = currentIndexPathRest.section;
    if (nextItem == self.maryData.count) {
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    //通过动画滚动到下一个位置
    [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:_scrollPosition animated:YES];
    
}

//重置collectionview显示位置
- (void)resetCurrentView
{
    //获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[_collectionView indexPathsForVisibleItems]lastObject];
    //回最中间那组的数据
    currentIndexPathRest=[NSIndexPath indexPathForItem:currentIndexPath.item inSection:kMaxSections/2];
    [_collectionView scrollToItemAtIndexPath:currentIndexPathRest atScrollPosition:_scrollPosition animated:NO];
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, self.frame.size.width*self.cftCellPercent, 0, 0);
    [_collectionView reloadData];
}

#pragma mark - UICollectionView的数据源和代理方法

#pragma mark- UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kMaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _maryData.count;
}

- (SBLoopPageScrollViewCell *)collectionView:(UICollectionView *)collectionView
                      cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SBLoopPageScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                               forIndexPath:indexPath];
    cell.backgroundColor = _colorBackGround;
    NSInteger index = indexPath.item;
    if (index<_maryData.count) {
        [cell setModel:_maryData[index]];

        NSInteger curIndex = (isTwoView_ && indexPath.item > 1) ? indexPath.item - 2 : indexPath.item;
        cell.tag = self.tag *1000 + curIndex;
    } else {
        [cell setModel:_maryData[0]];
        cell.tag = self.tag *1000;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width*self.cftCellPercent, self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = (isTwoView_ && indexPath.item > 1) ? indexPath.item - 2 : indexPath.item;
    if (_viewClickBlock) {
        _viewClickBlock(index);
    }
}
#pragma mark 当拖拽时，暂时将定时器销毁
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
    
    //获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[_collectionView indexPathsForVisibleItems]lastObject];
    if (currentIndexPath.item == [_maryData count]-1 || currentIndexPath.item == 0) {
        [self resetCurrentView];
    }
    
}

#pragma mark 停止拖拽时，再次创建定时器
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_isCanAutoScroll && _maryData.count>1) {
        [self addTimer];
    }
    
}

- (void)dealloc {
    [self removeTimer];
}


@end

// *************************************************SBLoopPageScrollViewCell*******************************************************************************************

#pragma mark -------
#pragma mark SBLoopPageScrollViewCell类

@implementation SBLoopPageScrollViewCell {
    
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        SBImageView *imageView = [[SBImageView alloc]initWithFrame:self.bounds];
        imageView.userInteractionEnabled = YES;
        _viewMainCell = imageView;
        [self.contentView addSubview:_viewMainCell];
    }
    return self;
}

- (void)setModel:(id)model
{
    [self cleanMainCellSubViews];
    
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[UIImage class]])
    {
        [self setImageWithData:model placeholderImage:nil];
    }
    else if ([model isKindOfClass:[UIView class]])
    {
        [_viewMainCell addSubview:model];
    }
    else
    {
        
    }
}
- (void)cleanMainCellSubViews
{
    _viewMainCell.image = nil;
    for (UIView *view in _viewMainCell.subviews) {
        [view removeFromSuperview];
    }
}
-(void)setImageWithData:(UIImage *)imageData placeholderImage:(UIImage *)placeholderImage {
   if ([imageData isKindOfClass:[UIImage class]])
    {
        UIImage *image = (UIImage *)imageData;
        [_viewMainCell setImage:image];
    }
}




@end
