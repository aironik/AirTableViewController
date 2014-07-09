//
//  AITPendingOperationCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITTableViewCell.h>


@interface AITPendingOperationCell : AITTableViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
