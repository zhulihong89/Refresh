//
//  UITableView+Refresh.h
//  Refresh
//
//  Created by 朱李宏 on 15/11/24.
//  Copyright © 2015年. All rights reserved.
//

#import <UIKit/UIKit.h>

static float const kUITableViewRefreshHeight = 55;
static float const kUITableViewRefreshAddTriggerHeight = 30;

typedef NS_ENUM(NSUInteger, UITableViewRefreshStatus) {
    UITableViewRefreshStatusNormal,
    UITableViewRefreshStatusDraging,
    UITableViewRefreshStatusRefreshing
};

@protocol UITableViewRefresh;

@interface UIScrollView (Refresh)

@property (assign, nonatomic) BOOL refreshEnabled;
@property (assign, nonatomic, readonly) UITableViewRefreshStatus refreshStatus;
/*! 默认TableViewRefreshView */
@property (nonatomic, strong) UIView<UITableViewRefresh> *tableViewRefreshView;
@property (assign, nonatomic) CGFloat refreshOffsetY;

/*! 触发加载更多时调用的方法，里面是有weak self
 */
- (void)addRefreshTriggerBlock:(void(^)(void))block;
- (void)endRefresh;
- (void)trigerRefresh;

@end

/**
 刷新的视图需要实现该方法
 */
@protocol UITableViewRefresh <NSObject>

@required
@property (nonatomic, assign) float refreshProgress;
- (void)trigerRefreshStatus;
- (void)endRefreshStatus;

@end


@interface TableViewRefreshView : UIView <UITableViewRefresh>

@property (nonatomic, assign) float refreshProgress;
@property (assign, nonatomic) BOOL isFeedBackGenertor;
@property (nonatomic, strong) UIColor *color;

- (void)trigerRefreshStatus;
- (void)endRefreshStatus;

@end
