//
//  UIView+PWCorners.m
//  HybridPlateKeyboard
//
//  Created by fzy on 2017/11/3.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "UIView+PWCorners.h"

@implementation UIView (PWCorners)

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

@end
