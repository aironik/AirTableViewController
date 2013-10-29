//
//  AITValueWithSource.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 29.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValue.h>


@interface AITValueWithSource : AITValue

/// @brief The value from source.
@property (nonatomic, assign) id sourceValue;

/// @brief Create new value represents value with data source names.
/// @param title Human readable property name.
/// @param sourceObject the object having source property for present.
/// @param sourceKeyPath the property name (keypath) that needs represent.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath;

/// @brief Initialize new value represents value with data source names.
/// @param title Human readable property name.
/// @param sourceObject the object having source property for present.
/// @param sourceKeyPath the property name (keyPath) that needs represent.
- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath;

@end
