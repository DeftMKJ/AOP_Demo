//
//  ViewController.m
//  AOP_Demo
//
//  Created by mintou on 2018/3/13.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "ViewController.h"
#import "MKJViewController.h"
#import "MKJViewControllerAddDecorateAction.h"
#import "MKJVIewControllerFirstEnterAction.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    // 全集Log已经 hook出来了
    
    // 1.增加一个动态添加装饰物
    MKJViewControllerAddDecorateAction *addAction = [[MKJViewControllerAddDecorateAction alloc] init];
    addAction.addView.backgroundColor = [UIColor yellowColor];
    [self registerLifeCircleAction:addAction];
    
    // 2.第一次进入页面的时候操作
    
//    __weak typeof(self) weakSelf = self;
    MKJVIewControllerFirstEnterAction *firstAction = [[MKJVIewControllerFirstEnterAction alloc] initWithActionBlock:^(ViewController *controller, BOOL animation) {
        [controller pop:animation];
    }];
    
    [self registerLifeCircleAction:firstAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    MKJViewController *vc = [[MKJViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop:(BOOL)animation{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"第一次进来" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:action];
    [self presentViewController:vc animated:animation completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
