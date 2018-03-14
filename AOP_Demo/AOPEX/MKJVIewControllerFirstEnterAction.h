//
//  MKJVIewControllerFirstEnterAction.h
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "MKJViewLifeCircleBaseAction.h"

typedef void(^MKJViewControllerFirstAppearBlock)(id controller,BOOL animation);

@interface MKJVIewControllerFirstEnterAction : MKJViewLifeCircleBaseAction

@property (nonatomic,copy) MKJViewControllerFirstAppearBlock actionBlock;

- (instancetype)initWithActionBlock:(MKJViewControllerFirstAppearBlock)block;

@end
