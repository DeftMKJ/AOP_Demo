//
//  UIViewController+HookCycleSwizzingBlock.m
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "UIViewController+HookCycleSwizzingBlock.h"
#import <objc/runtime.h>
// 交换方法
void MKJControllerLifeCircleSwizzInstance(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 挂载的Key
static void *MKJViewAppearKey = &MKJViewAppearKey;

typedef void(^MKJAOPActionBlock)(MKJViewLifeCircleBaseAction *action);


// 全局Action存储的懒加载
NSMutableArray * MKJViewControllerGlobalAction() {
    static NSMutableArray *mutableArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mutableArray = [[NSMutableArray alloc] init];
    });
    return mutableArray;
}

// 全局注册到单利数组中
void MKJViewControllerRegisterGlobalAction(MKJViewLifeCircleBaseAction *action){
    void(^Register)(void) = ^(void) {
        NSMutableArray* actions = MKJViewControllerGlobalAction();
        if (![actions containsObject:action]) {
            [actions addObject:action];
        }
    };
    
    if ([NSThread mainThread]) {
        Register();
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            Register();
        });
    }
}


// 移除
void MKJViewControllerRemoveGlobalAction(MKJViewLifeCircleBaseAction *action){
    void(^Remove)(void) = ^(void) {
        NSMutableArray* actions = MKJViewControllerGlobalAction();
        if ([actions containsObject:action]) {
            [actions removeObject:action];
        }
    };
    if ([NSThread mainThread]) {
        Remove();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            Remove();
        });
    }
}


@implementation UIViewController (HookCycleSwizzingBlock)

- (void)setLifeCircleAction:(NSArray *)array{
    objc_setAssociatedObject(self, MKJViewAppearKey, array, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)getLifeCircleAction
{
    NSArray *array = objc_getAssociatedObject(self, MKJViewAppearKey);
    // 如果第一次没有获取到 是 nil if不会成立
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return [NSArray array];
}

// 根据页面注册  把需要切入的操作绑定 挂载到对应的VC上面，这个不是全局的，是根据VC绑定的数组的
- (MKJViewLifeCircleBaseAction* )registerLifeCircleAction:(MKJViewLifeCircleBaseAction *)action
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:[self getLifeCircleAction]];
    if ([array containsObject:action]) {
        for (MKJViewLifeCircleBaseAction* act in array) {
            if ([action isEqual:act]) {
                return act;
            }
        }
    }
    [array addObject:action];
    [self setLifeCircleAction:array];
    return action;
}

// 移除
- (void) removeLifeCircleAction:(MKJViewLifeCircleBaseAction *)action
{
    NSArray* array = [self getLifeCircleAction];
    NSInteger index = [array indexOfObject:action];
    if (index == NSNotFound) {
        return;
    }
    NSMutableArray* mArray = [NSMutableArray arrayWithArray:array];
    [mArray removeObjectAtIndex:index];
    [self setLifeCircleAction:array];
}


+ (void)load{
    Class viewControllerClass = [UIViewController class];
    MKJControllerLifeCircleSwizzInstance(viewControllerClass,@selector(viewDidAppear:),@selector(mkj_hook_viewDidAppear:));
    MKJControllerLifeCircleSwizzInstance(viewControllerClass, @selector(viewDidDisappear:), @selector(mkj_hook_viewDidDisappear:));
    MKJControllerLifeCircleSwizzInstance(viewControllerClass, @selector(viewWillAppear:), @selector(mkj_hook_viewWillAppear:));
    MKJControllerLifeCircleSwizzInstance(viewControllerClass, @selector(viewWillDisappear:), @selector(mkj_hook_viewWillDisappear:));
}


// 四个 hook出来的方法
- (void)mkj_hook_viewWillAppear:(BOOL)animated{
    [self mkj_hook_viewWillAppear:animated];
    [self mkj_hook_performAction:^(MKJViewLifeCircleBaseAction *action) {
        if ([action respondsToSelector:@selector(hookViewController:viewWillAppear:)]) {
            [action hookViewController:self viewWillAppear:animated];
        }
    }];
}

- (void)mkj_hook_viewDidAppear:(BOOL)animated{
    [self mkj_hook_viewDidAppear:animated];
    [self mkj_hook_performAction:^(MKJViewLifeCircleBaseAction *action) {
        if ([action respondsToSelector:@selector(hookViewController:viewDidAppear:)]) {
            [action hookViewController:self viewDidAppear:animated];
        }
    }];
}


- (void)mkj_hook_viewWillDisappear:(BOOL)animated{
    [self mkj_hook_viewWillDisappear:animated];
    [self mkj_hook_performAction:^(MKJViewLifeCircleBaseAction *action) {
        if ([action respondsToSelector:@selector(hookViewController:viewWillDisappear:)]) {
            [action hookViewController:self viewWillDisappear:animated];
        }
    }];
}

- (void)mkj_hook_viewDidDisappear:(BOOL)animated{
    [self mkj_hook_viewDidDisappear:animated];
    [self mkj_hook_performAction:^(MKJViewLifeCircleBaseAction *action) {
        if ([action respondsToSelector:@selector(hookViewController:viewDidDisappear:)]) {
            [action hookViewController:self viewDidDisappear:animated];
        }
    }];
}


- (void)mkj_hook_performAction:(MKJAOPActionBlock)block{
    // 1.获取全局Action  单利
    MKJCallBackAction([MKJViewControllerGlobalAction() copy], block);
    
    // 获取挂载的Action  根据页面存储的数组
    MKJCallBackAction([[self getLifeCircleAction] copy], block);
}


// 执行 Action
void MKJCallBackAction(NSArray* actions, MKJAOPActionBlock block) {
    for (MKJViewLifeCircleBaseAction* action in actions) {
        if (block) {
            block(action);
        }
    }
}



@end



