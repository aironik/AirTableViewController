//
//  AITValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITResponderValue.h>


@protocol AITValueDelegate;

/// @brief Protocol defines value in the table view cell
@interface AITValue : AITResponderValue

/// @brief The value represents whether value is empty and should not be interactable.
/// @details If NO cell hides.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/// @brief The string that represent human readable title.
@property (nonatomic, copy, readonly) NSString *title;

/// @brief The delegate that executes external actions for value e.g. scroll to visible or insert additional cell.
@property (nonatomic, assign) NSObject<AITValueDelegate> *delegate;

/// @brief Initialize new instance with the title string.
/// @details This if designated initializer.
- (instancetype)initWithTitle:(NSString *)title;

/// @brief The table view cell identifier for register and deque from table view.
+ (NSString *)cellIdentifier;

/// @brief Perform action for value if user interact with cell.
- (void)perform;


@end
