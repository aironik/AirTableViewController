//
//  AITSettingsViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsViewController.h"

#import "NSBundle+AITLoader.h"
#import "AITSettings.h"
#import "AITSettingsActionCell.h"
#import "AITSettingsBoolCell.h"
#import "AITSettingsBoolWithStateViewCell.h"
#import "AITSettingsChoiceCell.h"
#import "AITSettingsDetailsCell.h"
#import "AITSettingsPendingOperationCell.h"
#import "AITSettingsSubtitledActionCell.h"
#import "AITSettingsTextCell.h"
#import "AITSettingsHeaderView.h"
#import "AITSettingsFooterView.h"
#import "AITTableViewController.h"
#import "AITTableViewSection.h"
#import "UIView+AITUserInterfaceIdiom.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


NSString *const kAITSettingsActionFooterIdentifier = @"AITSettingsActionFooterView";
NSString *const kAITSettingsErrorFooterIdentifier = @"AITSettingsErrorFooterView";
NSString *const kAITSettingsFooterIdentifier = @"AITSettingsFooterView";
NSString *const kAITSettingsHeaderIdentifier = @"AITSettingsHeaderView";


@interface AITSettingsViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchBarTopConstraint;
@property (nonatomic, weak, readwrite) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UILabel *emptyViewLabel;

@end


#pragma mark - Implementation


@implementation AITSettingsViewController


@synthesize searchBarShown = _searchBarShown;
@synthesize emptyViewText = _emptyViewText;

- (void)loadView {
    AITSettings *settings = [AITTableViewController defaultSettings];
    UIView *view = [[NSBundle mainBundle] ait_loadNibNamed:@"AITSettingsTableView" class:[UIView class] owner:self];
    view.backgroundColor = settings.emptyBackgroundColor;
    [view ait_setTintColor:settings.tintColor];
    if ([self.searchBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.searchBar.barTintColor = settings.tintColor;
        self.searchBar.tintColor = settings.tintColor;
    }
    self.searchBar.prompt = self.searchPrompt;
    self.view = view;

    self.emptyView.backgroundColor = settings.emptyBackgroundColor;
    self.emptyViewLabel.textColor = settings.emptyScreenTextColor;
    [self hideEmptyView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] && [self extendedLayoutIncludesOpaqueBars]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    else {
        self.wantsFullScreenLayout = YES;
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];

    [self registerCells];
    [self registerHeaderFooters];

    [self stopActivityIndicator];
    self.ignoreKeyboardShrink = YES;
    
    [self updateSearchBarShown];
    self.emptyViewLabel.text = self.emptyViewText;
}

- (void)registerCells {
    [AITSettingsActionCell setupTableView:self.tableView];
    [AITSettingsBoolCell setupTableView:self.tableView];
    [AITSettingsBoolWithStateViewCell setupTableView:self.tableView];
    [AITSettingsChoiceCell setupTableView:self.tableView];
    [AITSettingsDetailsCell setupTableView:self.tableView];
    [AITSettingsPendingOperationCell setupTableView:self.tableView];
    [AITSettingsSubtitledActionCell setupTableView:self.tableView];
    [AITSettingsTextCell setupTableView:self.tableView];
}

- (void)registerHeaderFooters {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [AITTableViewSection setDefaultHeaderViewIdentifier:kAITSettingsHeaderIdentifier];
        [AITTableViewSection setDefaultFooterViewIdentifier:kAITSettingsFooterIdentifier];

        UINib *nib = nil;
        
        nib = [UINib nibWithNibName:@"AITSettingsActionFooterView" bundle:[NSBundle ait_bundle]];
        [[AITHeaderFooterView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingsActionFooterIdentifier];

        nib = [UINib nibWithNibName:@"AITSettingsErrorFooterView" bundle:[NSBundle ait_bundle]];
        [[AITHeaderFooterView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingsErrorFooterIdentifier];
        
        nib = [UINib nibWithNibName:@"AITSettingsFooterView" bundle:[NSBundle ait_bundle]];
        [[AITSettingsFooterView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingsFooterIdentifier];
        
        nib = [UINib nibWithNibName:@"AITSettingsHeaderView" bundle:[NSBundle ait_bundle]];
        [[AITSettingsHeaderView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingsHeaderIdentifier];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // If keyboard did shown and navigation ontoller pop to current controller
    // layout became broken in AIAModatView. Next lines fix/hack that bug.
    [self.view.superview setNeedsLayout];
    [self.view.superview setNeedsUpdateConstraints];
    
    [self updateContentHeight];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = self.view.backgroundColor;
}

- (void)updateContentHeight {
    const CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    const CGFloat frameHeight = CGRectGetHeight(self.scrollView.frame);
    const CGFloat contentHeight = MAX(tableViewContentHeight, frameHeight);
    self.tableViewHeightConstraint.constant = contentHeight;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), contentHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if ([[result class] ait_userInterfaceIdiomVersion] != AITUserInterfaceIdiomVersion6) {
        result.backgroundColor = [UIColor clearColor];
    }
    else {
        result.backgroundColor = [UIColor whiteColor];
    }
    result.opaque = NO;

    return result;
}

- (void)startActivityIndicator {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0.;
        [self.activityIndicator startAnimating];
    }];
}

- (void)stopActivityIndicator {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 1.;
        self.activityIndicator.hidesWhenStopped = YES;
        [self.activityIndicator stopAnimating];
    }];
}

- (void)setEmptyViewText:(NSString *)emptyViewText {
    _emptyViewText = [emptyViewText copy];
    self.emptyViewLabel.text = emptyViewText;
}

- (void)showEmptyView {
    self.emptyView.alpha = 1.f;
}

- (void)hideEmptyView {
    self.emptyView.alpha = 0.f;
}


- (void)setSections:(NSArray *)sections {
    [super setSections:sections];
    
    [self updateContentHeight];
}

- (void)setSearchBarShown:(BOOL)searchBarShown {
    _searchBarShown = searchBarShown;
    [self updateSearchBarShown];
}

- (void)updateSearchBarShown {
    const CGFloat navBarMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    if (self.searchBarShown) {
        self.searchBarTopConstraint.constant = navBarMaxY;
        self.searchBar.alpha = 1.f;
    }
    else {
        self.searchBarTopConstraint.constant = navBarMaxY - CGRectGetHeight(self.searchBar.frame);
        self.searchBar.alpha = 0.f;
    }
}

- (IBAction)close:(id)sender {
    if (self.closeBlock != NULL) {
        self.closeBlock();
    }
}


@end
