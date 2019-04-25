//
//  YCCollectionViewCell.m
//  RAC
//
//  Created by yangchang on 2019/4/18.
//  Copyright © 2019 yangchang. All rights reserved.
//

#import "YCCollectionViewCell.h"

@interface YCCollectionViewCell ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation YCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // insert here
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        self.contentView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_label];
    }return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = self.contentView.bounds.size.height;
    // insert here
    _label.frame = CGRectMake(0, 0, w, h);
}

//- (void)refreshUI:(id)model;
- (void)refreshUI:(id)model{
    _label.text = model;
}



@end
