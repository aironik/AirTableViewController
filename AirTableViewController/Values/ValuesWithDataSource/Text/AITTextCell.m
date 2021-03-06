//
//  AITTextCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTextCell.h"

#import "AITTableViewCell+AITProtected.h"
#import "AITTextValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTextCell () <UITextFieldDelegate>

@end


#pragma mark - Implementation

@implementation AITTextCell

- (AITTextValue *)textValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITTextValue class]]);
    return (AITTextValue *)self.value;
}


- (void)setTextValue:(AITTextValue *)textValue {
    NSParameterAssert(!textValue || [textValue isKindOfClass:[AITTextValue class]]);
    self.value = textValue;
}

- (void)setValue:(AITValue *)value {
    NSParameterAssert(!value || [value isKindOfClass:[AITTextValue class]]);
    NSParameterAssert(self.valueTextField.delegate == self);
    [super setValue:value];
}

- (void)setup {
    [super setup];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.valueTextField];
}

- (UITableViewCellSelectionStyle)defaultSelectionStyle {
    return UITableViewCellSelectionStyleNone;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"value", @"textEditable" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];

    self.valueTextField.text = self.textValue.value;
    self.valueTextField.placeholder = self.textValue.comment;
    self.valueTextField.enabled = self.textValue.textEditable;

    self.valueTextField.autocapitalizationType = self.textValue.textInputAutocapitalizationType;
    self.valueTextField.keyboardType = self.textValue.textInputKeyboardType;
    self.valueTextField.returnKeyType =  self.textValue.textInputReturnKeyType;
    self.valueTextField.secureTextEntry = self.textValue.textInputSecureTextEntry;
    self.valueTextField.clearsOnBeginEditing = self.textValue.textInputClearsOnBeginEditing;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSParameterAssert(textField == self.valueTextField);
    [self becomeFirstAitResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSParameterAssert(textField == self.valueTextField);
    self.textValue.value = textField.text;
    [self resignFirstAitResponder];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    NSParameterAssert(notification.object == self.valueTextField);
    self.textValue.value = self.valueTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self canResignFirstAitResponder]) {
        [self.value.nextAitResponder becomeFirstAitResponder];
    }
    return NO;
}


#pragma mark - AITResponder protocol implementation

- (void)becomeFirstAitResponder {
    [self.valueTextField becomeFirstResponder];
    [super becomeFirstAitResponder];
}

- (void)resignFirstAitResponder {
    [self.valueTextField resignFirstResponder];
    [super resignFirstAitResponder];
}

@end
