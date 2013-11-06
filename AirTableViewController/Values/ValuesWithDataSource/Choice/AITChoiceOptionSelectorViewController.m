//
//  AITChoiceOptionSelectorViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 21.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceOptionSelectorViewController.h"

#import "AITChoiceOptionSelectorViewControllerDelegate.h"
#import "AITChoiceValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITChoiceOptionSelectorViewController ()<UISearchDisplayDelegate>

@property (nonatomic, strong, readwrite) AITChoiceValue *choiceValue;
@property (nonatomic, copy, readwrite) NSString *filterString;

@end


#pragma mark - Implementation

@implementation AITChoiceOptionSelectorViewController


+ (instancetype)choiceOptionSelectorWithValue:(AITChoiceValue *)value {
    return [[self alloc] initWithValue:value];
}

- (instancetype)initWithValue:(AITChoiceValue *)value {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _choiceValue = value;
        _delegate = value.choiceOptionsSelectorDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    NSParameterAssert(self.delegate);

    [super viewDidLoad];
    
    [self.delegate choiceOptionSelector:self didStartForValue:self.choiceValue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.choiceValue resignFirstAitResponder];

    [self.delegate choiceOptionSelector:self didStopForValue:self.choiceValue];
}

- (void)setAllOptions:(NSArray *)allOptions {
    if (_allOptions != allOptions) {
        _allOptions = allOptions;
        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
    }
}

- (void)setFilteredOptions:(NSArray *)filteredOptions {
    if (_filteredOptions != filteredOptions) {
        _filteredOptions = filteredOptions;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}


#pragma mark - Table View Delegate and Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(section == 0, @"Unknown section");

    return ((self.searchDisplayController.searchResultsTableView == tableView)
            ? [self.filteredOptions count]
            : [self.allOptions count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath.section == 0, @"Unknown section");
    NSAssert(indexPath.row < ((self.searchDisplayController.searchResultsTableView == tableView)
                              ? [self.filteredOptions count]
                              : [self.allOptions count]), @"Unknown section");

    NSString *const cellId = @"CellId";
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!result) {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSObject *option = ((self.searchDisplayController.searchResultsTableView == tableView)
                        ? self.filteredOptions[indexPath.row]
                        : self.allOptions[indexPath.row]);
    result.textLabel.text = self.choiceValue.titleStringFromValue(option);
    result.accessoryType = ([self isOptionChecked:option]
                            ? UITableViewCellAccessoryCheckmark
                            : UITableViewCellAccessoryNone);

    return result;
}

- (BOOL)isOptionChecked:(NSObject *)option {
    return [option isEqual:self.choiceValue.value];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *option = ((self.searchDisplayController.searchResultsTableView == tableView)
                        ? self.filteredOptions[indexPath.row]
                        : self.allOptions[indexPath.row]);
    self.choiceValue.value = option;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self reloadVisibleRowsInTableView:self.tableView];
    [self reloadVisibleRowsInTableView:self.searchDisplayController.searchResultsTableView];
}

- (void)reloadVisibleRowsInTableView:(UITableView *)tableView {
    [tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    self.filterString = searchString;
    [self.delegate choiceOptionSelector:self filterDidChanged:searchString forValue:self.choiceValue];
    return NO;
}


@end
