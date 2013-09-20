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
@end


#pragma mark - Implementation

@implementation AITChoiceValue

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
             relationshipName:(NSString *)relationshipName
           valueAttributeName:(NSString *)valueAttributeName {

    if (self = [super init]) {
        _title = [title copy];
        _sourceObject = sourceObject;
        _relationshipName = [relationshipName copy];
        _valueAttributeName = [valueAttributeName copy];
    }
    return self;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (BOOL)isEmpty {
    return ([self.sourceObject valueForKeyPath:self.relationshipName] == nil);
}

- (NSString *)value {
    NSObject *choosedObject = [self.sourceObject valueForKeyPath:self.relationshipName];
    return [choosedObject valueForKeyPath:self.valueAttributeName];
}


@end
