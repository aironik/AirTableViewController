//
//  AITChoiceValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceValue.h"


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
            sourcePropertyName:(NSString *)sourcePropertyName
{
    return [self valueWithTitle:title
                   sourceObject:sourceObject
             sourcePropertyName:sourcePropertyName
               titleValueString:^NSString *(NSObject *value) {
                   NSParameterAssert(!value || [value isKindOfClass:[NSString class]]);
                   return (NSString *)value;
               }];
}

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName
              titleValueString:(AITChoiceOptionTitleValueString)titleValueString
{
    return [[self alloc] initWithTitle:title
                          sourceObject:sourceObject
                    sourcePropertyName:sourcePropertyName
                      titleValueString:(AITChoiceOptionTitleValueString)titleValueString];
}


- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           sourcePropertyName:(NSString *)sourcePropertyName
             titleValueString:(AITChoiceOptionTitleValueString)titleValueString
{
    if (self = [super init]) {
        NSAssert2(sourceObject
                  && [sourcePropertyName length]
                  && [sourceObject respondsToSelector:NSSelectorFromString(sourcePropertyName)],
                  @"Cannot access bool value switch. Object: %@, keyPath: %@", sourceObject, sourcePropertyName);
        NSAssert(titleValueString != NULL, @"Title getter block cannot be nil.");

        _title = [title copy];
        _sourceObject = sourceObject;
        _sourcePropertyName = [sourcePropertyName copy];
        _titleValueString = [titleValueString copy];
        _empty = NO;
        [_sourceObject addObserver:self
                        forKeyPath:sourcePropertyName
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
    }
    return self;
}

- (void)dealloc {
    [_sourceObject removeObserver:self forKeyPath:_sourcePropertyName];
}


+ (NSString *)cellIdentifier {
    return @"AITChoiceCell";
}

- (void)perform {
}

- (NSObject<AITChoiceOption> *)value {
    NSObject<AITChoiceOption> *value = [self.sourceObject valueForKeyPath:self.sourcePropertyName];
    NSParameterAssert(!value || [value conformsToProtocol:@protocol(AITChoiceOption)]);
    return value;
}

- (void)setValue:(NSObject<AITChoiceOption> *)value {
    NSAssert([self.allOptions containsObject:value], @"set value that doesn't contains in all possible options.");
    NSAssert(!value || [value conformsToProtocol:@protocol(AITChoiceOption)], @"value must conforms to AITChoiceOption protocol");
    [self.sourceObject setValue:value forKeyPath:self.sourcePropertyName];
}

- (NSString *)valueString {
    return self.titleValueString(self.value);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.sourceObject && [keyPath isEqualToString:self.sourcePropertyName]) {
        [self willChangeValueForKey:@"value"];
        [self didChangeValueForKey:@"value"];
    }
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ title == \"%@\", value == \"%@\">",
                                      [super description],
                                      self.title,
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
