//
//  AITChoiceOptionSelectorViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 21.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITChoiceValue;
@protocol AITChoiceOptionSelectorViewControllerDelegate;


/// @brief The view controller that helps select single option from possible options set.
@interface AITChoiceOptionSelectorViewController : UITableViewController

/// @brief The choice value for setup (the data source).
@property (nonatomic, strong, readonly) AITChoiceValue *choiceValue;

/// @brief The choice selector delegate that helps handle events and choose option.
@property (nonatomic, weak) id<AITChoiceOptionSelectorViewControllerDelegate> delegate;

/// @brief The array that contains all possible options.
/// @details While present for each item get title by calling titleStringFromValue(item) block on the self.choiceValue.
///     This array current shown options list for current filter.
/// @see AITChoiceValue
@property (nonatomic, strong) NSArray *allOptions;

/// @brief The array contains that contains options corresponds to current filter.
/// @details This value can setup from -choiceOptionSelector:filterDidChanged:forValue:
///     or after some time after invokation.
@property (nonatomic, strong) NSArray *filteredOptions;

/// @brief Create new instance and initialize with new value.
+ (instancetype)choiceOptionSelectorWithValue:(AITChoiceValue *)value;

@end
