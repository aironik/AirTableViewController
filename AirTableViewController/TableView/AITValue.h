//
//  AITValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponder.h>


@protocol AITValueDelegate;

/// @brief Protocol defines value in the table view cell
@protocol AITValue<AITResponder>

@required

/// @brief The table view cell identifier for register and deque from table view.
+ (NSString *)cellIdentifier;

/// @brief Defines empty value or not. If value is empty it should not shows.
- (BOOL)isEmpty;

/// @brief The string that represent human readable title.
- (NSString *)title;

/// @brief Perform action for value if user interact with cell.
- (void)perform;

/// @brief The delegate that executes external actions for value e.g. scroll to visible or insert additional cell.
- (NSObject<AITValueDelegate> *)delegate;
- (void)setDelegate:(NSObject<AITValueDelegate> *)delegate;

@end
