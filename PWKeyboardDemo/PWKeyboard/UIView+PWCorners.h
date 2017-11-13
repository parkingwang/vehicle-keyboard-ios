//
//  UIView+PWCorners.h
//  HybridPlateKeyboard
//
//  Created by fzy on 2017/11/3.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PWCorners)

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

@end
