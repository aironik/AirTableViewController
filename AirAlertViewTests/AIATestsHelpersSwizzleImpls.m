//
//  AIATestsHelpers.m
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AIATestsHelpersSwizzleImpls.h"

#import <objc/runtime.h>


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AIATestsHelpersSwizzleImpls ()

@property (nonatomic, assign) Class targetMetaClass;
@property (nonatomic, assign) SEL sourceSelector;
@property (nonatomic, assign) SEL targetSelector;
@property (nonatomic, assign) Method sourceMethod;
@property (nonatomic, assign) Method targetMethod;
@property (nonatomic, assign) BOOL methodWasReplaced;
@property (nonatomic, assign) BOOL methodsExchanged;
@property (nonatomic, assign) Class sourceClass;
@property (nonatomic, assign) Class targetClass;
@property (nonatomic, assign) IMP oldTargetImp;

@end


#pragma mark - Implementation

@implementation AIATestsHelpersSwizzleImpls

- (void)dealloc {
    [self revert];
}

+ (instancetype)replaceClassSourceSelector:(SEL)sourceSelector
                               sourceClass:(Class)sourceClass
                            targetSelector:(SEL)targetSelector
                               targetClass:(Class)targetClass
{
    AIATestsHelpersSwizzleImpls *result = [[[self class] alloc] init];
    [result replaceSourceSelector:sourceSelector
                      sourceClass:sourceClass
                   targetSelector:targetSelector
                      targetClass:targetClass
                       onInstance:NO];
    return result;
}

+ (instancetype)replaceInstanceSourceSelector:(SEL)sourceSelector
                                  sourceClass:(Class)sourceClass
                               targetSelector:(SEL)targetSelector
                                  targetClass:(Class)targetClass
{
    AIATestsHelpersSwizzleImpls *result = [[[self class] alloc] init];
    [result replaceSourceSelector:sourceSelector
                      sourceClass:sourceClass
                   targetSelector:targetSelector
                      targetClass:targetClass
                       onInstance:YES];
    return result;

}

- (void)replaceSourceSelector:(SEL)sourceSelector
                  sourceClass:(Class)sourceClass
               targetSelector:(SEL)targetSelector
                  targetClass:(Class)targetClass
                   onInstance:(BOOL)onInstance
{
    self.sourceClass = sourceClass;
    self.targetClass = targetClass;
    self.sourceSelector = sourceSelector;
    self.targetSelector = targetSelector;

    self.targetMetaClass = objc_getMetaClass([NSStringFromClass(self.targetClass) cStringUsingEncoding:NSUTF8StringEncoding]);
    self.methodsExchanged = class_addMethod(self.targetMetaClass,
                                 sourceSelector,
                                 method_getImplementation(self.targetMethod),
                                 method_getTypeEncoding(self.targetMethod));
    
    if (onInstance) {
        self.sourceMethod = class_getInstanceMethod(self.sourceClass, self.sourceSelector);
        self.targetMethod = class_getInstanceMethod(self.targetClass, self.targetSelector);
    }
    else {
        self.sourceMethod = class_getClassMethod(self.sourceClass, self.sourceSelector);
        self.targetMethod = class_getClassMethod(self.targetClass, self.targetSelector);
    }

    NSLog(@"Method %@ added: %@", NSStringFromSelector(self.targetSelector), self.methodsExchanged ? @"YES" : @"NO");
    if (self.methodsExchanged) {
        class_replaceMethod(self.targetMetaClass,
                            self.targetSelector,
                            method_getImplementation(self.sourceMethod),
                            method_getTypeEncoding(self.sourceMethod));
    }
    else {
        self.oldTargetImp = method_getImplementation(self.targetMethod);
        const IMP impForReplace = method_getImplementation(self.sourceMethod);
        method_setImplementation(self.targetMethod, impForReplace);
    }
    self.methodWasReplaced = YES;
}

- (void)revert {
    if (self.methodWasReplaced) {
        if (self.methodsExchanged) {
            class_replaceMethod(self.targetMetaClass,
                                self.targetSelector,
                                method_getImplementation(self.targetMethod),
                                method_getTypeEncoding(self.targetMethod));
        }
        else {
            method_setImplementation(self.targetMethod, self.oldTargetImp);
            self.methodWasReplaced = NO;
        }
    }
}


@end
