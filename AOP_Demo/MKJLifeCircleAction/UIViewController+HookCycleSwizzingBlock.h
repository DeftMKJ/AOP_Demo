//
//  UIViewController+HookCycleSwizzingBlock.h
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKJViewLifeCircleBaseAction.h"

@interface UIViewController (HookCycleSwizzingBlock)


- (MKJViewLifeCircleBaseAction *)registerLifeCircleAction:(MKJViewLifeCircleBaseAction *)action;

- (void)removeLifeCircleAction:(MKJViewLifeCircleBaseAction *)action;


FOUNDATION_EXTERN void MKJViewControllerRegisterGlobalAction(MKJViewLifeCircleBaseAction *action);

FOUNDATION_EXTERN void MKJViewControllerRemoveGlobalAction(MKJViewLifeCircleBaseAction *action);


@end
