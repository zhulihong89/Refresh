//
//  UITableView+LoadMore.m
//  Refresh
//
//  Created by hello on 15/11/6.
//  Copyright © 2015年. All rights reserved.
//

#import "UITableView+LoadMore.h"
#import "NSObject+KVOBlock.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, kUITableViewLoadMoreStatus) {
    kUITableViewLoadMoreStatusNormal,
    kUITableViewLoadMoreStatusLoading,
};

@interface UITableView ()

@property (nonatomic, readonly) UIView *loadingMoreView;
@property (nonatomic, assign) BOOL isAddBottomEdge;
@property (nonatomic, assign) kUITableViewLoadMoreStatus loadMoreStatus;

@end

@implementation UITableView (LoadMore)

- (void)addLoadingMoreTriggerBlock:(void(^)(void))block
{
    [self observeContentSizeForLoadMore];
    [self observeContentOffsetForLoadMoreBlock:block];
}

/*! 下拉加载结束
 */
- (void)endLoadMore
{
    self.loadMoreStatus = kUITableViewLoadMoreStatusNormal;
    [self resetBottomEdge];
}

#pragma mark Private

- (void)observeContentSizeForLoadMore
{
    [self observeKeyPath:@"contentSize" withBlock:^(__weak UITableView *self, id old, id newVal) {
        if (self.isMore) {
            [self addBottomEdge];
        }else {
            [self resetBottomEdge];
        }
        [self setLoadingViewFrame];
    }];
}

- (void)observeContentOffsetForLoadMoreBlock:(void(^)(void))block
{
    [self observeKeyPath:@"contentOffset" withBlock:^(__weak UITableView * self, id old, id newVal) {
        if (self.contentOffset.y > (self.contentSize.height - CGRectGetHeight(self.bounds))) {
            if (self.loadMoreStatus == kUITableViewLoadMoreStatusNormal && self.isMore) {
                self.loadMoreStatus = kUITableViewLoadMoreStatusLoading;
                if (block) {
                    block();
                }
            }
        }
    }];
}

- (void)setLoadingViewFrame
{
    self.loadingMoreView.frame = CGRectMake(0, self.contentSize.height, CGRectGetWidth(self.bounds), 40);
}

- (void)addBottomEdge
{
    UIEdgeInsets contentInset = self.contentInset;
    if (!self.isAddBottomEdge) {
        contentInset.bottom += 44;
        self.isAddBottomEdge = true;
    }
    self.contentInset = contentInset;
}

- (void)resetBottomEdge
{
    UIEdgeInsets contentInset = self.contentInset;
    if (self.isAddBottomEdge) {
        contentInset.bottom -= 44;
        self.isAddBottomEdge = false;
    }
    self.contentInset = contentInset;
}

#pragma mark Setter Getter

static int const loadingMoreView_indicator = 1000;
- (UIView *)loadingMoreView
{
    UIView *view = objc_getAssociatedObject(self, &@selector(loadingMoreView));
    if (!view) {
        view = [UIView new];
        [self addSubview:view];
        view.backgroundColor = [UIColor clearColor];
        view.hidden = true;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.translatesAutoresizingMaskIntoConstraints = false;
        [view addSubview:indicator];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:view attribute:(NSLayoutAttributeCenterX) multiplier:1.0 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:view attribute:(NSLayoutAttributeCenterY) multiplier:1.0 constant:0]];
        [indicator startAnimating];
        indicator.tag = loadingMoreView_indicator;
        
        objc_setAssociatedObject(self, &@selector(loadingMoreView), view, OBJC_ASSOCIATION_RETAIN);
    }
    
    return view;
}

/*! 是否有更多加载 */
- (void)setIsMore:(BOOL)isMore
{
    self.loadingMoreView.hidden = !isMore;
    objc_setAssociatedObject(self, &@selector(isMore), @(isMore), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isMore
{
    return [objc_getAssociatedObject(self, &@selector(isMore)) boolValue];
}

/*! 是否添加了底部edge */
- (void)setIsAddBottomEdge:(BOOL)isAddBottomEdge
{
    objc_setAssociatedObject(self, &@selector(isAddBottomEdge), @(isAddBottomEdge), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isAddBottomEdge
{
    return [objc_getAssociatedObject(self, &@selector(isAddBottomEdge)) boolValue];
}

/*! 当前加载状态 */
- (void)setLoadMoreStatus:(kUITableViewLoadMoreStatus)loadMoreStatus
{
    objc_setAssociatedObject(self, &@selector(loadMoreStatus), @(loadMoreStatus), OBJC_ASSOCIATION_RETAIN);
}

- (kUITableViewLoadMoreStatus)loadMoreStatus
{
    return [objc_getAssociatedObject(self, &@selector(loadMoreStatus)) integerValue];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
