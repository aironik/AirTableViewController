//
//  AITCellEtchedView.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITCellEtchedView.h"

#import "AITSettingsTableView.h"
#import "AITTableViewCell.h"
#import "UIView+AITUserInterfaceIdiom.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITCellEtchedView ()

@property (nonatomic, strong) CAShapeLayer *boundsLayer;

@end


#pragma mark - Implementation


@implementation AITCellEtchedView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    self.color = [UIColor whiteColor];
    if ([[self class] ait_userInterfaceIdiomVersion] != AITUserInterfaceIdiomVersion6) {
        self.backgroundColor = self.color;
        self.borderColor = AIT_COLOR_BORDER;
        self.separatorColor = AIT_COLOR_CELL_SEPARATOR;
        self.separatorInset = UIEdgeInsetsMake(0.f, 20.f, 0.f, 0.f);
        self.layer.masksToBounds = YES;
        // TODO: if we need bounds line we can use additional layer and add it on self.layer with stroked (rounded) bounds.
        [self clipLayer];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)clipLayer {
    [self.boundsLayer removeFromSuperlayer];
    self.boundsLayer = nil;
    if ([[self class] ait_userInterfaceIdiomVersion] == AITUserInterfaceIdiomVersion6) {
        self.layer.mask = nil;
    }
    else {
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.layer.frame;
        maskLayer.path = [self boundsBezierPath].CGPath;
        self.layer.mask = maskLayer;
        
        self.boundsLayer = [[CAShapeLayer alloc] init];
        self.boundsLayer.frame = self.layer.frame;
        self.boundsLayer.path = maskLayer.path;
        self.boundsLayer.lineWidth = 0.f;
        self.boundsLayer.strokeColor = nil;
        self.boundsLayer.backgroundColor = nil;
        self.boundsLayer.fillColor = nil;
        self.boundsLayer.opaque = NO;
        [self.layer addSublayer:self.boundsLayer];
    }
}

- (void)setColor:(UIColor *)color {
    self.layer.backgroundColor = color.CGColor;
    _color = color;
}

- (void)setPosition:(NSUInteger)position {
    if (_position != position) {
        _position = position;
        [self clipLayer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self clipLayer];
}

- (UIBezierPath *)boundsBezierPath {
    UIBezierPath *result = [self bezierPathForRect:self.bounds isBounds:YES];
    [result closePath];
    return result;
}

- (UIBezierPath *)bezierPathForRect:(CGRect)rect isBounds:(BOOL)isBounds {
    const CGFloat radius = 8.f;
    
    const CGFloat minX = CGRectGetMinX(rect);
    const CGFloat maxX = CGRectGetMaxX(rect);
    
    const CGFloat minY = CGRectGetMinY(rect);
    const CGFloat midY = CGRectGetMidY(rect);
    const CGFloat maxY = CGRectGetMaxY(rect);
    
    const BOOL isTop = ((self.position & AITTableViewCellPositionTop) != 0);
    const BOOL isBottom = ((self.position & AITTableViewCellPositionBottom) != 0);
    
    UIBezierPath *result = [UIBezierPath bezierPath];
    [result moveToPoint:CGPointMake(minX, midY)];
    
    if (isTop) {
        [result addArcWithCenter:CGPointMake(minX + radius, minY + radius) radius:radius startAngle:M_PI endAngle:3. * M_PI_2 clockwise:YES];
        [result addArcWithCenter:CGPointMake(maxX - radius, minY + radius) radius:radius startAngle:3. * M_PI_2 endAngle:0 clockwise:YES];
    }
    else {
        [result addLineToPoint:CGPointMake(minX, minY)];
        if (isBounds) {
            [result addLineToPoint:CGPointMake(maxX, minY)];
        }
        else {
            [result moveToPoint:CGPointMake(maxX, minY)];
        }
    }
    if (isBottom) {
        [result addArcWithCenter:CGPointMake(maxX - radius, maxY - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [result addArcWithCenter:CGPointMake(minX + radius, maxY - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    }
    else {
        [result addLineToPoint:CGPointMake(maxX, maxY)];
        if (isBounds) {
            [result addLineToPoint:CGPointMake(minX, maxY)];
        }
        else {
            [result moveToPoint:CGPointMake(minX, maxY)];
        }
    }
    [result addLineToPoint:CGPointMake(minX, midY)];

    return result;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBoundsWithRect:rect inContext:context];
    [self drawSeparatorWithRect:rect inContext:context];
}

- (void)drawBoundsWithRect:(CGRect)rect inContext:(CGContextRef)context {
    UIBezierPath *bezierPath = [self bezierPathForRect:rect isBounds:NO];
    bezierPath.lineWidth = AIT_BORDER_WIDTH;
    [self.borderColor setStroke];
    [bezierPath stroke];
}

- (void)drawSeparatorWithRect:(CGRect)rect inContext:(CGContextRef)context {
    const BOOL isBottom = ((self.position & AITTableViewCellPositionBottom) != 0);
    if (!isBottom) {
        const CGFloat maxY = CGRectGetMaxY(rect);
        
        const CGFloat minX = CGRectGetMinX(rect);
        const CGFloat maxX = CGRectGetMaxX(rect);

        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(minX + self.separatorInset.left, maxY)];
        [bezierPath addLineToPoint:CGPointMake(maxX - self.separatorInset.right, maxY)];

        bezierPath.lineWidth = AIT_BORDER_WIDTH;
        [self.separatorColor setStroke];
        [bezierPath stroke];
    }
}


@end
