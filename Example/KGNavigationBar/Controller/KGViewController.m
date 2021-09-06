//
//  KGViewController.m
//  KGNavigationBar
//
//  Created by wangwanjie on 12/29/2020.
//  Copyright (c) 2020 wangwanjie. All rights reserved.
//

#import "KGViewController.h"
#import <KGNavigationBar/KGNavigationBar.h>
#import "ExampleItem.h"
#import <objc/runtime.h>
#import "BaseTabBarViewController.h"

@interface KGViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray<ExampleItem *> *dataSource;  ///< 数据源
@end

@implementation KGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"KGNavigationBar 版本：%@", KGNavigationBar_VERSION);

    [self initDataSource];
    [self setupUI];
}

- (void)initDataSource {
    ExampleItem *item = nil;
    item = [ExampleItem itemWithDesc:@"酷狗/皮皮虾/今日头条样式" transitionRatio:0.92 hideTabBarIfNoFirstVc:true];
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"QQ 音乐样式" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.transitionShadowEnable = false;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"抖音样式，可以左滑实现抖音视频浏览页左滑拉出视频作者个人页效果" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.openScrollLeftPush = true;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"不缩放，只平移" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"AppStore 风格，UITabBar 常驻, 控制器平移，加阴影" transitionRatio:1 hideTabBarIfNoFirstVc:false];
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"与 AppStore 风格一致，UITabBar 常驻, 控制器平移，并且去掉转场阴影遮盖" transitionRatio:1 hideTabBarIfNoFirstVc:false];
    item.transitionShadowEnable = false;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"UITabBar 可以是透明的，但是得设置 UITabBar().kg_isBgTransparent = YES" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.tabBarHeight = 100;
    item.isTabBarBgTransparent = true;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"转场无遮盖阴影，转场时边缘阴影暂时默认添加，没做开关" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.transitionShadowEnable = false;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"修改阴影遮盖颜色" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.transitionShadowColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"使用系统默认的手势，只需要本框架的一对一导航栏设置功能。只有边缘返回，没有阴影，与系统默认手势返回表现一致，设置缩放系数等需要使用自定义手势识别器的功能都将失效，但依然具有全屏手势 pop 功能" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.useCustomTransition = false;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"TabBarController 嵌套也支持，完全支持单个控制器 hidesBottomBarWhenPushed 全场景处理，嵌套的转场效果只与自身导航控制器有关" transitionRatio:0.92 hideTabBarIfNoFirstVc:true];
    item.transitionShadowColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    ExampleItem *nestedItem = [ExampleItem itemWithDesc:@"嵌套的 TabBar 控制器" transitionRatio:1 hideTabBarIfNoFirstVc:false];
    item.nestedItem = nestedItem;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"嵌套的 TabBarController 隐藏 UITabBar" transitionRatio:0.92 hideTabBarIfNoFirstVc:true];
    item.transitionShadowColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    nestedItem = [ExampleItem itemWithDesc:@"嵌套的 TabBar 控制器" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.nestedItem = nestedItem;
    [self.dataSource addObject:item];

    item = [ExampleItem itemWithDesc:@"UITabBar 高度可以变化，你可以自定义 UITabBar" transitionRatio:1 hideTabBarIfNoFirstVc:true];
    item.tabBarHeight = 150;
    [self.dataSource addObject:item];
}

- (void)setupUI {
    self.kg_navigationItem.title = @"转场示例";

    self.view.backgroundColor = UIColor.whiteColor;

    UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(self.kg_navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.kg_navigationBar.frame)}];
    [self.view addSubview:tableView];

    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 新建标识
    static NSString *ID = @"ReusableCellIdentifier";
    // 创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    ExampleItem *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.desc;
    cell.textLabel.numberOfLines = 0;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    ExampleItem *item = self.dataSource[indexPath.row];

    BaseTabBarViewController *tabVc = [[BaseTabBarViewController alloc] initWithModel:item];
    [self.navigationController pushViewController:tabVc animated:true];
}

#pragma mark - lazy load
- (NSMutableArray<ExampleItem *> *)dataSource {
    return _dataSource ?: ({ _dataSource = [NSMutableArray array]; });
}
@end
