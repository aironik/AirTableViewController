//
//  AITDateCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 15.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITTableViewCell.h>


@class AITDateValue;


@interface AITDateCell : AITTableViewCell

/// @brief The text label for show date value.
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

/// @brief The value represents date.
@property (nonatomic, weak) AITDateValue *dateValue;

@end
