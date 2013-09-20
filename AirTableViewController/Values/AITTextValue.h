//
//  AITTextValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITValue.h"


/// @brief Текстовое значение для AITTextValue
@interface AITTextValue : NSObject<AITValue>

/// @brief Объект, для которого выбираем значение
/// @details Например, объект экземпляров AILWord
@property (nonatomic, strong, readonly) NSObject *sourceObject;

/// @brief Имя атрибута для получения текстового значения
/// @details Например, для слова Cafe нужно получить транскрипцию, это значение "transcription"
///     (атрибут transcription в sourceObject)
@property (nonatomic, copy, readonly) NSString *valueAttributeName;

/// @brief Нередактируемый заголовок для отображения в ячеейке.
@property (nonatomic, copy, readonly) NSString *title;

/// @brief Текстовое значение. Может быть изменено ячейкой.
@property (nonatomic, copy) NSString *value;

/// @brief Текстовое описание. Использеутся в placeholder при редакритвании.
@property (nonatomic, copy) NSString *comment;

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           valueAttributeName:(NSString *)valueAttributeName;

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           valueAttributeName:(NSString *)valueAttributeName
                      comment:(NSString *)comment;
@end
