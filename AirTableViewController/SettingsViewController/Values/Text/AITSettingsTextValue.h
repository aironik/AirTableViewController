//
//  AITSettingsTextValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/Values/ValuesWithDataSource/Text/AITTextValue.h>


/**
 * @brief The cell that override AITTextValue behaviour
 * @details Define narrow cell for iOS 7 and higher and usual width otherwise
 */
@interface AITSettingsTextValue : AITTextValue

@property (nonatomic, assign) BOOL titleLabelResizable;

/**
 * @brief Set textAligment for textField for value.
 */
@property (nonatomic, assign) NSTextAlignment valueTextAligment;

@end
