//
//  AITSettingsChoiceValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsChoiceValue.h"

#import "AITSettingsChoiceOptionSelectorDelegate.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsChoiceValue ()

/*
 * @brief This property is using as default retained delegate.
 */
@property(nonatomic, strong) AITSettingsChoiceOptionSelectorDelegate *choiceOptionsSelectorStrongDelegate;

@end


#pragma mark - Implementation


@implementation AITSettingsChoiceValue


@synthesize choiceOptionsSelectorStrongDelegate = _choiceOptionsSelectorStrongDelegate;


+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
          titleStringFromValue:(AITChoiceOptionTitleValueString)titleStringFromValue
{
    AITSettingsChoiceValue *value = [super valueWithTitle:title
                                             sourceObject:sourceObject
                                            sourceKeyPath:sourceKeyPath
                                     titleStringFromValue:titleStringFromValue];
    value.enabled = YES;
    return value;
}

- (id<AITChoiceOptionSelectorViewControllerDelegate>)choiceOptionsSelectorDelegate {
    id<AITChoiceOptionSelectorViewControllerDelegate> result = [super choiceOptionsSelectorDelegate];
    if (result == nil) {
        result = self.choiceOptionsSelectorStrongDelegate;
    }
    return result;
}

- (AITSettingsChoiceOptionSelectorDelegate *)choiceOptionsSelectorStrongDelegate {
    if (_choiceOptionsSelectorStrongDelegate == nil) {
        _choiceOptionsSelectorStrongDelegate = [[AITSettingsChoiceOptionSelectorDelegate alloc] init];
    }
    return _choiceOptionsSelectorStrongDelegate;
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return self.enabled;
}


@end
