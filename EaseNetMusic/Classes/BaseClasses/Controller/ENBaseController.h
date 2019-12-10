//
//  ENBaseController.h
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ENBaseController : UIViewController

- (void)pushEffectPresentToVC:(UIViewController*)vc;
- (void)popEffectDismiss;

- (void)pushEffectFromLeftToVC:(UIViewController *)vc;

- (void)popEffectFromLeft;

- (void)popEffectType:(NSString *)type;

- (void)pushEffectType:(NSString *)type;

- (void)pushEffectType:(NSString *)type currentVC:(UIViewController *)currentVC;

@end

NS_ASSUME_NONNULL_END
