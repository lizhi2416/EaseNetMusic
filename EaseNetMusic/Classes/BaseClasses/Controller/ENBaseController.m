//
//  ENBaseController.m
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

#import "ENBaseController.h"

@interface ENBaseController ()

@end

@implementation ENBaseController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.en_interactivePopGesZone = -1.0;
        self.en_interactivePopDisabled = NO;
        self.en_prefersNavigationBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)pushEffectFromLeftToVC:(UIViewController *)vc {
    [self pushEffectType:kCATransitionFromLeft];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)popEffectFromLeft {
    [self popEffectType:kCATransitionFromRight];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)pushEffectPresentToVC:(UIViewController*)vc{
    [self pushEffectType:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)popEffectDismiss{
    [self popEffectType:kCATransitionFromBottom];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)popEffectType:(NSString *)type {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.24;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype  = type;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

- (void)pushEffectType:(NSString *)type {
    [self pushEffectType:type currentVC:self];
}

- (void)pushEffectType:(NSString *)type currentVC:(UIViewController *)currentVC{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = type;
    [currentVC.navigationController.view.layer addAnimation:transition forKey:nil];
}

@end
