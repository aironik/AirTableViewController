//
//  AITTableViewCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 26.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@protocol AITValue;


@interface AITTableViewCell : UITableViewCell

/// @brief Значение, с которым работаем. Из него обновляются UI-элементы
@property (nonatomic, strong) id<AITValue> value;

/// @brief Заголовок. Это значение представляет собой название свойства, Например, "Название", "Заголовок" или "Описание".
/// @details Текст выставляется и обновляется внутри из value
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/// @brief Метка для значение поля в нередактируемом режиме (editing == NO).
/// @details Текст выставляется и обновляется внутри из value
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

/// @brief Осуществить операцию, соответствующую value при нажатии на ячейку
- (void)perform;

@end
