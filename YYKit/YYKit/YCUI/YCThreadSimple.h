//
//  YCThreadSimple.h
//  UIP
//
//  Created by th on 2018/3/1.
//  Copyright © 2018年 thgyuip. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum YCThreadSelect
{
    YCThreadChild,
    YCThreadMain
   
}YCThreadSelect;


@interface YCThreadSimple : NSObject

typedef void(^ycDelayBlock)(void);

/**
 在子线程中操作
 
 @param operate 操作
 */
+ (void)threadAtChild:(void(^)(void))operate;


/**
 在主线程中操作
 
 @param operate 操作
 */
+ (void)threadAtMain:(void(^)(void))operate;


/**
 在指定线程中 延迟时间 操作
 
 @param thread 指定线程 主 子
 @param time 延迟时间
 @param operate 操作
 */
+ (void)threadAt:(YCThreadSelect)thread DelayTime:(CGFloat)time operate:(void(^)(void))operate;

@end
