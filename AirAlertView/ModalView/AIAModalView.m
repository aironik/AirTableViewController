//
//  AIAModalView.m
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 21.05.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AIAModalView.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


static const NSTimeInterval kAnimationDuration = 0.2;
static const CGFloat kLineWidth = 2.;

@interface AIAModalView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *darkeningBackView;
@property (nonatomic, strong) UIWindow *parentWindow;

@property (nonatomic, strong) UITapGestureRecognizer *hideOnDarkeningBackViewGestureRecognizer;

@property (nonatomic, assign) CGRect originalFrame;

@end


#pragma mark - Implementation


@implementation AIAModalView


- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _darkeningColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    _cornerRadius = 10.;
    _hideOnTapOutside = YES;

    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    self.layer.cornerRadius = _cornerRadius;
    self.clipsToBounds = YES;
}

- (void)show {
    if (![self isVisible]) {
        [self showInWindow:[[UIApplication sharedApplication] keyWindow]];
    }
}

- (void)showInWindow:(UIWindow *)parentWindow {
    if (![self isVisible]) {
        self.parentWindow = parentWindow;
        
        [self viewWillAppear];
        
        [self copyTintColorFromView:[[UIApplication sharedApplication] keyWindow] toView:self.parentWindow];
        
        [self prepareViewsForAppear];
        [self prepareTransformsForAppear];
        
        [self.parentWindow makeKeyAndVisible];
        AIA_WEAK_SELF;
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{ AIA_STRONG_SELF; [strongSelf prepareTransformsAfterAppear]; }
                         completion:^(BOOL finished) { AIA_STRONG_SELF; [strongSelf viewDidAppear]; }];
    }
}

- (void)dismiss {
    if ([self isVisible]) {
        [self viewWillDisappear];
        
        AIA_WEAK_SELF;
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{ AIA_STRONG_SELF; [strongSelf hideOnDismiss]; }
                         completion:^(BOOL finished) { AIA_STRONG_SELF; [strongSelf finalizeOnDismiss]; [strongSelf viewDidDisappear]; }];
    }
}

- (void)copyTintColorFromView:(UIView *)fromView toView:(UIView *)toView {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if ([fromView respondsToSelector:@selector(tintColor)] && [toView respondsToSelector:@selector(setTintColor:)]) {
        [toView setTintColor:fromView.tintColor];
    }
#endif // __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
}

- (void)prepareViewsForAppear {
    self.darkeningBackView = [self createDarkeningBackView];

    UIView *parentView = [[self.parentWindow subviews] count] ? [self.parentWindow subviews][0] : self.parentWindow;
    self.darkeningBackView.frame = parentView.bounds;
    [parentView addSubview:self.darkeningBackView];

    self.center = self.darkeningBackView.center;
    self.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                             | UIViewAutoresizingFlexibleBottomMargin
                             | UIViewAutoresizingFlexibleLeftMargin
                             | UIViewAutoresizingFlexibleRightMargin);
    [self.darkeningBackView addSubview:self];
    self.originalFrame = self.frame;
}

- (void)prepareTransformsForAppear {
    self.darkeningBackView.alpha = 0.;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.transform = transform;
}

- (void)prepareTransformsAfterAppear {
    self.darkeningBackView.alpha = 1.;
    self.transform = CGAffineTransformIdentity;
}

- (void)hideOnDismiss {
    self.darkeningBackView.alpha = 0.;
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.transform = transform;
}

- (void)finalizeOnDismiss {
    self.parentWindow = nil;
    
    [self.darkeningBackView removeFromSuperview];
    self.hideOnDarkeningBackViewGestureRecognizer = nil;
    self.darkeningBackView = nil;
    
    [self removeFromSuperview];
}


- (void)viewWillAppear {
    [self.contentViewController viewWillAppear:YES];
}

- (void)viewDidAppear {
    [self.contentViewController viewDidAppear:YES];
    [self subscribeForKeyboardNotifications];
}

- (void)viewWillDisappear {
    [self unsubscribeForKeyboardNotifications];
    [self.contentViewController viewWillDisappear:YES];
}

- (void)viewDidDisappear {
    [self.contentViewController viewDidDisappear:YES];
}

- (BOOL)isVisible {
    return self.parentWindow != nil;
}

- (UIView *)createDarkeningBackView {
    UIView *result = [[UIView alloc] initWithFrame:self.frame];
    result.backgroundColor = _darkeningColor;
    result.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    self.hideOnDarkeningBackViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(tapDidRecognize:)];
    self.hideOnDarkeningBackViewGestureRecognizer.numberOfTapsRequired = 1;
    self.hideOnDarkeningBackViewGestureRecognizer.numberOfTouchesRequired = 1;
    self.hideOnDarkeningBackViewGestureRecognizer.delegate = self;
    
    [result addGestureRecognizer:self.hideOnDarkeningBackViewGestureRecognizer];
    
    return result;
}

- (void)setDarkeningColor:(UIColor *)darkeningColor {
    if (_darkeningColor != darkeningColor) {
        _darkeningColor = darkeningColor;
        _darkeningBackView.backgroundColor = _darkeningColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawBorderInContext:ctx];
}

- (void)drawBorderInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);

    const CGFloat inset = kLineWidth / 2.;
    CGRect borderRect = CGRectInset(self.bounds, inset, inset);
    [self.borderColor setStroke];
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:self.layer.cornerRadius];
    borderPath.lineWidth = kLineWidth;
    [borderPath stroke];
    
    CGContextRestoreGState(ctx);
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];

        self.contentViewController = nil;
        
        _contentView = contentView;
        _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

        CGRect frame = contentView.frame;
        frame.origin = CGPointZero;
        _contentView.frame = frame;

        self.frame = frame;
        
        [super addSubview:_contentView];
    }
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController != contentViewController) {
        _contentViewController = nil;       // < avoid recursion
        self.contentView = contentViewController.view;
        _contentViewController = contentViewController;
    }
}

- (void)addSubview:(UIView *)view {
    NSAssert(NO, @"you should use -setContentView: instead");
    [self setContentView:view];
}

- (IBAction)tapDidRecognize:(UITapGestureRecognizer *)gestureRecognizer {
    NSParameterAssert(gestureRecognizer == self.hideOnDarkeningBackViewGestureRecognizer);
    if (self.hideOnTapOutside) {
        [self dismiss];
    }
}

- (void)subscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unsubscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Keyboard Notification Handlers

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = self.originalFrame;
    const CGRect keyboardFrame = [self keyboardFrameFromNotification:notification];
    const CGFloat keyboardY = CGRectGetMinY(keyboardFrame);
    const CGFloat minMargin = 20.;
    CGRectOffset(frame, 0., CGRectGetHeight(keyboardFrame) / 2.);

    if ((CGRectGetMaxY(frame) > keyboardY - minMargin) || (CGRectGetMinY(frame) < minMargin)) {
        const CGFloat heightSpace = CGRectGetMinY(keyboardFrame) - (2 * minMargin);
        const CGFloat height = MIN(heightSpace, CGRectGetHeight(self.frame));
        frame.origin.y = keyboardY - height - minMargin;
        frame.size.height = height;
    }
    self.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!CGRectEqualToRect(self.frame, self.originalFrame)) {
        self.frame = self.originalFrame;
    }
}

- (CGRect)keyboardFrameFromNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    CGRect result = CGRectZero;
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&result];
    result = [self.superview convertRect:result fromView:nil];
    return result;
}


#pragma mark - UIGestureRecognizerDelegate protocol implementation

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL result = YES;
    NSParameterAssert(gestureRecognizer == self.hideOnDarkeningBackViewGestureRecognizer);
    if (gestureRecognizer == self.hideOnDarkeningBackViewGestureRecognizer) {
        CGPoint tapLocation = [gestureRecognizer locationInView:self];
        result = !CGRectContainsPoint(self.bounds, tapLocation);
    }
    return result;
}

@end
