//
//  AIAAlertView.h
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//


typedef void(^AIAAlertViewActionBlock)();


/**
 * @brief The alert view class that support blocks as handlers.
 */
@interface AIAAlertView : NSObject

/**
 * @brief The alert view title text.
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 * @brief The alert view message text.
 */
@property (nonatomic, copy, readonly) NSString *message;

/**
 * @brief Return YES if alert view is displayed.
 */
@property (nonatomic, assign, readonly, getter=isShown) BOOL shown;

/**
 * @brief The block code that executes on alert view dismiss.
 * @details This code invokes on hide alert view after button handler.
 */
@property (nonatomic, copy) AIAAlertViewActionBlock dismissActionBlock;

/**
 * @brief Create new AIAAlertView instance with title and message.
 * @see -initWithTitle:message:
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 * @brief Create new AIAAlertView instance with title and message.
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

/**
 * @brief Add button with title and action.
 * @details Add new button in the alert view with block handler.
 * @param title The button title text
 * @param actionBlock The block that execute if user tap on the button.
 */
- (void)addButtonWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock;

/**
 * @brief Add cancel button with title and action.
 * @details Add new cancel button in the alert view with block handler. The cancel button adds as last button.
 *      If cancel button already exists this value changes previous cancel button.
 * @param title The button title text
 * @param actionBlock The block that execute if user tap on the button.
 */
- (void)addCancelButtonWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock;

/**
 * @brief Present alert view.
 * @details Present alert view. If alert view have no button show one cancel button with empty action block.
 *      If alert view present this method has no effect.
 */
- (void)show;

/**
 * @brief Present alert view.
 * @details If alert view didn't present this method has no effect.
 */
- (void)hide;

@end
