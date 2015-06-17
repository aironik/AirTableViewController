//
//  AIAAlertViewTests.m
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//


#import "AIAAlertView.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AIATestsHelpersSwizzleImpls.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AIAAlertViewTests : XCTestCase

@property (nonatomic, strong) AIATestsHelpersSwizzleImpls *swizzleImplsHelper;

@end


#pragma mark - AIAAlertView friends category


@interface AIAAlertView (AIATestsFriend)
- (UIAlertView *)nativeAlertView;
@end

@interface UIAlertViewMock : UIAlertView
@property (nonatomic, assign) BOOL viewShown;
@end

@implementation UIAlertViewMock

+ (id)allocAlertView {
    return [UIAlertViewMock allocWithZone:NULL];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    return [self init];
}

- (void)show {
    self.viewShown = YES;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    self.viewShown = NO;
    [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
}


@end


#pragma mark - Implementation

@implementation AIAAlertViewTests

- (void)setUp {
    [super setUp];
    self.swizzleImplsHelper = [AIATestsHelpersSwizzleImpls replaceClassSourceSelector:@selector(allocAlertView)
                                                                          sourceClass:[UIAlertViewMock class]
                                                                       targetSelector:@selector(alloc)
                                                                          targetClass:[UIAlertView class]];
}

- (void)tearDown {
    [self.swizzleImplsHelper revert];
    [super tearDown];
}

- (void)testCreateEmptyAlertView {
    NSString *title = @"test title";
    NSString *message = @"test message";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:title message:message];
    XCTAssertNotNil(alertView, @"Cannot create AIAAlertView");
    XCTAssertEqualObjects(alertView.title, title, @"AIAAlertView created with different title");
    XCTAssertEqualObjects(alertView.message, message, @"AIAAlertView created with different title");
}

- (void)testShownAlertViewWithoutButtonsShouldHaveCancelButton {
    NSString *title = @"test title";
    NSString *message = @"test message";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:title message:message];
    [alertView show];
    UIAlertView *nativeAlertView = [alertView nativeAlertView];

    XCTAssertNotNil(nativeAlertView, @"Shown nativeAlertView is empty");
    XCTAssertTrue(((UIAlertViewMock *)nativeAlertView).viewShown, @"Shown alert view ahould present to user.");
    XCTAssertEqualObjects(nativeAlertView.title, title, @"AIAAlertView created with different title");
    XCTAssertEqualObjects(nativeAlertView.message, message, @"AIAAlertView created with different title");
    XCTAssert(nativeAlertView.numberOfButtons == 1, @"AIAAlertView should add only Cancel button");
    XCTAssert(nativeAlertView.cancelButtonIndex == 0, @"AIAAlertView should add only Cancel button");
    XCTAssertEqual(nativeAlertView.delegate, alertView, @"AIAAlertView should set self as UIAlertView delegate");
}

- (void)testCreateAlertViewWithCancelButton {
    NSString *title = @"test title";
    NSString *message = @"test message";
    NSString *buttonTitle = @"CancelButton";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:title message:message];
    [alertView addCancelButtonWithTitle:buttonTitle actionBlock:NULL];
    [alertView show];
    UIAlertView *nativeAlertView = [alertView nativeAlertView];

    XCTAssertNotNil(nativeAlertView, @"Shown nativeAlertView is empty");
    XCTAssert(nativeAlertView.numberOfButtons == 1, @"AIAAlertView should add only Cancel button");
    XCTAssert(nativeAlertView.cancelButtonIndex == 0, @"AIAAlertView should add only Cancel button");
    XCTAssertEqualObjects([nativeAlertView buttonTitleAtIndex:0], buttonTitle, @"AIAAlertView should add Cancel button with title");
    XCTAssertEqual(nativeAlertView.delegate, alertView, @"AIAAlertView should set self as UIAlertView delegate");
}

- (void)testCreateAlertViewWithRegularButton {
    NSString *title = @"test title";
    NSString *message = @"test message";
    NSString *buttonTitle = @"OkButton";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:title message:message];
    [alertView addButtonWithTitle:buttonTitle actionBlock:NULL];
    [alertView show];
    UIAlertView *nativeAlertView = [alertView nativeAlertView];

    XCTAssertNotNil(nativeAlertView, @"Shown nativeAlertView is empty");
    XCTAssert(nativeAlertView.numberOfButtons == 1, @"AIAAlertView should add only Cancel button");
    XCTAssert(nativeAlertView.cancelButtonIndex < 0, @"AIAAlertView should add only Cancel button");
    XCTAssertEqualObjects([nativeAlertView buttonTitleAtIndex:0], buttonTitle, @"AIAAlertView should add button with title");
    XCTAssertEqual(nativeAlertView.delegate, alertView, @"AIAAlertView should set self as UIAlertView delegate");
}

- (void)testCreateAlertViewWithRegularAndCancelButtons {
    NSString *title = @"test title";
    NSString *message = @"test message";
    NSString *buttonTitle1 = @"OkButton1";
    NSString *buttonTitle2 = @"OkButton2";
    NSString *cancelButtonTitle = @"cancelButton";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:title message:message];
    [alertView addButtonWithTitle:buttonTitle1 actionBlock:NULL];
    [alertView addCancelButtonWithTitle:cancelButtonTitle actionBlock:NULL];
    [alertView addButtonWithTitle:buttonTitle2 actionBlock:NULL];
    [alertView show];
    UIAlertView *nativeAlertView = [alertView nativeAlertView];

    XCTAssertNotNil(nativeAlertView, @"Shown nativeAlertView is empty");
    XCTAssert(nativeAlertView.numberOfButtons == 3, @"AIAAlertView should add only Cancel button");
    XCTAssert(nativeAlertView.cancelButtonIndex == 2, @"AIAAlertView should add only Cancel button");
    XCTAssertEqualObjects([nativeAlertView buttonTitleAtIndex:0], buttonTitle1, @"AIAAlertView should add button with title");
    XCTAssertEqualObjects([nativeAlertView buttonTitleAtIndex:1], buttonTitle2, @"AIAAlertView should add button with title");
    XCTAssertEqualObjects([nativeAlertView buttonTitleAtIndex:2], cancelButtonTitle, @"AIAAlertView should add cancel button in the end");
}

- (void)testHideAlertViewWithoutCancelButton {
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:@"test title" message:@"test message"];
    __block int counter = 0;
    [alertView addButtonWithTitle:@"OkButton" actionBlock:^{
        ++counter;
    }];
    [alertView show];
    UIAlertView *nativeAlertView = [alertView nativeAlertView];

    [alertView hide];
    XCTAssertFalse(((UIAlertViewMock *)nativeAlertView).viewShown, @"Hidden alert view should dismiss.");
    XCTAssertNil([alertView nativeAlertView], @"Hidden alert view should remove alert view.");
    XCTAssertEqual(counter, 0, @"Regular expression should not involes");
}

- (void)testHideAlertViewWithCancelButton {
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:@"test title" message:@"test message"];
    __block int counter = 0;
    [alertView addCancelButtonWithTitle:@"CancelButton" actionBlock:^{
        ++counter;
    }];
    [alertView show];
    UIAlertView *nativeAlertView = [alertView nativeAlertView];

    [alertView hide];
    XCTAssertFalse(((UIAlertViewMock *)nativeAlertView).viewShown, @"Hidden alert view should dismiss.");
    XCTAssertNil([alertView nativeAlertView], @"Hidden alert view should remove alert view.");
    XCTAssertEqual(counter, 1, @"Regular expression should not involes");
}

- (void)testHideAlertViewWithButtonHandler {
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:@"test title" message:@"test message"];
    __block int counter1 = 0;
    __block int counter2 = 0;
    __block int counter3 = 0;
    [alertView addCancelButtonWithTitle:@"button1" actionBlock:^{ ++counter1; }];
    [alertView addCancelButtonWithTitle:@"button2" actionBlock:^{ ++counter2; }];
    [alertView addCancelButtonWithTitle:@"button3" actionBlock:^{ ++counter3; }];
    [alertView show];
    UIAlertViewMock *nativeAlertView = (UIAlertViewMock *)[alertView nativeAlertView];
    [nativeAlertView dismissWithClickedButtonIndex:1 animated:YES];

    XCTAssertEqual(counter1, 0, @"Regular expression should not involes");
    XCTAssertEqual(counter2, 1, @"Regular expression should involes");
    XCTAssertEqual(counter3, 0, @"Regular expression should not involes");
}

- (AIAAlertView *)alertViewWithOkAndCancelButtonsWithoutActionBlocks {
    AIAAlertView *result = [AIAAlertView alertViewWithTitle:@"test title" message:@"test message"];
    [result addButtonWithTitle:@"OkButton" actionBlock:NULL];
    [result addCancelButtonWithTitle:@"CancelButton" actionBlock:NULL];
    return result;
}

- (void)testExecuteDismissActionBlockWithoutButtonBlockNormalButtonAction {
    AIAAlertView *alertView = [self alertViewWithOkAndCancelButtonsWithoutActionBlocks];
    __block int counter = 0;
    alertView.dismissActionBlock = ^{ ++counter; };
    [alertView show];

    UIAlertViewMock *nativeAlertView = (UIAlertViewMock *)[alertView nativeAlertView];
    [nativeAlertView dismissWithClickedButtonIndex:0 animated:YES];

    XCTAssertEqual(counter, 1, @"dismiss block didn't invokes once.");
}

- (void)testExecuteDismissActionBlockWithoutButtonBlockCancelButtonAction {
    AIAAlertView *alertView = [self alertViewWithOkAndCancelButtonsWithoutActionBlocks];
    __block int counter = 0;
    alertView.dismissActionBlock = ^{ ++counter; };
    [alertView show];

    UIAlertViewMock *nativeAlertView = (UIAlertViewMock *)[alertView nativeAlertView];
    [nativeAlertView dismissWithClickedButtonIndex:1 animated:YES];

    XCTAssertEqual(counter, 1, @"dismiss block didn't invokes once.");
}

- (void)testExecuteDismissActionBlockWithButtonBlockNormalButtonAction {
    NSString *buttonTitle1 = @"OkButton1";
    NSString *buttonTitle2 = @"OkButton2";
    NSString *cancelButtonTitle = @"cancelButton";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:@"test title" message:@"test message"];
    [alertView addButtonWithTitle:buttonTitle1 actionBlock:^{}];
    [alertView addButtonWithTitle:buttonTitle2 actionBlock:^{}];
    [alertView addCancelButtonWithTitle:cancelButtonTitle actionBlock:^{}];

    __block int counter = 0;
    alertView.dismissActionBlock = ^{ ++counter; };
    [alertView show];

    UIAlertViewMock *nativeAlertView = (UIAlertViewMock *)[alertView nativeAlertView];
    [nativeAlertView dismissWithClickedButtonIndex:0 animated:YES];

    XCTAssertEqual(counter, 1, @"dismiss block didn't invokes once.");
}

- (void)testExecuteDismissActionBlockWithButtonBlockCancelButtonAction {
    NSString *buttonTitle1 = @"OkButton1";
    NSString *buttonTitle2 = @"OkButton2";
    NSString *cancelButtonTitle = @"cancelButton";
    AIAAlertView *alertView = [AIAAlertView alertViewWithTitle:@"test title" message:@"test message"];
    [alertView addButtonWithTitle:buttonTitle1 actionBlock:^{}];
    [alertView addButtonWithTitle:buttonTitle2 actionBlock:^{}];
    [alertView addCancelButtonWithTitle:cancelButtonTitle actionBlock:^{}];

    __block int counter = 0;
    alertView.dismissActionBlock = ^{ ++counter; };
    [alertView show];

    UIAlertViewMock *nativeAlertView = (UIAlertViewMock *)[alertView nativeAlertView];
    [nativeAlertView dismissWithClickedButtonIndex:2 animated:YES];

    XCTAssertEqual(counter, 1, @"dismiss block didn't invokes once.");
}

@end
