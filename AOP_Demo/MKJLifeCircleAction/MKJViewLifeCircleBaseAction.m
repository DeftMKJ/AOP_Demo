//
//  MKJViewLifeCircleBaseAction.m
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "MKJViewLifeCircleBaseAction.h"

@interface MKJViewLifeCircleBaseAction ()

@property (nonatomic,strong) UIViewController *liveViewController;

@end


@implementation MKJViewLifeCircleBaseAction

- (void)hookViewController:(UIViewController *)controller viewWillAppear:(BOOL)animated{
    _liveViewController = controller;
}

- (void)hookViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated{
    
}

- (void)hookViewController:(UIViewController *)controller viewWillDisappear:(BOOL)animated{
    
}

- (void)hookViewController:(UIViewController *)controller viewDidDisappear:(BOOL)animation{
    _liveViewController = nil;
}

@end
