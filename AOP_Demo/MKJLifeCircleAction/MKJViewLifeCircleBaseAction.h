//
//  MKJViewLifeCircleBaseAction.h
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 基类 所有切片的基类 通过vc的周期函数进行处理
 */
@interface MKJViewLifeCircleBaseAction : NSObject

@property (nonatomic,strong,readonly) UIViewController *liveViewController;


- (void)hookViewController:(UIViewController *)controller viewWillAppear:(BOOL)animated;

- (void)hookViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated;

- (void)hookViewController:(UIViewController *)controller viewWillDisappear:(BOOL)animated;

- (void)hookViewController:(UIViewController *)controller viewDidDisappear:(BOOL)animation;


@end
