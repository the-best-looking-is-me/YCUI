//
//  YCTimeManager.h
//  RAC
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTimeManager : NSObject


/**
 用于验证码倒计时，每秒一次
 
 @param time 总秒数
 @param block 回传秒数
 */
+ (void)timeCodeVerify:(NSInteger)time block:(void(^)(NSInteger second))block;


@end

NS_ASSUME_NONNULL_END
