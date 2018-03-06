//
//  TestCollectionViewCell.m
//  HybridPlateKeyboard
//
//  Created by fzy on 2017/10/30.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "TestCollectionViewCell.h"

@interface TestCollectionViewCell ()

@property (strong, nonatomic) UIView * view;

@property (strong, nonatomic) CALayer * bickerLayer;

@end

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        CALayer *layer = [CALayer new];
//        layer.frame = CGRectMake( 0, 0, 1, 40);
//        layer.backgroundColor = [UIColor blackColor].CGColor;
//        [self.layer addSublayer:layer];
//        self.bickerLayer addAnimation:<#(nonnull CAAnimation *)#> forKey:<#(nullable NSString *)#>
        self.bickerLayer = [CALayer new];
        self.bickerLayer.frame = CGRectMake(10, 0, 4, CGRectGetHeight(frame));
        self.bickerLayer.backgroundColor = [UIColor yellowColor].CGColor;
        [self.bickerLayer addAnimation:[self opacityForever_Animation:0.33] forKey:@"opacity"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.backgroundColor = [UIColor brownColor];
        if (self.bickerLayer.superlayer) {
            return;
        }
        [self.layer addSublayer:self.bickerLayer];
    } else {
        self.contentView.backgroundColor = [UIColor cyanColor];
        if (self.bickerLayer.superlayer) {
            [self.bickerLayer removeFromSuperlayer];
        }
    }
}

-(CABasicAnimation *)opacityForever_Animation:(float)time

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    animation.autoreverses = YES;
    
    animation.duration = time;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
    
}

@end
