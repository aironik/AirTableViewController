//
//  AITChoiceValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceValue.h"
#import "AITValueWithSource+AITProtected.h"

#import "AITChoiceDetailsViewControllerProvider.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITChoiceValue ()

@property (nonatomic, copy) NSString *sourcePropertyName;

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
           titleStringFromValue:^NSString *(NSObject *value) {
                   NSParameterAssert(!value || [value isKindOfClass:[NSString class]]);
                   return (NSString *)value;
               }];
}

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
          titleStringFromValue:(AITChoiceOptionTitleValueString)titleStringFromValue
{
    return [[self alloc] initWithTitle:title
                          sourceObject:sourceObject
                         sourceKeyPath:sourceKeyPath
                  titleStringFromValue:titleStringFromValue];
}


- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
         titleStringFromValue:(AITChoiceOptionTitleValueString)titleStringFromValue
{
    if (self = [super initWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath]) {
        _titleStringFromValue = [titleStringFromValue copy];
        _detailsViewControllerProvider = [[AITChoiceDetailsViewControllerProvider alloc] init];
    }
    return self;
}

- (NSObject *)value {
    return self.sourceValue;
}

- (void)setValue:(NSObject *)value {
    self.sourceValue = value;
}

- (NSString *)valueString {
    return self.titleStringFromValue(self.value);
}

- (id<AITDetailsViewControllerProvider>)detailsViewControllerProvider {
    if (!_detailsViewControllerProvider) {
        _detailsViewControllerProvider = [[AITChoiceDetailsViewControllerProvider alloc] init];
    }
    return _detailsViewControllerProvider;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ value == \"%@\">",
                                      [super description],
                                      self.value];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return YES;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    [super becomeFirstAitResponder];
}

- (void)setFirstAitResponder:(BOOL)firstAitResponder {
    [super setFirstAitResponder:firstAitResponder];
}

@end
