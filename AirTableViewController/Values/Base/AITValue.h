//
//  AITValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponder.h>


@protocol AITDetailsViewControllerProvider;


/// @brief The notification name that posts over default NSNotificationCenter if value become first responder.
extern NSString *const kAITValueBecomeFirstAitResponder;

/// @brief The notification name that posts over default NSNotificationCenter if value resign first responder.
extern NSString *const kAITValueResignFirstAitResponder;


@protocol AITValueDelegate;

/// @brief Protocol defines value in the table view cell
@interface AITValue : NSObject<AITResponder>

/// @brief The boolean value that indicates whether value is first ait responder.
/// @details Normally this value set from -becomeFirstAitResponder or -resignFirstAitResponder.
@property (nonatomic, assign, getter=isFirstAitResponder) BOOL firstAitResponder;

/// @brief The next responder. The AITTableView setup this value next section.
@property (nonatomic, weak) id<AITResponder> nextAitResponder;

/// @brief The value represents whether value is empty and should not be interactable.
/// @details If NO cell hides.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/// @brief The string that represent human readable title.
@property (nonatomic, copy, readonly) NSString *title;

/// @brief The delegate that executes external actions for value e.g. scroll to visible or tells AitResponder state changes.
@property (nonatomic, weak) NSObject<AITValueDelegate> *delegate;

/// @brief The table view cell identifier for register and deque from table view.
@property (nonatomic, copy) NSString *cellIdentifier;

/// @brief Initialize new instance with the title string.
/// @details This if designated initializer.
- (instancetype)initWithTitle:(NSString *)title;


/// @brief The details view controller provider.
/// @details This  This class is used for create details view controller and shows any additional data.
///     E.g. select value from list or popup for select date.
- (id<AITDetailsViewControllerProvider>)detailsViewControllerProvider;

/// @brief Tell the value that it will remove from table view controller.
/// @details Prepare for destroy. E.g. unsubscribe KVO and notify values.
- (void)willRemove;

@end
