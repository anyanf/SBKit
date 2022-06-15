//
//  SBTableView.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//

#import "SBTableView.h"

@implementation SBTableView

+ (instancetype)createWithFrame:(CGRect)frame
                         target:(id)target
                          style:(UITableViewStyle)style {
    SBTableView *tabV = [[self alloc] initWithFrame:frame
                                              style:style];
    tabV.delegate = target;
    tabV.dataSource = target;
    tabV.sb_delegate = target;
    
    return tabV;
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame
                              style:style]) {
        [self setCommonAttribute];
        [self setCustomAttribute];
    }
    
    return self;
}

// 设置公共属性
- (void)setCommonAttribute {
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        // 设置成0，使得 heightForXXX 代理会被调用
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        
    }
}

// 设置自定义属性
- (void)setCustomAttribute {
    self.backgroundColor = [UIColor whiteColor]; // 设置背景颜色
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone; // 默认不使用系统自带分割线
    //    self.separatorInset = UIEdgeInsetsZero;
    //    self.separatorInsetReference = UITableViewSeparatorInsetFromCellEdges;
    self.separatorColor = [UIColor blackColor];
    
    self.showsHorizontalScrollIndicator = NO; // 不显示 水平 滑条
    self.showsVerticalScrollIndicator = NO;   // 不显示 垂直 滑条
    
    self.clipsToBounds = YES;
    
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(sbTableLongPress:)];
    
    longPressGesture.minimumPressDuration = 1.5f; //设置长按 时间
    [self addGestureRecognizer:longPressGesture];
        
}


- (void)sbTableLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    
    
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint location = [longRecognizer locationInView:self];
        NSIndexPath * indexPath = [self indexPathForRowAtPoint:location];

        if (!indexPath) {
            return;
        }
        
        if ([self.sb_delegate respondsToSelector:@selector(tableView:didLongPressRowAtIndexPath:)]) {
            [self.sb_delegate tableView:self didLongPressRowAtIndexPath:indexPath];
            
        }
    }
}



@end
