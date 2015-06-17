//
//  AIAButtonDescriptor.h
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//


#import "AIAAlertView.h"


/**
 * @brief Class  that describe button in AIAAlertView and action behaviour.
 */
@interface AIAButtonDescriptor : NSObject

/**
 * @brief The button title text
 */
@property (nonatomic, copy) NSString *title;

/**
 * @brief The block that execute as action if user tap on the button.
 */
@property (nonatomic, copy) AIAAlertViewActionBlock actionBlock;

/**
 * @brief The button position (index) in alert view.
 * @details if negative button didn't shown.
 */
@property (nonatomic, assign) NSInteger index;

/**
 * @brief Create new button descriptor.
 */
+ (instancetype)buttonDescriptorWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock;

/**
 * @brief perform action.
 * @details execute actionBlock if not empty.
 */
- (void)perform;

@end
