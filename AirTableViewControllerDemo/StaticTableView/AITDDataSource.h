//
//  AITDDataSource.h
//  AirTableViewControllerDemo
//
//  Created by Oleg Lobachev aironik@gmail.com on 25.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@interface AITDDataSource : NSObject

@property (nonatomic, copy) NSString *stringProperty;
@property (nonatomic, assign) BOOL boolProperty;
@property (nonatomic, strong) NSDate *dateProperty;

@property (nonatomic, strong) NSNumber *choiceProperty;
@property (nonatomic, strong) id<AITChoiceOptionSelectorViewControllerDelegate> choiceDelegate;

@end
