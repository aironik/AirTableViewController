//
//  AITTextValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTextValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTextValue ()

@property (nonatomic, weak) NSObject *sourceObject;
@property (nonatomic, copy) NSString *sourcePropertyName;

@end


#pragma mark - Implementation

@implementation AITTextValue

@synthesize title = _title;

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName
                       comment:(NSString *)comment
{
    return [[self alloc] initWithTitle:title
                          sourceObject:sourceObject
                    sourcePropertyName:(NSString *)sourcePropertyName
                               comment:comment];
}

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           sourcePropertyName:(NSString *)sourcePropertyName
                      comment:(NSString *)comment
{
    NSAssert2(sourceObject
              && [sourcePropertyName length]
              && [sourceObject respondsToSelector:NSSelectorFromString(sourcePropertyName)],
              @"Cannot access string value. Object: %@, keyPath: %@", sourceObject, sourcePropertyName);

    if (self = [super init]) {
        _title = [title copy];
        _sourceObject = sourceObject;
        _sourcePropertyName = [sourcePropertyName copy];
        _comment = [comment copy];
        _empty = NO;
        _textEditable = YES;

        _textInputAutocapitalizationType = UITextAutocapitalizationTypeSentences;
        _textInputKeyboardType = UIKeyboardTypeDefault;
        _textInputReturnKeyType = UIReturnKeyDefault;
        _textInputSecureTextEntry = NO;
        _textInputClearsOnBeginEditing = NO;

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
    return @"AITTextCell";
}

- (void)perform {
}

- (NSString *)value {
    return [self.sourceObject valueForKeyPath:self.sourcePropertyName];
}

- (void)setValue:(NSString *)value {
    [self.sourceObject setValue:value forKeyPath:self.sourcePropertyName];
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
    return [NSString stringWithFormat:@"<%@ title == \"%@\", value == \"%@\", comment == \"%@\">",
                     [super description],
                     self.title,
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
