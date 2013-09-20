//
//  AITTableViewChoiceCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewChoiceCell.h"
#import "AITChoiceValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTableViewChoiceCell ()

/// @brief Заголовок. Это значение представляет собой название свойства, Например, "Название", "Заголовок" или "Описание".
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/// @brief Метка для значение поля в нередактируемом режиме (editing == NO).
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end


#pragma mark - Implementation

@implementation AITTableViewChoiceCell

- (void)perform {
    // TODO: write me
}

@end
