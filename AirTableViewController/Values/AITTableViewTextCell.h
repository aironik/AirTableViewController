//
//  AITTableViewTextCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"


@class AITTextValue;


/// @brief Ячейка для отображения и редактирования текста.
@interface AITTableViewTextCell : AITTableViewCell

/// @brief Shortcut for value
@property (nonatomic, strong) AITTextValue *textValue;

/// @brief Редактируемое поле в режиме редактрования (editing == YES).
/// @details Текст выставляется и обновляется внутри из value
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;


@end
