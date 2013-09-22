//
//  AITValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


/// @brief Представляет значение в таблице для ячейки.
@protocol AITValue<NSObject>

@required

/// @brief Идентификатор ячейки для получения ее из tableView.
+ (NSString *)cellIdentifier;

/// @brief Определяет пустое значение, или нет. Если оно пустое, то его нет смысла показывать.
- (BOOL)isEmpty;

/// @brief Заголовок для отображения в ячеейке.
- (NSString *)title;

- (void)perform;

@end
