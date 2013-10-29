//
//  AITPendingOperationValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValue.h>


/// @brief The value that represent pending operation state. Cell shown and shows activity indicator if not empty.
@interface AITPendingOperationValue : AITValue

+ (instancetype)valueWithTitle:title;

@end
