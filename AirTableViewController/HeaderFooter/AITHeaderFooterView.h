//
//  AITHeaderFooterView.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//


extern NSString *const kAITHeaderFooterViewLeftAlignedHeaderIdentifier;
extern NSString *const kAITHeaderFooterViewCenterAlignedHeaderIdentifier;
extern NSString *const kAITHeaderFooterViewCenterAlignedFooterIdentifier;

@interface AITHeaderFooterView : UIView

@property (nonatomic, weak) IBOutlet UILabel *label;

+ (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier;
+ (void)setupTableView:(UITableView *)tableView;

+ (AITHeaderFooterView *)headerFooterViewWithIdentifier:(NSString *)identifier;
+ (AITHeaderFooterView *)leftAlignedHeaderView;
+ (AITHeaderFooterView *)centerAlignedHeaderView;
+ (AITHeaderFooterView *)centerAlignedFooterView;

- (CGFloat)heightForTableView:(UITableView *)tableView;

@end
