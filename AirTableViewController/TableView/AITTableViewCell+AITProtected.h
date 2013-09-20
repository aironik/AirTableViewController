//
//  AITTableViewCell(AITProtected).m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 26.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


#import "AITTableViewCell.h"


@interface AITTableViewCell (AITProtected)

/// @brief Настройка после awakeFromNib или init.
/// @details Should invoke super.
- (void)setup;

/// @brief Обновить subviews (labels) в соответствии со значениями value.
- (void)updateSubviews;

/// @brief Массив NSString для отслеживания (подписывания) изменений в value.
- (NSArray *)keyPathsForSubscribe;

@end
