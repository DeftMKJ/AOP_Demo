//
//  MKJViewControllerAddDecorateAction.m
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "MKJViewControllerAddDecorateAction.h"

@interface MKJViewControllerAddDecorateAction ()

@property (nonatomic,strong) UIView *addView;

@end

@implementation MKJViewControllerAddDecorateAction

- (UIView *)addView{
    if (_addView == nil) {
        _addView = [[UIView alloc] init];
    }
    return _addView;
}

- (void)hookViewController:(UIViewController *)controller viewWillAppear:(BOOL)animated{
    [super hookViewController:controller viewDidAppear:animated];
    
    controller.view.backgroundColor = [UIColor blueColor];
    [controller.view addSubview:self.addView];
    self.addView.frame = CGRectMake(100, 100, 100, 100);
}

@end
