//
//  FSTextView.m
//  FSTextView
//
//  Created by 四维图新 on 16/3/30.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import "FSTextView.h"

@implementation FSTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer])
    {
//        NSLog(@"111");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        NSLog(@"222");
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
//        NSLog(@"333");
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        NSLog(@"444");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"主类来了");
}



@end
