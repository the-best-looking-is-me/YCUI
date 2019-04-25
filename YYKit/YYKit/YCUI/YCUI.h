//
//  YCUI.h
//  MangoInteraction
//
//  Created by yangchang on 2017/7/9.
//  Copyright © 2017 yangchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCUI : NSObject


typedef enum YCCollectionDirection
{
    YCCollectionDirectionVertical,
    YCCollectionDirectionHorizontal
    
}YCCollectionDirection;

/**
 根本rect创建View
 */
+ (UIView *)ui_view:(CGRect)rect backgroundColor:(UIColor *)backColor alpha:(CGFloat)alpha cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 创建label
 */
+ (UILabel *)ui_label:(CGRect)rect lines:(NSInteger)line align:(NSTextAlignment)align font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text;

/**
 创建label 边框
 */
+ (UILabel *)ui_label_border:(CGRect)rect borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderwidth cornerRadius:(CGFloat)cornerRadius opacity:(CGFloat)opacity lines:(NSInteger)line align:(NSTextAlignment)align font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text;

/**
 创建imageView
 */
+ (UIImageView *)ui_imageView:(CGRect)rect fileName:(NSString *)name;

/**
 创建button
 */
+ (UIButton *)ui_button:(CGRect)rect font:(UIFont *)font backColor:(UIColor *)backColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor normalText:(NSString *)normalText selectText:(NSString *)selectText click:(void (^)(UIButton* x))click;


/**
 简易创建button
 */
+ (UIButton *)ui_buttonSimple:(CGRect)rect font:(UIFont *)font normalColor:(UIColor *)normalColor normalText:(NSString *)normalText click:(void (^)(UIButton* x))click;

/**
 创建textField
 */
+ (UITextField *)ui_textField:(CGRect)rect textColor:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)font maxTextNum:(NSInteger)maxNum placeholderColor:(UIColor *)placeholderColor placeholder:(NSString *)placeholder toMaxNum:(void(^)(UITextField *textField))toMaxNum change:(void(^)(UITextField *textField))change;

/**
 创建textView
 */
+ (UITextView *)ui_textView:(CGRect)rect textColor:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)font alignment:(NSTextAlignment)alignment inputView:(UIView *)inputView;

/**
 创建scrollView
 */
+ (UIScrollView *)ui_scrollView:(CGRect)rect;


/**
 创建tableView
 */
+ (UITableView *)ui_tableView:(CGRect)rect style:(UITableViewStyle)style backColor:(UIColor *)backColor delegate:(id)sth registerDic:(NSDictionary *)registerDic;


/**
 创建collectionView
 */
+ (UICollectionView *)ui_collectionView:(CGRect)rect layout:(UICollectionViewLayout *)layout cellSize:(CGSize)size backColor:(UIColor *)backColor scrollDirection:(YCCollectionDirection)direction delegate:(id)sth registerDic:(NSDictionary *)registerDic;

/**
 创建滑块
 */
+ (UISlider *)ui_slider:(CGRect)rect minValue:(CGFloat)min maxValue:(CGFloat)max selectValue:(CGFloat)selectValue minColor:(UIColor *)minColor maxColor:(UIColor *)maxColor normalImage:(UIImage *)normalImage lightedImage:(UIImage *)lightedImage changeBlock:(void(^)(UISlider *slider))block;

@end

NS_ASSUME_NONNULL_END
