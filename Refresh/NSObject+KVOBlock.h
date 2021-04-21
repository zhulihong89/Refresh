//
//  NSObject+KVOBlock.h
//  Refresh
//
//  Created by 朱李宏 on 15/6/23.
//
//

#import <Foundation/Foundation.h>

typedef void(^KVOBlockChange) (id self, id old, id newVal);

@interface NSObject (KVOBlock)

- (void)observeKeyPath:(NSString *)keyPath withBlock:(KVOBlockChange)observationBlock;

@end
