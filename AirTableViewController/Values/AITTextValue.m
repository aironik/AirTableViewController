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
@end


#pragma mark - Implementation

@implementation AITTextValue

@synthesize title = _title;

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (BOOL)isEmpty {
    return ([self.value length] == 0);
}

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           valueAttributeName:(NSString *)valueAttributeName {

    return [self initWithTitle:title
                  sourceObject:sourceObject
            valueAttributeName:valueAttributeName
                       comment:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           valueAttributeName:(NSString *)valueAttributeName
                      comment:(NSString *)comment {

    if (self = [super init]) {
        _title = [title copy];
        _sourceObject = sourceObject;
        _valueAttributeName = [valueAttributeName copy];
        _comment = [comment copy];
    }
    return self;
}


- (void)setValue:(NSString *)value {
    [self.sourceObject setValue:value forKeyPath:self.valueAttributeName];
}

- (NSString *)value {
    return [self.sourceObject valueForKeyPath:self.valueAttributeName];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ title == \"%@\", value == \"%@\", comment == \"%@\">",
                     [super description],
                     self.title,
                     self.value,
                     self.comment];
}

@end
