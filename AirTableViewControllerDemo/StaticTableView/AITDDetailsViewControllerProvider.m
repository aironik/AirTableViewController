//
//  AITDDetailsViewControllerProvider.m
//  AirTableViewControllerDemo
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.07.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AITDDetailsViewControllerProvider.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDDetailsViewControllerProvider ()
@end


#pragma mark - Implementation


@implementation AITDDetailsViewControllerProvider


- (AITDetailsPresentationStyle)presentationStyle {
    return AITDetailsPresentationStyleCustom;
}

- (UIViewController *)detailsViewControllerForValue:(AITValue *)value {
    UIViewController *result = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100., 100., 150., 150.)];
    label.text = @"Details View";
    [result.view addSubview:label];
    result.view.backgroundColor = [UIColor whiteColor];
    return result;
}

- (void)presentDetailsViewControllerForValue:(AITValue *)value fromViewController:(UIViewController *)viewController {
    [viewController.navigationController pushViewController:[self detailsViewControllerForValue:value] animated:YES];
}


@end
