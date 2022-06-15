//
//  SBSelectENVPopView.m
//
//  Created by 安康 on 2019/10/5.
//

#import "SBSelectENVPopView.h"

#import "SBSelectENVPopCell.h"

#import "SBSwitchEnviroment.h"



@interface SBSelectENVPopView ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *maryDataSource;

@end

@implementation SBSelectENVPopView


#pragma mark - ************************************** View Lifecycle **************************************

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        [self createViews];
        [self cteateVariables];
    }
    return self;
}


- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - ************************************** Init All Views **************************************


- (void)createViews {
    // 根据界面情况，决定是单独写函数，或直接写Views
    [self initMainViews];
}
- (void)initMainViews {
    const CGFloat fltPopViewW = 310;
    const CGFloat fltPopViewH = 350;
    
    // 配置self
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
   
    UIControl * control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    control.backgroundColor = [UIColor blackColor];
    control.alpha = 0.7;
    [control addTarget:self action:@selector(btnClickedCancel:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview:control];

    
    // 创建弹出view
    UIView *viewPop = [[UIView alloc] initWithFrame:CGRectMake((SB_SCREEN_W_K - fltPopViewW)/2,
                                                               (SB_SCREEN_H_K-fltPopViewH)/2,
                                                               fltPopViewW,
                                                               fltPopViewH)];
    viewPop.backgroundColor = [UIColor whiteColor];
    viewPop.layer.cornerRadius = 10;
    viewPop.clipsToBounds = YES;
    viewPop.alpha = 1;
    [self addSubview:viewPop];
    
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fltPopViewW, 50) ];
    labTitle.text = @"环境切换";
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.backgroundColor = [UIColor whiteColor];
    labTitle.font = [UIFont boldSystemFontOfSize:17];
    labTitle.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
    [viewPop addSubview:labTitle];
    
    
    _tableView  = [[UITableView alloc ] initWithFrame:CGRectMake(15,
                                                                 50,
                                                                 fltPopViewW -30,
                                                                 fltPopViewH - 110)
                                                style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = [SBSelectENVPopCell cellHeight];
    [viewPop addSubview:_tableView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((fltPopViewW- 200)/2, fltPopViewH-52, 200, 42)];
    [btn addTarget:self action:@selector(btnClickOK:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor sb_colorWithRGB:0xffffff alpha:0.3] forState:UIControlStateDisabled];

    btn.backgroundColor = UIColor.systemRedColor;
    
    btn.layer.cornerRadius = btn.frame.size.height * 0.5;
    btn.clipsToBounds = YES;
    [viewPop addSubview:btn];
}

- (void)cteateVariables {
    _maryDataSource = [NSMutableArray array];

    [self initDataSource];

    // 进一步判断是否有选中的，如果没有选中，设置为uat
    BOOL isHaveSelet = NO;
    for (SBSelectENVPopModel* model in _maryDataSource) {
        if (model.isSelect) {
            isHaveSelet = YES;
        }
    }

    if (NO == isHaveSelet) {
        [[NSUserDefaults standardUserDefaults ] setValue:@(SB_Enviroment_UAT)
                                                  forKey:SBEnvironmentSwitchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        ///并且选中第一个
        [_maryDataSource removeAllObjects];
        [self initDataSource];
    }
}

- (void)initDataSource {
    NSNumber *env = [[NSUserDefaults standardUserDefaults] objectForKey:SBEnvironmentSwitchKey];
    if (!env)
    {
        env = @(SB_Enviroment_UAT);
        [[NSUserDefaults standardUserDefaults ] setValue:env forKey:SBEnvironmentSwitchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSArray *enaAry = @[@(SB_Enviroment_UAT),
                        @(SB_Enviroment_PRE),
                        @(SB_Enviroment_Product)];

    for (NSNumber *evnItem in enaAry) {
        SBSelectENVPopModel * model = [[SBSelectENVPopModel alloc] init];
        model.env = evnItem.integerValue;

        if (evnItem.integerValue == env.integerValue) {
            model.isSelect = YES;
        } else {
            model.isSelect = NO;
        }
        [_maryDataSource addObject:model];
    }
}
#pragma mark - ************************************** Button Touch Event **************************************

- (void)btnClickOK:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSNumber *env = [[NSUserDefaults standardUserDefaults] objectForKey:SBEnvironmentSwitchKey];
    [_maryDataSource enumerateObjectsUsingBlock:^(SBSelectENVPopModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
         if (YES == model.isSelect) {
             if (env.integerValue == model.env) {
                 [weakSelf removeFromSuperview];
             } else {
                 [[NSUserDefaults standardUserDefaults ] setObject:@(model.env) forKey:SBEnvironmentSwitchKey];
                 [[NSUserDefaults standardUserDefaults] synchronize];

                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"切换环境"
                                                                 message:model.title
                                                                delegate:weakSelf
                                                       cancelButtonTitle:@"立即重启"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }

             *stop = YES;
         }
     }];
}

-(void) btnClickedCancel:(UIControl*) con
{
    [self removeFromSuperview];
}

#pragma mark - ************************************** Delegate Event **************************************

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [SBSelectENVPopCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _maryDataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBSelectENVPopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SBSelectENVPopCell"];

    if (cell == nil) {
        cell = [[SBSelectENVPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SBSelectENVPopCell"];
    }
    cell.modelData = _maryDataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_maryDataSource enumerateObjectsUsingBlock:^(SBSelectENVPopModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
         if (idx == indexPath.row) {
             model.isSelect = YES;
         } else {
             model.isSelect = NO;
         }
     }];
    [self.tableView reloadData];
}


#pragma mark - UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.changeENVBlock) {
            self.changeENVBlock();
        }
        exit(0);
    }
    return;
}


@end
