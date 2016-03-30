//
//  FSTwoViewController.m
//  FSTextViewDemo
//
//  Created by 四维图新 on 16/3/28.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import "FSTwoViewController.h"
#import "UITextView+Extension.h"
#import "FSTextView.h"


@interface FSTwoViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UIView *redView;

@end

@implementation FSTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTextView];
}

- (void)setupTextView
{
    UIView *redView = [[UIView alloc] init];
    
    self.redView = redView;
    
    redView.backgroundColor = [UIColor redColor];
    
    redView.frame = CGRectMake(0, 200, self.view.bounds.size.width, 55);
    
    [self.view addSubview:redView];
    
    
//    FSTextView *textView = [[FSTextView alloc] initWithFrame:CGRectMake(50, 10, self.view.bounds.size.width - 100, 35)];
    
//    UITextView *textView = [[UITextView alloc] init];
    
    FSTextView *textView = [[FSTextView alloc] init];
    
    textView.automaticallyAdjustsTextViewHeight = YES;
    
    textView.maxHeight = @(100);
    
    textView.delegate = self;
    
    textView.font = [UIFont systemFontOfSize:18];
    
    textView.placeholder = @"Fusen Placeholder Fusen";
    
    textView.placeholderAttribute = @{NSForegroundColorAttributeName : [UIColor redColor]};
    
    textView.delegate = self;
    
    textView.frame = CGRectMake(50, 10, self.view.bounds.size.width - 100, 35);
    
    textView.layer.cornerRadius = 5;
    
    textView.layer.masksToBounds = YES;
    
    textView.layer.borderWidth = 1;
    
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [redView addSubview:textView];
    
    __weak typeof(self) weakSelf = self;
    
    textView.boundsBlcok = ^(CGFloat contentHeightChangeValue, CGRect bounds, BOOL isBoundsChanged){
        
        if (isBoundsChanged)
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = weakSelf.redView.frame;
                
                frame.size.height += contentHeightChangeValue;
                
                frame.origin.y -= contentHeightChangeValue;
                
                weakSelf.redView.frame = frame;
                
            }];
        }
        
    };
    
}

@end
