//
//  AITValueWithSource.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 29.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITValueWithSource.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITValueWithSource ()

@property (nonatomic, weak, readonly) NSObject *sourceObject;
@property (nonatomic, copy, readonly) NSString *sourceKeyPath;

@property (nonatomic, assign) BOOL subscribedValueChanges;

@end


#pragma mark - Implementation

@implementation AITValueWithSource

@synthesize sourceObject = _sourceObject;
@synthesize sourceKeyPath = _sourceKeyPath;

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
{
    return [[self alloc] initWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath];
}

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
{
    NSAssert2(sourceObject
              && [sourceKeyPath length]
              && [sourceObject respondsToSelector:NSSelectorFromString(sourceKeyPath)],
              @"Cannot access value. Object: %@, keyPath: %@", sourceObject, sourceKeyPath);
    if (self = [super initWithTitle:title]) {
        _sourceObject = sourceObject;
        _sourceKeyPath = [sourceKeyPath copy];
    }
    return self;
}

- (void)dealloc {
    if (_subscribedValueChanges) {
        [_sourceObject removeObserver:self forKeyPath:_sourceKeyPath];
    }
    _sourceObject = nil;
    _sourceKeyPath = nil;
}

- (void)willAppear {
    [super willAppear];

    [self subscribeValueChanges];
}

- (void)didDisappear {
    [self unsubscribeValueChanges];

    [super didDisappear];
}

- (void)subscribeValueChanges {
    if (!self.subscribedValueChanges) {
        self.subscribedValueChanges = YES;

        [_sourceObject addObserver:self
                        forKeyPath:self.sourceKeyPath
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
    }
}

- (void)unsubscribeValueChanges {
    if (self.subscribedValueChanges) {
        self.subscribedValueChanges = NO;
        [self.sourceObject removeObserver:self forKeyPath:self.sourceKeyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.sourceObject && [keyPath isEqualToString:self.sourceKeyPath]) {
        [self willChangeValueForKey:@"value"];
        [self willChangeValueForKey:@"sourceValue"];
        [self didChangeValueForKey:@"sourceValue"];
        [self didChangeValueForKey:@"value"];
    }
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (id)sourceValue {
    return [self.sourceObject valueForKeyPath:self.sourceKeyPath];
}

- (void)setSourceValue:(id)sourceValue {
    [self.sourceObject setValue:sourceValue forKeyPath:self.sourceKeyPath];
}


@end
