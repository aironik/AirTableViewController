//
//  AITChoiceValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValueWithSource.h>


/// @brief The block for generate human readable title for value.
typedef NSString *(^AITChoiceOptionTitleValueString)(NSObject *value);


@protocol AITChoiceOptionSelectorViewControllerDelegate;


/// @brief The value represent select one choice from possible set.
@interface AITChoiceValue : AITValueWithSource

/// @brief The selected option.
@property (nonatomic, strong) NSObject *value;

/// @brief The human readable string that represent value.
/// @details This value get from sourceObject[sourcePropertyName][valueStringPropertyName]
@property (nonatomic, copy, readonly) NSString *valueString;

/// @brief The code block that extract human readable title string from value.
@property (nonatomic, copy, readonly) AITChoiceOptionTitleValueString titleStringFromValue;

/// @brief The details view controller provider that creates details view controller selector.
/// @details The default implementation returns AITChoiceDetailsViewControllerProvider instance.
///     You can change provider if you need.
@property (nonatomic, strong) id<AITDetailsViewControllerProvider> detailsViewControllerProvider;

/// @brief The AITChoiceOptionSelectorViewController delegate that used while user select option.
@property (nonatomic, weak) id<AITChoiceOptionSelectorViewControllerDelegate> choiceOptionsSelectorDelegate;

/// @brief Create new value represents choice value with name.
/// @details The value should conform to AITChoiceOption protocol.
///     all values should be NSString objects.
/// @param title Human readable property name.
/// @param sourceObject the object having property for present.
/// @param sourceKeyPath the keyPath with choice that needs represent.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath;

/// @brief Create new value represents choice value with name.
/// @details The value should conform to AITChoiceOption protocol.
/// @param title Human readable property name.
/// @param sourceObject the object having property for present.
/// @param sourceKeyPath the keyPath with choice that needs represent.
/// @param titleStringFromValue block for generate human readable title for value.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
          titleStringFromValue:(AITChoiceOptionTitleValueString)titleStringFromValue;

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
         titleStringFromValue:(AITChoiceOptionTitleValueString)titleStringFromValue  NS_DESIGNATED_INITIALIZER;

@end
