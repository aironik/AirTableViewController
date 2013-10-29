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
              @"Cannot access bool value switch. Object: %@, keyPath: %@", sourceObject, sourceKeyPath);
    if (self = [super initWithTitle:title]) {
        _sourceObject = sourceObject;
        _sourceKeyPath = [sourceKeyPath copy];
        [_sourceObject addObserver:self
                        forKeyPath:sourceKeyPath
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
    }
    return self;
}

- (void)dealloc {
    [_sourceObject removeObserver:self forKeyPath:_sourceKeyPath];
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

- (BOOL)isEmpty {
    return (self.sourceValue == nil);
}

- (void)setEmpty:(BOOL)empty {
    NSAssert(NO, @"This method should not be invoked.");
}

@end
