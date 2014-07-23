//
//  AITHeaderFooterView.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//


extern NSString *const kAITHeaderFooterViewLeftAlignedHeaderIdentifier;
extern NSString *const kAITHeaderFooterViewCenterAlignedHeaderIdentifier;
extern NSString *const kAITHeaderFooterViewLeftAlignedFooterIdentifier;
extern NSString *const kAITHeaderFooterViewCenterAlignedFooterIdentifier;

/// @brief The action code block for execute on user interaction.
typedef void(^AITHeaderFooterActionBlock)();

@interface AITHeaderFooterView : UIView

@property (nonatomic, weak) IBOutlet UILabel *label;

/// @brief Code block that execute on tap in the view.
/// @details If actionBlock != NULL label color changes to tint color.
///     Also actionBlock execute on user tap on the AITHeaderFooterView .
@property (nonatomic, copy) AITHeaderFooterActionBlock actionBlock;

/// @brief Tap gesture recognizer for detect tap.
/// @details Used for execute actionBlock.
/// @see actionBlock
@property (nonatomic, weak, readonly) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

+ (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier;
+ (void)setupTableView:(UITableView *)tableView;

+ (AITHeaderFooterView *)headerFooterViewWithIdentifier:(NSString *)identifier;
+ (AITHeaderFooterView *)leftAlignedHeaderView;
+ (AITHeaderFooterView *)centerAlignedHeaderView;
+ (AITHeaderFooterView *)centerAlignedFooterView;

- (CGFloat)heightForTableView:(UITableView *)tableView;

@end
