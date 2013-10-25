//
//  AITDViewController.m
//  AirTableViewControllerDemo
//
//  Created by Oleg Lobachev aironik@gmail.com on 25.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDViewController.h"

#import "AITDDataSource.h"


@interface AITDViewController ()

@property (nonatomic, strong, readonly) AITDDataSource *staticDataSource;
@property (nonatomic, strong, readonly) AITPendingOperationSection *pendingSection;

@end


@implementation AITDViewController

@synthesize staticDataSource = _staticDataSource;
@synthesize pendingSection = _pendingSection;


- (AITDDataSource *)staticDataSource {
    if (!_staticDataSource) {
        _staticDataSource = [[AITDDataSource alloc] init];
    }
    return _staticDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([@"ShowStaticAirTableViewController" isEqualToString:segue.identifier]) {
        [self prepareStaticAirTableViewController:(AITTableViewController *)segue.destinationViewController];
    }
}

- (void)prepareStaticAirTableViewController:(AITTableViewController *)tableViewController {
    tableViewController.editing = YES;
    tableViewController.sections = @[
            [self staticSection1],
            [self staticSection2],
            [self staticSection3],
    ];
}


#pragma mark - Static Sections

- (id)staticSection1 {
    AITTableViewSection *result = [[AITTableViewSection alloc] init];
    
    result.allObjects = @[
            [self staticValue11],
            [self staticValue12],
            [self staticValue13],
    ];

    return result;
}

- (AITTableViewSection *)staticSection2 {
    NSString *header = @"This is section with header and footer";
    NSString *footer = @"You can use cells in this section for control pending state in the next section.";
    AITHeaderFooterSection *result = [AITHeaderFooterSection sectionWithHeader:header
                                                                        footer:footer];
    result.allObjects = @[
            [self staticValue21],
            [self staticValue22],
            [self staticValue23],
    ];
    return result;
}

- (AITTableViewSection *)staticSection3 {
    return self.pendingSection;
}

- (AITPendingOperationSection *)pendingSection {
    if (!_pendingSection) {
        _pendingSection = [[AITPendingOperationSection alloc] init];
    }
    return _pendingSection;
}

#pragma mark - Static Values

- (NSObject<AITValue> *)staticValue11 {
    AITTextValue *result = [AITTextValue valueWithTitle:@"String Property Value"
                                           sourceObject:self.staticDataSource
                                     sourcePropertyName:@"stringProperty"
                                                comment:@"String Property Value Placeholder"];
    result.textEditable = YES;
    result.textInputAutocapitalizationType = UITextAutocapitalizationTypeWords;
    return result;
}

- (NSObject<AITValue> *)staticValue12 {
    AITBoolValue *result = [AITBoolValue valueWithTitle:@"Boolean Property Value"
                                           sourceObject:self.staticDataSource
                                     sourcePropertyName:@"boolProperty"];
    return result;
}

- (NSObject<AITValue> *)staticValue13 {
    AITDateValue *result = [AITDateValue valueWithTitle:@"Date Property Value"
                                           sourceObject:self.staticDataSource
                                     sourcePropertyName:@"dateProperty"];
    return result;
}

- (NSObject<AITValue> *)staticValue21 {
    AITActionValue *result = [AITActionValue valueWithTitle:@"Show Alert View" action:^(AITActionValue *value) {
        [[[UIAlertView alloc] initWithTitle:@"Title"
                                    message:@"Message"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil]
         show];
    }];
    return result;
}

- (NSObject<AITValue> *)staticValue22 {
//    AITPendingOperationSection *section = self.pendingSection;
    AITActionValue *result = [AITActionValue valueWithTitle:@"Start Pending Process" action:^(AITActionValue *value) {
//        section.pendingOperationExecuting = YES;
    }];
    return result;
}

- (NSObject<AITValue> *)staticValue23 {
//    AITPendingOperationSection *section = self.pendingSection;
    AITActionValue *result = [AITActionValue valueWithTitle:@"Stop Pending Process" action:^(AITActionValue *value) {
//        section.pendingOperationExecuting = NO;
    }];
    return result;
}


@end
