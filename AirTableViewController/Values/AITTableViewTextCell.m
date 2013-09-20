//
//  AITTableViewTextCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewTextCell.h"

#import "AITTableViewCell+AITProtected.h"
#import "AITTextValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTableViewTextCell () <UITextFieldDelegate>


@end


#pragma mark - Implementation

@implementation AITTableViewTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSAssert(NO, @"Does not implemented. valueTextField does not created.");
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setup {
    [super setup];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.valueTextField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateSubviews {
    [super updateSubviews];

    self.valueTextField.text = self.value.value;
    self.valueTextField.placeholder = self.textValue.comment;
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];

    self.valueLabel.alpha = editing ? 0.0 : 1.0;
    self.valueTextField.alpha = editing ? 1.0 : 0.0;
    [self.valueTextField resignFirstResponder];
}

- (void)setTextValue:(AITTextValue *)textValue {
    self.value = textValue;
}

- (AITTextValue *)textValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITTextValue class]]);
    return (AITTextValue *)self.value;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSParameterAssert(textField == self.valueTextField);
    self.textValue.value = textField.text;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    NSParameterAssert(notification.object == self.valueTextField);
    self.textValue.value = self.valueTextField.text;
}



@end
