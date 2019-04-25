//
//  SecondVC.m
//  Reactive用法
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import "SecondVC.h"
#import "YCUI.h"
#import "YCTimeManager.h"
#import "YCBaseTableViewCell.h"
#import "YCCollectionViewCell.h"

@interface SecondVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation SecondVC

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50 , 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Class class = YCCollectionViewCell.class;
    YCCollectionViewCell * cell = (YCCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(class) forIndexPath:indexPath];
    [cell refreshUI:self.datas[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)dealloc{
    NSLog(@"ok");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第二页";
    //[self test4];
    
    //[self test3];
    
    //[self test2];
    
    //[self test1];
    
    //[self setUI];
    
//    [YCTimeManager timeCodeVerify:10 block:^(NSInteger second) {
//        NSLog(@"second = %zd",second);
//    }];
    
    _collectionView = [YCUI ui_collectionView:self.view.bounds layout:nil cellSize:CGSizeZero backColor:[UIColor whiteColor] scrollDirection:YCCollectionDirectionVertical delegate:self registerDic:@{@"cell":@[@{@"class":@"YCCollectionViewCell"}]}];
    self.datas = [@[@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4"] mutableCopy];
    [self.view addSubview:_collectionView];

}

#pragma mark - UITextField
- (void)test4{
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 200, 100, 40)];
    tf.backgroundColor = [UIColor lightGrayColor];
    [tf.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"=%@",x);
    }];
    [self.view addSubview:tf];
}

#pragma mark - UIButton 点击事件
- (void)test3{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 200, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了按扭啊...");
    }];
    [self.view addSubview:btn];
}

#pragma mark - RACReplaySubject
- (void)test2{
    /*
     适合：
     先发送
     再订阅
     （遍历发送来调用订阅）
     */
    RACReplaySubject *replay = [RACReplaySubject subject];
    [replay sendNext:@1];
    //[replay sendNext:@2];
    
    [replay subscribeNext:^(id x) {
        NSLog(@"1:%@",x);
    }];
    [replay subscribeNext:^(id x) {
        NSLog(@"2:%@",x);
    }];
}

#pragma mark - RACSubject
- (void)test1{
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    // 3.发送信号
    [subject sendNext:@"1"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.delegateSignal) {
        //回调
        [self.delegateSignal sendNext:@"我点击了空白部分"];
    }
    
    [self btnClick:nil];
    
    self.name = @"534";
}

- (void)btnClick:(id)sth{
    NSLog(@"btnClick");
}


- (void)setUI{
    
}



@end
























