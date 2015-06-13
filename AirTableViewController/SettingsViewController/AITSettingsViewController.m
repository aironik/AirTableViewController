//
//  AITSettingsViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsViewController.h"

#import "NSBundle+AITLoader.h"
#import "AITActionCell.h"
#import "AITBoolCell.h"
#import "AITBoolWithIndicateViewCell.h"
#import "AITChoiceCell.h"
#import "AITDetailsCell.h"
#import "AITPendingOperationCell.h"
#import "AITSubtitledActionCell.h"
#import "AITTextCell.h"
#import "AITSettingsHeaderView.h"
#import "AITSettingsFooterView.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


NSString *const kAITSettingActionFooterIdentifier = @"AITSettingsActionFooterView";
NSString *const kAITSettingErrorFooterIdentifier = @"AITSettingsErrorFooterView";
NSString *const kAITSettingFooterIdentifier = @"AITSettingsFooterView";
NSString *const kAITSettingHeaderIdentifier = @"AITSettingsHeaderView";


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
    UIView *view = [[NSBundle mainBundle] ait_loadNibNamed:@"AITSettingsTableView" class:[UIView class] owner:self];
    view.backgroundColor = AIT_COLOR_EMPTY_BACKGROUND;
    [view ait_setTintColor:AIT_COLOR_TINT];
    if ([self.searchBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.searchBar.barTintColor = AIT_COLOR_TINT;
        self.searchBar.tintColor = AIT_COLOR_TINT;
    }
    self.searchBar.prompt = self.searchPrompt;
    self.view = view;

    self.emptyView.backgroundColor = AIT_COLOR_EMPTY_BACKGROUND;
    self.emptyViewLabel.textColor = AIT_COLOR_EMPTY_SCREEN_TEXT;
    [self hideEmptyView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerCells];
    [self registerHeaderFooters];

    [self stopActivityIndicator];
    self.ignoreKeyboardShrink = YES;
    
    [self updateSearchBarShown];
    self.emptyViewLabel.text = self.emptyViewText;
}

- (void)registerCells {
    [AITActionCell setupTableView:self.tableView];
    [AITBoolCell setupTableView:self.tableView];
    [AITBoolWithIndicateViewCell setupTableView:self.tableView];
    [AITChoiceCell setupTableView:self.tableView];
    [AITDetailsCell setupTableView:self.tableView];
    [AITPendingOperationCell setupTableView:self.tableView];
    [AITSubtitledActionCell setupTableView:self.tableView];
    [AITTextCell setupTableView:self.tableView];
}

- (void)registerHeaderFooters {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [AITTableViewSection setDefaultHeaderViewIdentifier:kAITSettingHeaderIdentifier];
        [AITTableViewSection setDefaultFooterViewIdentifier:kAITSettingFooterIdentifier];

        UINib *nib = nil;
        
        nib = [UINib nibWithNibName:@"AITSettingsActionFooterView" bundle:[NSBundle bundleForClass:[self class]]];
        [[AITHeaderFooterView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingActionFooterIdentifier];

        nib = [UINib nibWithNibName:@"AITSettingsErrorFooterView" bundle:[NSBundle bundleForClass:[self class]]];
        [[AITHeaderFooterView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingErrorFooterIdentifier];
        
        nib = [UINib nibWithNibName:@"AITSettingsFooterView" bundle:[NSBundle bundleForClass:[self class]]];
        [[AITSettingsFooterView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingFooterIdentifier];
        
        nib = [UINib nibWithNibName:@"AITSettingsHeaderView" bundle:[NSBundle bundleForClass:[self class]]];
        [[AITSettingsHeaderView class] registerNib:nib forHeaderFooterViewReuseIdentifier:kAITSettingHeaderIdentifier];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
