//
//  AITSwitchValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITValue.h>


@class AITSwitchValue;


/// @brief The value represent boolean property in a source object.
@interface AITSwitchValue : NSObject<AITValue>

/// @brief The action name.
@property (nonatomic, copy) NSString *title;

/// @brief The boolean value from source.
@property (nonatomic, assign) BOOL value;

/// @brief Create new value represents boolean value with name.
/// @param title Human readable property name.
/// @param sourceObject the object having boolean property for present.
/// @param sourcePropertyName the property name (keypath) that needs represent.
+ (instancetype)valueWithTitle:title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName;

@end