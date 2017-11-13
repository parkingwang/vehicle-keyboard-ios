//
//  PWSegmentCollectionViewCell.m
//  HybridPlateKeyboard
//
//  Created by fzy on 2017/10/29.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "PWSegmentCollectionViewCell.h"

@implementation PWSegmentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (!self.textLabel) {
            self.textLabel = [UILabel new];
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:self.textLabel];
            NSLayoutAttribute layoutAttributes[4] = {NSLayoutAttributeLeft,NSLayoutAttributeRight,NSLayoutAttributeTop,NSLayoutAttributeBottom};
            for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
                NSLayoutAttribute layoutAttribute = layoutAttributes[i];
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1.0 constant:0];
                [self.contentView addConstraint:constraint];
            }
        }
    }
    return self;
}

@end
