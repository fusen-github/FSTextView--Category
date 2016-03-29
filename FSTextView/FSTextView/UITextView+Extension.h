//
//  UITextView+Extension.h
//  FSTextViewDemo
//
//  Created by 四维图新 on 16/3/28.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
 *
 *  @param contentHeightChangeValue 内容的高度的变化量
 *  @param bounds                   textView的总的bounds
 *  @param isBoundsChanged          bool,记录bounds是否发生变化
 */
typedef void(^FSBoundsChangedBlock)(CGFloat contentHeightChangeValue, CGRect bounds, BOOL isBoundsChanged);

@interface UITextView (Extension)

/**
 *  默认最多显示20个字符，超过的部分显示...
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  默认placeholder的字体大小和textView的字体大小是保持一样的。
    所以只需要设置textView的字体就行
 */
@property (nonatomic, strong) NSDictionary *placeholderAttribute;

/**
 *  根据输入内容自动调整textView的高度。默认是 NO
 */
@property (nonatomic, assign) BOOL automaticallyAdjustsTextViewHeight;


///**
// *  当automaticallyAdjustsTextViewHeight为YES时设置才有效。
// *  取值范围 >=  minLines   默认 == 1
// *  当输入内容的行数 > maxLines时，textView的高度达到最大值，textView的内容可滚动。
// */
//@property (nonatomic, strong) NSNumber *maxLines;

/**
 *  textView最大的高度。和 maxLines 属性的效果一样，用来替代 maxLines 属性
 */
@property (nonatomic, strong) NSNumber *maxHeight;

/**
 *  当automaticallyAdjustsTextViewHeight为YES时设置才有效。
 *  当textView的textContentSize有变化时调用，在block里面更新frame。
 */
@property (nonatomic, copy) FSBoundsChangedBlock boundsBlcok;

@end
