//
//  YYKitViewController.m
//  YYKit
//
//  Created by yangchang on 2019/4/19.
//  Copyright © 2019 yangchang. All rights reserved.
//

#import "YYKitViewController.h"
#import "YYKit.h"

@interface YYKitViewController ()


@end

@implementation YYKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

//YYCache 同步操作
- (void)test1{
    NSString *value = @"这是一行文字";
    NSString *key = @"key1";
    
    //缓存管理对象
    YYCache *yyCache = [YYCache cacheWithName:@"Name"];
    
    if ([yyCache containsObjectForKey:key]) {
        NSLog(@"存在，则获取数据");
        id value = [yyCache objectForKey:key];
        NSLog(@"%@",value);
    }else {
        NSLog(@"不存在，则存储数据");
        [yyCache setObject:value forKey:key];
    }
    
    //移除所有缓存
    //[yyCache removeAllObjects];
    //移除某一个
    //[yyCache removeObjectForKey:@"Name"];
}


//YYCache 异步操作
- (void)test2{
    NSString *value = @"这是异步一行文字";
    NSString *key = @"key1";
    
    //缓存管理对象
    YYCache *cache = [YYCache cacheWithName:@"test2"];
    
    [cache containsObjectForKey:key withBlock:^(NSString * _Nonnull key, BOOL contains) {
        if (contains) {
            NSLog(@"存在，则获取数据");
            [cache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
                NSLog(@"key = %@,value = %@",key,object);
            }];
        }else {
            NSLog(@"不存在，则存储数据");
            [cache setObject:value forKey:key withBlock:^{
                NSLog(@"存储成功");
            }];
        }
    }];
    NSLog(@"end");
    
//    [cache removeAllObjectsWithBlock:^{
//        NSLog(@"移聊所有数据");
//    }];
//
//    [cache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
//        NSLog(@"移除某一个key成功");
//    }];
    
    //移除所有数据 带进度
//    [cache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
//
//    } endBlock:^(BOOL error) {
//
//    }];
}



@end
