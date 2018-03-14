//
//  MKJVIewControllerFirstEnterAction.m
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "MKJVIewControllerFirstEnterAction.h"

@interface MKJVIewControllerFirstEnterAction ()

@property (nonatomic,assign) BOOL isFirstAppear; // 第一次进入

@end

@implementation MKJVIewControllerFirstEnterAction



- (instancetype)initWithActionBlock:(MKJViewControllerFirstAppearBlock)block{
    self = [super init];
    if (self) {
        _isFirstAppear = YES;
        _actionBlock = block;
    }
    return self;
}

- (void)hookViewController:(UIViewController *)controller viewWillAppear:(BOOL)animated{
    [super hookViewController:controller viewWillAppear:animated];
    if (_isFirstAppear) {
        if (_actionBlock) {
            _actionBlock(controller,animated);
        }
        _isFirstAppear = NO;
    }
    
}

@end
