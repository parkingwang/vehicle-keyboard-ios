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

@end

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        CALayer *layer = [CALayer new];
//        layer.frame = CGRectMake( 0, 0, 1, 40);
//        layer.backgroundColor = [UIColor blackColor].CGColor;
//        [self.layer addSublayer:layer];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.backgroundColor = [UIColor brownColor];
    } else {
        self.contentView.backgroundColor = [UIColor cyanColor];
    }
}

@end
