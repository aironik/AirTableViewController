//
//  AITResponder.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

/// @brief The responder chain protocol.
/// @details This protocol defines objects for responder chain and helps
///     seriously pass active cells for serially fill them. If an object
///     is first responder it owned input focus. E.g. active cell for input
///     text with focus and opened keyboard or cell with suggest popup.
@protocol AITResponder<NSObject>

@required

/// @brief Get next object that can become first responder.
- (id<AITResponder>)nextAitResponder;
- (void)setNextAitResponder:(id<AITResponder>)nextAitResponder;

/// @brief Return value whether object can become first responder or not.
- (BOOL)canBecomeFirstAitResponder;

/// @brief Return value whether object can resign first responder.
/// @details E.g. data correct.
- (BOOL)canResignFirstAitResponder;

/// @brief Become first responder.
/// @details Get the user input focus. E.g. text field shows keyboard and
///     get user input. Or date field shows date picker. If object cannot
///     become first responder it should delegate first responder to next
///     object throw responder chain.
- (void)becomeFirstAitResponder;

/// @brief Resign first responder.
/// @details If object cannot resign first responder this method do nothing.
- (void)resignFirstAitResponder;

/// @brief Return whether the object is first responder.
- (BOOL)isFirstAitResponder;


@end