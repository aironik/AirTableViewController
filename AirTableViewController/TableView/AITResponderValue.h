//
//  AITResponderValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponder.h>


/// @brief The notification name that posts over default NSNotificationCenter if value become first responder.
extern NSString *const kAITValueBecomeFirstAitResponder;

/// @brief The notification name that posts over default NSNotificationCenter if value resign first responder.
extern NSString *const kAITValueResignFirstAitResponder;


@protocol AITValueDelegate;


/// @brief base value class that implements base AITResponder chain.
@interface AITResponderValue : NSObject<AITResponder>

/// @brief The boolean value that indicates whether value is first ait responder.
/// @details Normally this value set from -becomeFirstAitResponder or -resignFirstAitResponder.
@property (nonatomic, assign, getter=isFirstAitResponder) BOOL firstAitResponder;

/// @brief The next responder. The AITTableView setup this value next section.
@property (nonatomic, weak) id<AITResponder> nextAitResponder;

@property (nonatomic, weak) NSObject<AITValueDelegate> *delegate;

@end
