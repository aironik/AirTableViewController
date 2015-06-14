//
//  AITSettingsDetailsProvider.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsDetailsProvider.h"

#import <AirAlertView/AirAlertView.h>

#import "AITSettings.h"
#import "AITTableViewController.h"
#import "AITValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsDetailsProvider ()

@property (nonatomic, copy) AITSettingsDetailsProviderCreateView createViewBlock;

@end


#pragma mark - Implementation


@implementation AITSettingsDetailsProvider


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

    AITSettings *settings = [AITTableViewController defaultSettings];
    Class navControllerClass = settings.navigationControllerClass;
    UINavigationController *navController = [[navControllerClass alloc] initWithRootViewController:vc];
    CGSize prefferedSize = settings.preferredPopupSize;
    navController.view.frame = CGRectMake(0.f, 0.f, prefferedSize.width, prefferedSize.height);
    
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
