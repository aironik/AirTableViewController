//
//  AITDateDetailsViewControllerProvider.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 01.11.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITDetailsViewControllerProvider.h>


@interface AITDateDetailsViewControllerProvider : NSObject<AITDetailsViewControllerProvider>

/// @brief The flag that defines presentation style.
/// @details If YES picker shows in popover and as additional cell otherwise.
///     Default value is YES for iOS prior 7 and NO for iOS 7 and later.
@property (nonatomic, assign) BOOL showDatePickerInPopover;

@end
