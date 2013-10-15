//
//  AITSwitchValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITSwitchValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSwitchValue ()

@property (nonatomic, weak) NSObject *sourceObject;
@property (nonatomic, copy) NSString *sourcePropertyName;

@end


#pragma mark - Implementation

@implementation AITSwitchValue


+ (instancetype)valueWithTitle:(id)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName
{
    return [[self alloc] initWithTitle:title sourceObject:sourceObject sourcePropertyName:sourcePropertyName];
}

- (instancetype)initWithTitle:(id)title
                 sourceObject:(NSObject *)sourceObject
           sourcePropertyName:(NSString *)sourcePropertyName
{

    NSAssert2(sourceObject
              && [sourcePropertyName length]
              && [sourceObject respondsToSelector:NSSelectorFromString(sourcePropertyName)],
              @"Cannot access bool value switch. Object: %@, keyPath: %@", sourceObject, sourcePropertyName);
    if (self = [super init]) {
        _title = [title copy];
        _sourceObject = sourceObject;
        _sourcePropertyName = [sourcePropertyName copy];
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
    return @"AITSwitchCell";
}

- (void)perform {
}

- (BOOL)value {
    NSNumber *numberValue = [self.sourceObject valueForKeyPath:self.sourcePropertyName];
    NSParameterAssert(!numberValue || [numberValue isKindOfClass:[NSNumber class]]);
    return [numberValue boolValue];
}

- (void)setValue:(BOOL)value {
    [self.sourceObject setValue:@(value) forKeyPath:self.sourcePropertyName];
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
                     (self.value ? @"YES" : @"NO")];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}


@end
