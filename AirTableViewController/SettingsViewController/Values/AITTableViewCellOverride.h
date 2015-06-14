//
//  AITTableViewCellOverride.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


#define AIT_CELL_STATIC_COLOR [UIColor blackColor]
#define AIT_CELL_TINT_COLOR [self ait_tintColor]
#define AIT_CELL_BACKGROUND_COLOR [UIColor whiteColor]

#define AIT_CELL_OVERRIDE_HIGHLIGTED(interactedColor, highlightAction) \
- (void)awakeFromNib { \
    [super awakeFromNib]; \
    self.etchedView.color = AIT_CELL_BACKGROUND_COLOR; \
} \
\
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated { \
    if (highlightAction) { \
        if ([[self class] ait_userInterfaceIdiomVersion] != AITUserInterfaceIdiomVersion6) { \
            void(^highlightBlock)(void) = ^() { \
                self.titleLabel.textColor = (highlighted ? AIT_CELL_BACKGROUND_COLOR : interactedColor); \
                self.etchedView.color = (highlighted ? AIT_CELL_TINT_COLOR : AIT_CELL_BACKGROUND_COLOR); \
            }; \
            if (!highlighted || animated) { \
                NSUInteger options = (UIViewAnimationOptionBeginFromCurrentState \
                                      | UIViewAnimationOptionCurveEaseOut \
                                      | UIViewAnimationOptionBeginFromCurrentState); \
                [UIView animateWithDuration:0.3 \
                                      delay:0. \
                                    options:options \
                                 animations:highlightBlock \
                                 completion:NULL]; \
            } \
            else { \
                highlightBlock(); \
            } \
        } \
    } \
    [super setHighlighted:highlighted animated:animated]; \
} \
\
- (void)setPosition:(NSUInteger)position { \
    [super setPosition:position]; \
    self.etchedView.position = position; \
} \


#define AIT_CELL_OVERRIDE_INTERACTED_SELECTION_STYLE \
- (UITableViewCellSelectionStyle)defaultSelectionStyle { \
    if ([[self class] ait_userInterfaceIdiomVersion] == AITUserInterfaceIdiomVersion6) { \
        return UITableViewCellSelectionStyleGray; \
    } \
    return UITableViewCellSelectionStyleNone; \
} \


#define AIT_CELL_OVERRIDE_STATI_SELECTION_STYLE \
- (UITableViewCellSelectionStyle)defaultSelectionStyle { \
    return UITableViewCellSelectionStyleNone; \
} \


#define AIT_CELL_OVERRIDE_STATIC \
    AIT_CELL_OVERRIDE_HIGHLIGTED(AIT_CELL_STATIC_COLOR, NO) \
    AIT_CELL_OVERRIDE_STATI_SELECTION_STYLE

#define AIT_CELL_OVERRIDE_ACTION \
    AIT_CELL_OVERRIDE_HIGHLIGTED(AIT_CELL_TINT_COLOR, YES) \
    AIT_CELL_OVERRIDE_INTERACTED_SELECTION_STYLE

#define AIT_CELL_OVERRIDE_DETAILED \
    AIT_CELL_OVERRIDE_HIGHLIGTED(AIT_CELL_STATIC_COLOR, YES) \
    AIT_CELL_OVERRIDE_INTERACTED_SELECTION_STYLE
