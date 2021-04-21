//
//  UITableView+LoadMore.h
//  Refresh
//
//  Created by hello on 15/11/6.
//  Copyright © 2015年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LoadMore)

/*! 是否有更多加载 
 */
@property (nonatomic, assign) BOOL isMore;

/*! 触发加载更多时调用的方法，里面是有weak self
 */
- (void)addLoadingMoreTriggerBlock:(void(^)(void))block;
/*! 下拉加载结束
 */
- (void)endLoadMore;

@end
