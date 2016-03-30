//
//  UITextView+Extension.m
//  FSTextViewDemo
//
//  Created by 四维图新 on 16/3/28.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import "UITextView+Extension.h"
#import <objc/runtime.h>

@interface UITextView ()

@property (nonatomic, strong) NSNumber *lastHeight;

@end

@implementation UITextView (Extension)

static char associatedkey;

+ (void)load
{
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // 利用运行时交换方法执行，在分类里面，是先执行主类，再执行分类。
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self.class, @selector(selfDealloc)));
        
//        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"initWithFrame:textContainer:")), class_getInstanceMethod(self.class, @selector(selfInitWithFrame:textContainer:)));
    });
}


- (void)setMaxHeight:(NSNumber *)maxHeight
{
    objc_setAssociatedObject(self, @selector(maxHeight), maxHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)maxHeight
{
    return objc_getAssociatedObject(self, @selector(maxHeight));
}

- (void)setLastHeight:(NSNumber *)lastHeight
{
    objc_setAssociatedObject(self, @selector(lastHeight), lastHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)lastHeight
{
    return objc_getAssociatedObject(self, @selector(lastHeight));
}

- (void)setBoundsBlcok:(FSBoundsChangedBlock)boundsBlcok
{
    objc_setAssociatedObject(self, @selector(boundsBlcok), boundsBlcok, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (FSBoundsChangedBlock)boundsBlcok
{
    return objc_getAssociatedObject(self, @selector(boundsBlcok));
}

- (void)setMaxLines:(NSNumber *)maxLines
{
    objc_setAssociatedObject(self, @selector(maxLines), maxLines, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)maxLines
{
    return objc_getAssociatedObject(self, @selector(maxLines));
}

- (void)setMinLines:(NSNumber *)minLines
{
    objc_setAssociatedObject(self, @selector(minLines), minLines, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)minLines
{
    return objc_getAssociatedObject(self, @selector(minLines));
}

- (void)setLastLineCount:(NSNumber *)lastLineCount
{
    objc_setAssociatedObject(self, @selector(lastLineCount), lastLineCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)lastLineCount
{
    return objc_getAssociatedObject(self, @selector(lastLineCount));
}

- (void)setLastSizeValue:(NSValue *)lastSizeValue
{
    objc_setAssociatedObject(self, @selector(lastSizeValue), lastSizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)lastSizeValue
{
    return objc_getAssociatedObject(self, @selector(lastSizeValue));
}

- (void)setAutomaticallyAdjustsTextViewHeight:(BOOL)automaticallyAdjustsTextViewHeight
{
    if (automaticallyAdjustsTextViewHeight)
    {
        [self addObserver:self
               forKeyPath:@"contentSize"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        
        objc_setAssociatedObject(self, &associatedkey, [NSNumber numberWithBool:automaticallyAdjustsTextViewHeight], OBJC_ASSOCIATION_ASSIGN);
    }
}


- (BOOL)automaticallyAdjustsTextViewHeight
{
    BOOL result = objc_getAssociatedObject(self, &associatedkey);
    
    return result;
}


- (void)setPlaceholder:(NSString *)placeholder
{
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)placeholder
{
    return objc_getAssociatedObject(self, @selector(placeholder));
}

- (void)setPlaceholderAttribute:(NSDictionary *)placeholderAttribute
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    objc_setAssociatedObject(self, @selector(placeholderAttribute), placeholderAttribute, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)placeholderAttribute
{
    return objc_getAssociatedObject(self, @selector(placeholderAttribute));
}


- (void)textDidChanged:(NSNotification *)notification
{    
    [self setNeedsDisplay];
}

/*
 if (lineCount != self.lastLineCount && lineCount >= 1)
 {
 if (lineCount == 1 && self.lastLineCount == 0)
 {
 return;
 }
 
 CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
 
 CGFloat addHeight = lineCount > self.lastLineCount ? size.height : -size.height;
 
 
 [UIView animateWithDuration:0.25 animations:^{
 
 //            self.toolBar.frame = CGRectMake(0, toolBarY - addHeight, self.view.bounds.size.width, self.lastToolBarH + addHeight);
 //
 //            textView.frame = CGRectMake(60, 10, self.toolBar.bounds.size.width - 120, self.toolBar.bounds.size.height - 20);
 }];
 }
 */


// 需要继续优化。
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
    
    CGFloat height = contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom;
    
    NSInteger lineCount = (round(height) / self.font.lineHeight);
    
    // 行高。
//    CGFloat rowHeight = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
    
    // 判断是输入还是删除 > 0 是输入。< 0 是删除。
    NSInteger dLine = lineCount - self.lastLineCount.floatValue;
    
    self.maxLines = self.maxLines.integerValue >= 1 ? self.maxLines : @(1);
    
    self.minLines = self.minLines.integerValue >= 1 ? self.minLines : @(1);
    
    if (lineCount >= 1)
    {
        __block CGRect frame = self.frame;
        
        CGSize textSize = [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)];
        
        if ([self.lastLineCount isEqualToNumber:@(0)] && lineCount == 1)
        {
            self.lastLineCount = @(1);
            
            return;
        }
        
        if (self.frame.size.height >= self.maxHeight.floatValue && dLine > 0)
        {
            if (self.boundsBlcok)
            {
                self.boundsBlcok(0, self.bounds, NO);
            }
            
            return;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            // + self.textContainerInset.top
            
            CGFloat height = MAX(35, MIN(self.maxHeight.floatValue,textSize.height));
            
            frame.size.height = MIN(height, self.maxHeight.floatValue);
            
            self.frame = frame;
        }];
        
        if (self.boundsBlcok)
        {
            self.boundsBlcok(self.frame.size.height - self.lastHeight.floatValue, self.bounds, YES);
        }
    }
    
    self.lastLineCount = [NSNumber numberWithFloat:lineCount];
    
    self.lastHeight = [NSNumber numberWithFloat:self.frame.size.height];
}


- (void)drawRect:(CGRect)rect
{
    if([self.text length] == 0 && self.placeholder)
    {
        if (self.placeholder.length > 20)
        {
            NSString *subStr = [self.placeholder substringToIndex:20];
            
            self.placeholder = [NSString stringWithFormat:@"%@...",subStr];
        }
        
        CGRect placeHolderRect = CGRectMake(self.textContainerInset.left + 5,
                                            self.textContainerInset.top,
                                            rect.size.width,
                                            rect.size.height);
        
        if (!self.placeholderAttribute)
        {
            self.placeholderAttribute = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                          NSFontAttributeName:self.font};
        }
        else
        {
            NSMutableDictionary *dictM = [self.placeholderAttribute mutableCopy];
            
            [dictM setObject:self.font forKey:NSFontAttributeName];
            
            self.placeholderAttribute = dictM;
        }
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.placeholder drawInRect:placeHolderRect
                          withAttributes:self.placeholderAttribute];
        }
    }
}


- (void)selfDealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
    
    if (self.automaticallyAdjustsTextViewHeight)
    {
        [self removeObserver:self
                  forKeyPath:@"contentSize"
                     context:nil];
    }
}



@end
