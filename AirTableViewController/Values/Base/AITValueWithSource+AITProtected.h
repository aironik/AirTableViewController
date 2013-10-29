//
//  AITValueWithSource(AITProtected).m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 29.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


#import "AITValueWithSource.h"


@interface AITValueWithSource (AITProtected)

/// @brief The object that data source. This object should responds sourceKeyPath property as value.
@property (nonatomic, weak, readonly) NSObject *sourceObject;

/// @brief The data sources key path. This key path is source data keyPath for value.
@property (nonatomic, copy, readonly) NSString *sourceKeyPath;

@end
