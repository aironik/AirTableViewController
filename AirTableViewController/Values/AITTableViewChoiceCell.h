//
//  AITTableViewChoiceCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"


@class AITChoiceValue;


/// @brief Ячейка для отображения отношения в CoreData
@interface AITTableViewChoiceCell : AITTableViewCell

@property (nonatomic, strong) AITChoiceValue *choiceValue;

@end
