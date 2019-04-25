//
//  YCThreadSimple.m
//  UIP
//
//  Created by th on 2018/3/1.
//  Copyright © 2018年 thgyuip. All rights reserved.
//

#import "YCThreadSimple.h"

@implementation YCThreadSimple


/**
 在子线程中操作

 @param operate 操作
 */
+ (void)threadAtChild:(void(^)(void))operate{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (operate) {
            operate();
        }
    });
}


/**
 在主线程中操作

 @param operate 操作
 */
+ (void)threadAtMain:(void(^)(void))operate{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (operate) {
            operate();
        }
    });
    
    
}


/**
 在指定线程中 延迟时间 操作

 @param thread 指定线程 主 子
 @param time 延迟时间
 @param operate 操作
 */
+ (void)threadAt:(YCThreadSelect)thread DelayTime:(CGFloat)time operate:(void(^)(void))operate{
    if (thread == YCThreadMain) {
        [YCThreadSimple threadAtMain:^{
            __block ycDelayBlock tmpBlock = operate;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                tmpBlock();
            });
        }];
    }else if (thread == YCThreadChild) {
        [YCThreadSimple threadAtChild:^{
            __block ycDelayBlock tmpBlock = operate;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                tmpBlock();
            });
        }];
    }
}

@end
