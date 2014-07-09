//
//  AITChoiceCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITTableViewCell.h>


@class AITChoiceValue;


/// @brief The cell represent value which select one choice from possible set.
@interface AITChoiceCell : AITTableViewCell

/// @brief The label represents selected value.
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

/// @brief The value that represents choice.
@property (nonatomic, weak) AITChoiceValue *choiceValue;

@end
