//
//  AITSettingsDetailsProvider.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsDetailsProvider.h"

#import <AirAlertView/AirAlertView.h>


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsDetailsProvider ()

@property (nonatomic, copy) AITSettingsDetailsProviderCreateView createViewBlock;

@end


#pragma mark - Implementation


@implementation AITSettingsDetailsProvider


#define AIT_IMPLEMENT_SETTINGS(settingName, typeName, defaultValue) \
    static typeName statc##settingName; \
    \
    + (void)register##settingName:(typeName)value { \
        statc##settingName = value; \
    } \
    \
    - (typeName)get##settingName { \
        static dispatch_once_t predicate; \
        dispatch_once(&predicate, ^{ \
            statc##settingName = defaultValue; \
        }); \
        return statc##settingName; \
    }


AIT_IMPLEMENT_SETTINGS(NavigationControllerClass, Class, [UINavigationController class])
AIT_IMPLEMENT_SETTINGS(PreferredFrame, CGRect, CGRectMake(0., 0., 560., 560.))


+ (instancetype)providerWithCreateViewBlock:(AITSettingsDetailsProviderCreateView)createViewBlock {
    NSParameterAssert(createViewBlock != NULL);
    return [[self alloc] initWithCreateViewBlock:createViewBlock];
}

- (instancetype)initWithCreateViewBlock:(AITSettingsDetailsProviderCreateView)createViewBlock {
    NSParameterAssert(createViewBlock != NULL);
    if ((self = [super init]) && createViewBlock != NULL) {
        _createViewBlock = [createViewBlock copy];
        _presentationStyle = AITDetailsPresentationStyleCustom;
    }
    else {
        self = nil;
    }
    return self;
}

- (UIViewController *)detailsViewControllerForValue:(AITValue *)value {
    return self.createViewBlock(value);
}

- (void)presentDetailsViewControllerForValue:(AITValue *)value fromViewController:(UIViewController *)viewController {
    [value resignFirstAitResponder];
    
    UIViewController *vc = [self detailsViewControllerForValue:value];
    
    Class navControllerClass = [[self class] getNavigationControllerClass];
    UINavigationController *navController = [[navControllerClass alloc] initWithRootViewController:vc];
    navController.view.frame = (CGRect)[[self class]  getPreferredFrame];
    
    AIAModalView *modalView = [[AIAModalView alloc] init];
    modalView.contentViewController = navController;
    modalView.hideOnTapOutside = NO;

    __weak AIAModalView *weakModalView = modalView;
    if ([vc respondsToSelector:@selector(setCloseBlock:)]) {
            [(id)vc setCloseBlock:^ { __strong AIAModalView *strongModalView = weakModalView; [strongModalView dismiss]; }];
        }
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                         target:modalView
                                                                                         action:@selector(dismiss)];

    [modalView show];
}


@end
