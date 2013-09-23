//
//  AITTextCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"


@class AITTextValue;


/// @brief The table view cell for edit text.
@interface AITTextCell : AITTableViewCell

/// @brief The text field for edit string value.
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;

/// @brief The value represents text.
@property (nonatomic, strong) AITTextValue *textValue;


@end
