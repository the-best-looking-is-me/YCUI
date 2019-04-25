//
//  YCTimeManager.m
//  RAC
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import "YCTimeManager.h"
#import "YCThreadSimple.h"

@implementation YCTimeManager


/**
 用于验证码倒计时，每秒一次

 @param time 总秒数
 @param block 回传秒数
 */
+ (void)timeCodeVerify:(NSInteger)time block:(void(^)(NSInteger second))block{
    
    __weak typeof(self) weakSelf = self;
    [YCThreadSimple threadAt:YCThreadMain DelayTime:0 operate:^{
        NSInteger tmpTime = time - 1;
        if (tmpTime >= 0) {
            block(tmpTime);
            [YCThreadSimple threadAt:YCThreadMain DelayTime:1 operate:^{
                [weakSelf timeCodeVerify:tmpTime block:block];
            }];
        }
    }];
}



@end
