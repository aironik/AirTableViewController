//
//  AITPendingOperationValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITValue.h>


@interface AITPendingOperationValue : NSObject<AITValue>

/// @brief The pending operation name.
@property (nonatomic, copy) NSString *title;

/// @brief The value represents whether value is empty and should not be interactable.
/// @details If NO cell hides.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/// @brief The next responder. The AITTableView setup this value next section.
@property (nonatomic, weak) id<AITResponder> nextAitResponder;

+ (instancetype)valueWithTitle:title;

@end
