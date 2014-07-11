//
//  AITDViewController.m
//  AirTableViewControllerDemo
//
//  Created by Oleg Lobachev aironik@gmail.com on 25.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDViewController.h"

#import "AITDDetailsViewControllerProvider.h"
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
            [self staticSection4],
    ];
}


#pragma mark - Static Sections

- (id)staticSection1 {
    AITTableViewSection *result = [[AITTableViewSection alloc] init];

    result.header = @"Section 1";
    result.footer = @"Demonstrate simple datasource cells";
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

- (AITTableViewSection *)staticSection4 {
    AITTableViewSection *result = [[AITTableViewSection alloc] init];

    result.header = @"Section With Choice Options";
    result.allObjects = @[
            [self staticValue4Choice],
            [self staticValue4Details],
    ];

    return result;
}

#pragma mark - Static Values

- (AITValue *)staticValue11 {
    AITTextValue *result = [AITTextValue valueWithTitle:@"String Property Value"
                                           sourceObject:self.staticDataSource
                                          sourceKeyPath:@"stringProperty"
                                                comment:@"String Property Value Placeholder"];
    result.textEditable = YES;
    result.textInputAutocapitalizationType = UITextAutocapitalizationTypeWords;
    return result;
}

- (AITValue *)staticValue12 {
    AITBoolValue *result = [AITBoolValue valueWithTitle:@"Boolean Property Value"
                                           sourceObject:self.staticDataSource
                                          sourceKeyPath:@"boolProperty"];
    return result;
}

- (AITValue *)staticValue13 {
    AITDateValue *result = [AITDateValue valueWithTitle:@"Date Property Value"
                                           sourceObject:self.staticDataSource
                                          sourceKeyPath:@"dateProperty"];
    return result;
}

- (AITValue *)staticValue21 {
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

- (AITValue *)staticValue22 {
//    AITPendingOperationSection *section = self.pendingSection;
    AITActionValue *result = [AITActionValue valueWithTitle:@"Start Pending Process" action:^(AITActionValue *value) {
//        section.pendingOperationExecuting = YES;
    }];
    return result;
}

- (AITValue *)staticValue23 {
//    AITPendingOperationSection *section = self.pendingSection;
    AITActionValue *result = [AITActionValue valueWithTitle:@"Stop Pending Process" action:^(AITActionValue *value) {
//        section.pendingOperationExecuting = NO;
    }];
    return result;
}

- (AITValue *)staticValue4Choice {
    AITChoiceValue *result = [AITChoiceValue valueWithTitle:@"Choose"
                                               sourceObject:self.staticDataSource
                                              sourceKeyPath:@"choiceProperty"
                                       titleStringFromValue:^NSString *(NSObject *value) {
                return [NSString stringWithFormat:@"Choice %@", value];
            }];
    result.choiceOptionsSelectorDelegate = self.staticDataSource.choiceDelegate;
    return result;
}

- (AITValue *)staticValue4Details {
    AITDDetailsViewControllerProvider *provider = [[AITDDetailsViewControllerProvider alloc] init];
    AITDetailsValue *result = [AITDetailsValue valueWithTitle:@"Details View" detailsProvider:provider];

    return result;
}

@end
