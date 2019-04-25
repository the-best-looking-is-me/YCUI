//
//  SecondVC.h
//  Reactive用法
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"


@interface SecondVC : UIViewController

@property (nonatomic,copy)NSString *name;

@property (nonatomic,strong) RACSubject *delegateSignal;



@end
