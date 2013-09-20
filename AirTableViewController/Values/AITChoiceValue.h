//
//  AITChoiceValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITValue.h"


/// @brief Значение-связь. Выбор из возможных значений.
@interface AITChoiceValue : NSObject<AITValue>

/// @brief Объект, для которого выбираем значение
/// @details Например, объект экземпляров AILWord
@property (nonatomic, strong, readonly) NSObject *sourceObject;

/// @brief Имя свойства, которое выбираем.
/// @details Например, для получения части речи - строка "partOfSpeach"
@property (nonatomic, copy, readonly) NSString *relationshipName;

/// @brief Имя атрибута в отношении для получения текстового значения
/// @details Например, для слова Cafe нужно получить часть речи, это значение "name"
///     (атрибут name в связанном объекте partOfSpeach)
@property (nonatomic, copy, readonly) NSString *valueAttributeName;

/// @brief Заголовок для отображения в ячеейке.
@property (nonatomic, copy, readonly) NSString *title;

/// @brief Значение, которое отображается в ячейке.
@property (nonatomic, copy, readonly) NSString *value;

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
             relationshipName:(NSString *)relationshipName
           valueAttributeName:(NSString *)valueAttributeName;

@end
