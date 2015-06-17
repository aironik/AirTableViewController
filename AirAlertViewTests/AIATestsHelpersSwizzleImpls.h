//
//  AIATestsHelpersSwizzleImpls.h
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//



/**
 * @brief Helper class for tests
 */
@interface AIATestsHelpersSwizzleImpls : NSObject

+ (instancetype)replaceClassSourceSelector:(SEL)sourceSelector
                               sourceClass:(Class)sourceClass
                            targetSelector:(SEL)targetSelector
                               targetClass:(Class)targetClass;
+ (instancetype)replaceInstanceSourceSelector:(SEL)sourceSelector
                                  sourceClass:(Class)sourceClass
                               targetSelector:(SEL)targetSelector
                                  targetClass:(Class)targetClass;

- (void)revert;

@end
