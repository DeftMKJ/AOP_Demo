//
//  MKJViewControllerLogAction.m
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "MKJViewControllerLogAction.h"

@implementation MKJViewControllerLogAction

// 全局注册
+ (void)load{
    MKJViewControllerRegisterGlobalAction([[MKJViewControllerLogAction alloc] init]);
}

- (void)hookViewController:(UIViewController *)controller viewWillAppear:(BOOL)animated{
    [super hookViewController:controller viewWillAppear:animated];
    NSLog(@"ViewController---->%@-------SEL------>%@",controller,NSStringFromSelector(_cmd));
}

- (void)hookViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated{
    [super hookViewController:controller viewDidAppear:animated];
}

- (void)hookViewController:(UIViewController *)controller viewWillDisappear:(BOOL)animated{
    [super hookViewController:controller viewWillDisappear:animated];
    NSLog(@"ViewController---->%@-------SEL------>%@",controller,NSStringFromSelector(_cmd));
}

- (void)hookViewController:(UIViewController *)controller viewDidDisappear:(BOOL)animation{
    [super hookViewController:controller viewDidDisappear:animation];
}

@end
