//
//  AITCellEtchedView.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


/**
 * @brief The background view for cell that etche.
 */
@interface AITCellEtchedView : UIView

/**
 * @brief Value that define cell position in section. This value setup by AITTableViewSection on return cell.
 */
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) UIEdgeInsets separatorInset;

@property (nonatomic, strong) UIColor *color;

@end
