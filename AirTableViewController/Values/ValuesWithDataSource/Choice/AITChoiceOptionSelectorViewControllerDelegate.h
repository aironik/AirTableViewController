//
//  AITChoiceOptionSelectorViewControllerDelegate.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 05.11.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITChoiceOptionSelectorViewController;
@class AITChoiceValue;


/// @brief The protocol that encapsulates actions for select possible option.
@protocol AITChoiceOptionSelectorViewControllerDelegate<NSObject>

@required

/// @brief Tells the delegate initial setup AITChoiceOptionSelectorViewController.
/// @details The choice options controller should setup before appear.
///     You should setup allOptions array. Also you can make additional settings and start long update operations.
- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
            didStartForValue:(AITChoiceValue *)value;

/// @brief Tells the delegate finish.
/// @details The delegate can make some long time process. In this method the delegate can stop some operations.
- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
             didStopForValue:(AITChoiceValue *)value;

/// @brief If YES search bar shown.
- (BOOL)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
         allowFilterForValue:(AITChoiceValue *)value;

/// @brief Tells the delegate that user have changed filter text.
/// @details this selector should update 
- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
            filterDidChanged:(NSString *)filter
                    forValue:(AITChoiceValue *)value;

@end
