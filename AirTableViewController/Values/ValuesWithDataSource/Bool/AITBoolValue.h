//
//  AITBoolValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValueWithSource.h>


/// @brief The value represent boolean property in a source object.
@interface AITBoolValue : AITValueWithSource

/// @brief The boolean value from source.
@property (nonatomic, assign) BOOL value;

@end
