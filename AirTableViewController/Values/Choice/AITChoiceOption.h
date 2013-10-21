//
//  AITChoiceOption.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 21.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


/// @brief The protocol that represents option for choice value
@protocol AITChoiceOption<NSObject>

@required

/// @brief The human readable value that represents option.
- (NSString *)stringRepresentation;

@end
