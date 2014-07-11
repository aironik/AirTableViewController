//
//  AITDetailsValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.07.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValue.h>


/// @brief Present details view controller.
@interface AITDetailsValue : AITValue

/// @brief Create new details view value instance.
+ (instancetype)valueWithTitle:(NSString *)title detailsProvider:(id<AITDetailsViewControllerProvider>)detailsProvider;


@end
