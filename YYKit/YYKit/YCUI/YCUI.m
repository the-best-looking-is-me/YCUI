//
//  YCUI.m
//  MangoInteraction
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import "YCUI.h"

@implementation YCUI


#pragma mark - 快速创建View
/**
 根据rect创建View
 */
+ (UIView *)ui_view:(CGRect)rect backgroundColor:(UIColor *)backColor alpha:(CGFloat)alpha cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    UIView *view = [[UIView alloc]init];
    view.frame = rect;
    if (backColor) view.backgroundColor = backColor;
    view.alpha = alpha;
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
    return view;
}

#pragma mark - 快速创建label
/**
 创建label
 */
+ (UILabel *)ui_label:(CGRect)rect lines:(NSInteger)line align:(NSTextAlignment)align font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.frame = rect;
    label.textAlignment = align;
    
    label.text = text?:@"";
    label.textColor = textColor;
    label.numberOfLines = line;
    label.font = font;
    
    return label;
}

/**
 创建label 边框
 */
+ (UILabel *)ui_label_border:(CGRect)rect borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderwidth cornerRadius:(CGFloat)cornerRadius opacity:(CGFloat)opacity lines:(NSInteger)line align:(NSTextAlignment)align font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.frame = rect;
    label.textAlignment = align;
    if (borderColor) label.layer.borderColor = borderColor.CGColor;
    label.layer.borderWidth = borderwidth;
    label.layer.cornerRadius = cornerRadius;
    label.layer.opacity = opacity;
    
    label.text = text?:@"";
    label.textColor = textColor;
    label.numberOfLines = line;
    label.font = font;
    
    return label;
}

#pragma mark - 快速创建imageView

/**
 创建图片
 
 @param rect 尺寸大小
 @param name 本地图片名称 传nil则不赋值
 @return 对象
 */
+ (UIImageView *)ui_imageView:(CGRect)rect fileName:(NSString *)name{
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = rect;
    if (name) {
        img.image = [UIImage imageNamed:name];
    }
    
    return img;
}

#pragma mark - 快速创建button

/**
 创建按扭
 
 @param rect 尺寸
 @param font 字体大小
 @param backColor 背景颜色
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param normalColor 正常字体颜色
 @param selectColor 选中字体颜色
 @param normalText 正常文字内容
 @param selectText 选中文字内容
 @param click 按扭事件
 @return 按扭对象
 */
+ (UIButton *)ui_button:(CGRect)rect font:(UIFont *)font backColor:(UIColor *)backColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor normalText:(NSString *)normalText selectText:(NSString *)selectText click:(void (^)(UIButton* x))click{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = rect;
    
    if (font > 0) btn.titleLabel.font = font;
    if (backColor) btn.backgroundColor = backColor;
    if (normalColor) [btn setTitleColor:normalColor forState:UIControlStateNormal];
    if (selectColor) [btn setTitleColor:selectColor forState:UIControlStateSelected];
    
    if (normalText) [btn setTitle:normalText forState:UIControlStateNormal];
    if (selectText) [btn setTitle:selectText forState:UIControlStateSelected];
    
    btn.layer.cornerRadius = cornerRadius;
    if (borderColor) btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = borderWidth;
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (click) {
            click(x);
        }
    }];
    return btn;
}

+ (UIButton *)ui_buttonSimple:(CGRect)rect font:(UIFont *)font normalColor:(UIColor *)normalColor normalText:(NSString *)normalText click:(void (^)(UIButton* x))click{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = rect;
    
    if (font) btn.titleLabel.font = font;
    if (normalColor) [btn setTitleColor:normalColor forState:UIControlStateNormal];
    
    if (normalText) [btn setTitle:normalText forState:UIControlStateNormal];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (click) {
            click(x);
        }
    }];
    return btn;
}

#pragma mark - 快速创建textField
/**
 创建textField
 
 @param rect 尺寸大小
 @param backColor 背景颜色
 @param font 字体大小
 @param maxNum 最大数量 传0表示没有限制
 @param placeholderColor 默认字体颜色
 @param placeholder 默认字
 @param toMaxNum 设置了最大数量后回调
 @param change 监听内容改变
 @return 对象
 */
+ (UITextField *)ui_textField:(CGRect)rect textColor:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)font maxTextNum:(NSInteger)maxNum placeholderColor:(UIColor *)placeholderColor placeholder:(NSString *)placeholder toMaxNum:(void(^)(UITextField *textField))toMaxNum change:(void(^)(UITextField *textField))change{
    
    UITextField *tf = [[UITextField alloc]init];
    tf.frame = rect;
    tf.backgroundColor = backColor;
    tf.font = font;
    if (textColor) tf.textColor = textColor;
    
    //默认字
    tf.placeholder = placeholder?:@"";
    [tf setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    if (maxNum > 0) {
        [[tf.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
            return value.length >= maxNum;
        }] subscribeNext:^(NSString * _Nullable x) {
            tf.text = [x substringToIndex:maxNum];
            if (toMaxNum) {
                toMaxNum(tf);
            }
        }];
    }
    
    [[tf rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if (change) {
            change(tf);
        }
    }];
    
    return tf;
}

#pragma mark - 快速创建textView


/**
 创建textView
 
 @param rect 尺寸大小
 @param textColor 文本颜色
 @param font 字体
 @param alignment 对齐方式
 @param inputView 附加视图
 @return 对象
 */
+ (UITextView *)ui_textView:(CGRect)rect textColor:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)font alignment:(NSTextAlignment)alignment inputView:(UIView *)inputView{
    UITextView * textView = [[UITextView alloc] init];
    if (backColor) textView.backgroundColor = backColor;
    textView.frame = rect;
    if (textColor) textView.textColor = textColor;
    if (font) textView.font = font;
    textView.textAlignment = alignment;
    if (inputView) textView.inputAccessoryView = inputView;
    
    return textView;
}



#pragma mark - 快速创建scrollView


/**
 创建scrollView
 
 @param rect 尺寸大小
 @return 对象
 */
+ (UIScrollView *)ui_scrollView:(CGRect)rect {
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = rect;
    
    return scrollView;
}



/**
 创建tableView
 
 @param rect 尺寸大小
 @param style 样式
 @param backColor 背景颜色
 @param sth 代理对象
 @param registerDic 注册内容
 @return 对象
 */
+ (UITableView *)ui_tableView:(CGRect)rect style:(UITableViewStyle)style backColor:(UIColor *)backColor delegate:(id)sth registerDic:(NSDictionary *)registerDic{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:style];
    tableView.frame = rect;
    
    tableView.separatorStyle = 0;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    tableView.delegate = sth;
    tableView.dataSource = sth;
    
    if (backColor) tableView.backgroundColor = backColor;
    
    /*
     NSDictionary *dic = @{
     @"cell":@[@{@"nib":@""},@{@"class":@""}],
     @"group":@[@{@"nib":@""},@{@"class":@""}]
     };
     */
    
    for (NSString *key in [registerDic allKeys]) {
        if ([key isEqual:@"cell"]) {
            
            NSArray *array = registerDic[key];
            for (NSDictionary *dic in array) {
                if (dic[@"nib"]) {
                    [tableView registerNib:[UINib nibWithNibName:dic[@"nib"] bundle:nil] forCellReuseIdentifier:dic[@"nib"]];
                }else if (dic[@"class"]) {
                    [tableView registerClass:[NSClassFromString(dic[@"class"]) class] forCellReuseIdentifier:dic[@"class"]];
                }
            }
            
        }else if ([key isEqual:@"group"]) {
            
            NSArray *array = registerDic[key];
            for (NSDictionary *dic in array) {
                if (dic[@"nib"]) {
                    [tableView registerNib:[UINib nibWithNibName:dic[@"nib"] bundle:nil] forHeaderFooterViewReuseIdentifier:dic[@"nib"]];
                }else if (dic[@"class"]) {
                    [tableView registerClass:[NSClassFromString(dic[@"class"]) class] forHeaderFooterViewReuseIdentifier:dic[@"class"]];
                }
            }
        }
    }
    
    return tableView;
}



/**
 创建collectionView
 
 @param rect 尺寸大小
 @param layout 布局，传nil默认
 @param backColor 背景颜色
 @param direction 方法
 @param sth 代理
 @param registerDic 注册内容
 @return 对象
 */
+ (UICollectionView *)ui_collectionView:(CGRect)rect layout:(UICollectionViewLayout *)layout cellSize:(CGSize)size backColor:(UIColor *)backColor scrollDirection:(YCCollectionDirection)direction delegate:(id)sth registerDic:(NSDictionary *)registerDic{
    
    UICollectionViewFlowLayout *flowlayout = nil;
    if (layout == nil) {
        layout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout = (UICollectionViewFlowLayout *)layout;
        [flowlayout setMinimumLineSpacing:0];
        [flowlayout setMinimumInteritemSpacing:0];
        
        flowlayout.itemSize = size;
        
        if (direction == YCCollectionDirectionVertical) {
            [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        }else if (direction == YCCollectionDirectionHorizontal) {
            [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        }
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect  collectionViewLayout:layout == nil ? flowlayout: layout];
    [collectionView setBackgroundColor:backColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = sth;
    collectionView.dataSource = sth;
    
    
    /*
     NSDictionary *dic = @{
     @"cell":@[@{@"nib":@""},@{@"class":@""}],
     @"group":@[@{@"nib_head":@""},@{@"class_foot":@""}]
     };
     */
    
    for (NSString *key in [registerDic allKeys]) {
        if ([key isEqual:@"cell"]) {
            NSArray *array = registerDic[key];
            for (NSDictionary *dic in array) {
                if (dic[@"nib"]) {
                    [collectionView registerNib:[UINib nibWithNibName:dic[@"nib"] bundle:nil] forCellWithReuseIdentifier:dic[@"nib"]];
                }else if (dic[@"class"]) {
                    [collectionView registerClass:[NSClassFromString(dic[@"class"]) class] forCellWithReuseIdentifier:dic[@"class"]];
                }
            }
            
        }else if ([key isEqual:@"group"]) {
            NSArray *array = registerDic[key];
            for (NSDictionary *dic in array) {
                if (dic[@"nib_head"]) {
                    [collectionView registerNib:[UINib nibWithNibName:dic[@"nib_head"] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dic[@"nib_head"]];
                }else if (dic[@"nib_foot"]) {
                    [collectionView registerNib:[UINib nibWithNibName:dic[@"nib_foot"] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dic[@"nib_foot"]];
                }else if (dic[@"class_head"]) {
                    [collectionView registerClass:[NSClassFromString(dic[@"class_head"]) class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dic[@"class_head"]];
                }else if (dic[@"class_foot"]) {
                    [collectionView registerClass:[NSClassFromString(dic[@"class_foot"]) class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dic[@"class_foot"]];
                }
            }
        }
    }
    
    
    return collectionView;
    
}


#pragma mark - 快速创建slider


/**
 创建滑块
 
 @param rect 尺寸大小
 @param min 最小值
 @param max 最大值
 @param selectValue 当前值
 @param minColor 滑块左边的颜色
 @param maxColor 滑块右边的颜色
 @param normalImage 正常滑块图片
 @param lightedImage 高亮滑块图片
 @param block change事件
 @return 对象
 */
+ (UISlider *)ui_slider:(CGRect)rect minValue:(CGFloat)min maxValue:(CGFloat)max selectValue:(CGFloat)selectValue minColor:(UIColor *)minColor maxColor:(UIColor *)maxColor normalImage:(UIImage *)normalImage lightedImage:(UIImage *)lightedImage changeBlock:(void(^)(UISlider *slider))block{
    UISlider *slider = [[UISlider alloc]init];
    slider.frame = rect;
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = selectValue;
    if (minColor) slider.minimumTrackTintColor = minColor;
    if (maxColor) slider.maximumTrackTintColor = maxColor;
    
    if (normalImage) [slider setThumbImage:normalImage forState:UIControlStateNormal];
    if (lightedImage) [slider setThumbImage:lightedImage forState:UIControlStateHighlighted];
    
    return slider;
}


@end
