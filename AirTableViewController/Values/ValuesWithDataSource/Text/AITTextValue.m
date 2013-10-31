//
//  AITTextValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTextValue.h"
#import "AITValueWithSource+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTextValue ()

@property (nonatomic, weak) NSObject *sourceObject;
@property (nonatomic, copy) NSString *sourcePropertyName;

@end


#pragma mark - Implementation

@implementation AITTextValue

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
                       comment:(NSString *)comment
{
    return [[self alloc] initWithTitle:title
                          sourceObject:sourceObject
                         sourceKeyPath:(NSString *)sourceKeyPath
                               comment:comment];
}

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
                      comment:(NSString *)comment
{
    if (self = [super initWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath]) {
        _comment = [comment copy];
        _textEditable = YES;

        _textInputAutocapitalizationType = UITextAutocapitalizationTypeSentences;
        _textInputKeyboardType = UIKeyboardTypeDefault;
        _textInputReturnKeyType = UIReturnKeyDefault;
        _textInputSecureTextEntry = NO;
        _textInputClearsOnBeginEditing = NO;
    }
    return self;
}

- (NSString *)cellIdentifier {
    return @"AITTextCell";
}

- (BOOL)isEmpty {
    return [self.value length] == 0;
}

- (NSString *)value {
    return self.sourceValue;
}

- (void)setValue:(NSString *)value {
    self.sourceValue = value;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ value == \"%@\", comment == \"%@\">",
                     [super description],
                     self.value,
                     self.comment];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return self.textEditable;
}

- (BOOL)canResignFirstAitResponder {
    return [self isValueValid];
}


#pragma mark Validation

- (BOOL)isValueValid {
    return YES;
}


@end
