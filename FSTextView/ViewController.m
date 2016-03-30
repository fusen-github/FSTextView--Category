//
//  ViewController.m
//  ceshi
//
//  Created by 四维图新 on 16/3/28.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import "ViewController.h"
//#import "UITextView+Extension.h"
#import "FSTwoViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"left" style:0 target:self action:@selector(didCilck)];
    
}

- (void)didCilck
{
    FSTwoViewController *twoVC = [[FSTwoViewController alloc] init];
    
    [self.navigationController pushViewController:twoVC animated:YES];
}


@end
