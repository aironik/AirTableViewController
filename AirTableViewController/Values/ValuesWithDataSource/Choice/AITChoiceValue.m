//
//  AITChoiceValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceValue.h"
#import "AITValueWithSource+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITChoiceValue ()

@property (nonatomic, weak) NSObject *sourceObject;
@property (nonatomic, copy) NSString *sourcePropertyName;
@property (nonatomic, copy, readonly) AITChoiceOptionTitleValueString titleValueString;

@end


#pragma mark - Implementation

@implementation AITChoiceValue


+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
{
    return [self valueWithTitle:title
                   sourceObject:sourceObject
                  sourceKeyPath:sourceKeyPath
               titleValueString:^NSString *(NSObject *value) {
                   NSParameterAssert(!value || [value isKindOfClass:[NSString class]]);
                   return (NSString *)value;
               }];
}

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
              titleValueString:(AITChoiceOptionTitleValueString)titleValueString
{
    return [[self alloc] initWithTitle:title
                          sourceObject:sourceObject
                         sourceKeyPath:sourceKeyPath
                      titleValueString:(AITChoiceOptionTitleValueString)titleValueString];
}


- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
             titleValueString:(AITChoiceOptionTitleValueString)titleValueString
{
    if (self = [super initWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath]) {
        _titleValueString = [titleValueString copy];
    }
    return self;
}

- (NSString *)cellIdentifier {
    return @"AITChoiceCell";
}

- (NSObject<AITChoiceOption> *)value {
    NSObject<AITChoiceOption> *value = self.sourceValue;
    NSParameterAssert(!value || [value conformsToProtocol:@protocol(AITChoiceOption)]);
    return value;
}

- (void)setValue:(NSObject<AITChoiceOption> *)value {
    NSAssert([self.allOptions containsObject:value], @"set value that doesn't contains in all possible options.");
    NSAssert(!value || [value conformsToProtocol:@protocol(AITChoiceOption)], @"value must conforms to AITChoiceOption protocol");
    self.sourceValue = value;
}

- (NSString *)valueString {
    return self.titleValueString(self.value);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ value == \"%@\">",
                                      [super description],
                                      self.value];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return ([self.allOptions count] > 0);
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    [super becomeFirstAitResponder];
}

- (void)setFirstAitResponder:(BOOL)firstAitResponder {
    // TODO: write me
//    if (firstAitResponder) {
//        [self perform];
//    }
    [super setFirstAitResponder:firstAitResponder];
}

@end
