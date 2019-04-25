//
//  ViewController.m
//  RAC
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "YCUI.h"
#import "SecondVC.h"
#import "YYKitViewController.h"


@interface ViewController ()

@property (nonatomic,strong) RACCommand *command;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self test1];
    //[self testSignal];
    //[self testMul];
    //[self testNetWork];
    //[self testTmp];
    
    //[self snjj_test];
    [self snjj];
    
    __weak typeof(self) weakSelf = self;
    UIButton *yykitBtn = [YCUI ui_buttonSimple:CGRectMake(0, 200, 100, 40) font:[UIFont systemFontOfSize:14] normalColor:[UIColor blackColor] normalText:@"yykit" click:^(UIButton * _Nonnull x) {
        YYKitViewController *kit = [YYKitViewController new];
        kit.title = @"yykit";
        [weakSelf.navigationController pushViewController:kit animated:YES];
    }];
    [self.view addSubview:yykitBtn];
    
}

#pragma mark - 一个实例
- (void)snjj{
    RACSignal *s = [self snjj_test];
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"sub = %@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    }];
}

- (RACSignal *)snjj_test{
    
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"createSignal"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            //NSLog(@"取消操作");
        }];
    }];
    
    void (^extraHandlerSingal)(id value) = ^(RACTuple * value) {};

    RACSignal *s = [[[requestSignal catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        return nil;
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"value = %@",value);
        return nil;
    }] doNext:^(id  _Nullable x) {
        NSLog(@"doNext = %@",x);
    }];
    
    return s;
}

#pragma mark - 集合遍历
- (void)testArr_Dic{
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        //NSLog(@"数组：%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        //NSLog(@"字典：%@ %@",key,value);
        
    }];
}

#pragma mark - RACSignal 普通用法
- (void)testSignal{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:@"测试"];
        return nil;
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"testSignal = %@",x);
    }];
    
    /*
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subnext = %@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    }];
     */
    
}

#pragma mark - 多个处理返回后，再处理其他操作
- (void)test1{
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        NSLog(@"222");
        return nil;
    }];
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        NSDictionary *dic = @{@"1": @"111",@"2": @"222"};
        [subscriber sendNext:dic];
        NSLog(@"111");
        return nil;
    }];
    
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}

- (void)updateUIWithR1:(id)data r2:(id)data1{
    NSLog(@"更新UI%@  %@",data,data1);
}

#pragma mark - RACMulticastConnection
- (void)testMul{
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求

    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者一信号:%@",x);
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二信号:%@",x);
        
    }];
    
    // 4.连接,激活信号
    [connect connect];
}

#pragma mark - RACCommand 普通写法

- (void)testTmp{
    // RACCommand: 处理事件
    // 不能返回空的信号
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"input = %@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    // 如何拿到执行命令中产生的数据呢？
    // 订阅命令内部的信号
    // ** 方式一：直接订阅执行命令返回的信号
    
    // 2.执行命令
    RACSignal *signal =[command execute:@2]; // 这里其实用到的是replaySubject 可以先发送命令再订阅
    // 在这里就可以订阅信号了
    [signal subscribeNext:^(id x) {
        NSLog(@"subscribeNext = %@",x);
    }];

}

#pragma mark - RACCommand 高级写法
- (void)testNetWork{
    // 六、使用场景,监听按钮点击，网络请求
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"RACCommand input = %@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"发送信号"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
    //switchToLatest获取最新发送的信号，只能用于信号中信号。
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"subscribeNext = %@", x);
    }];
    
    //注意：这里必须是先订阅才能发送命令
    /*
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"subscribeNext = %@", x);
        }];
    }];
     */

    
    // 监听事件有没有完成
    /*
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
     */

    // 2.执行命令
    [command execute:@3];
}

#pragma mark - 回调 代理 观察者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SecondVC * vc = (SecondVC *)[board instantiateViewControllerWithIdentifier:@"SecondVC"];
    
    SecondVC *vc =[[SecondVC alloc] init];
    vc.delegateSignal = [RACSubject subject];
    
    [vc.delegateSignal subscribeNext:^(NSString * x) {
        NSLog(@"回调：%@",x);
        self.view.backgroundColor = [UIColor redColor];
        
        return ;
    }];
    
    // 代理
    [[vc rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"BtnClick触发了");
        
    }];
    
    // 观察者
    [[vc rac_valuesAndChangesForKeyPath:@"name" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"name = %@",x);
    }];

    [self.navigationController pushViewController:vc animated:YES];
}

@end
