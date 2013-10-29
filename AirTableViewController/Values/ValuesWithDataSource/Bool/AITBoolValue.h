//
//  AITBoolValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValue.h>


@class AITBoolValue;


/// @brief The value represent boolean property in a source object.
@interface AITBoolValue : AITValue

/// @brief The boolean value from source.
@property (nonatomic, assign) BOOL value;

/// @brief Create new value represents boolean value with name.
/// @param title Human readable property name.
/// @param sourceObject the object having boolean property for present.
/// @param sourcePropertyName the property name (keypath) that needs represent.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName;

@end
