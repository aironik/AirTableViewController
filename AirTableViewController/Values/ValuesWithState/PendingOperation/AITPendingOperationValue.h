//
//  AITPendingOperationValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponderValue.h>
#import <AirTableViewController/TableView/AITValue.h>


@interface AITPendingOperationValue : AITResponderValue<AITValue>

/// @brief The pending operation name.
@property (nonatomic, copy) NSString *title;

/// @brief The value represents whether value is empty and should not be interactable.
/// @details If NO cell hides.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

+ (instancetype)valueWithTitle:title;

@end
