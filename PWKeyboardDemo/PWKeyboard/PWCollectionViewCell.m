//
//  PWCollectionViewCell.m
//  PlateKeyboard
//
//  Created by Zy.Feng on 2017/7/26.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "PWCollectionViewCell.h"
#import "PWEnumeration.h"

@interface PWCollectionViewCell ()

@property (strong, nonatomic) UIImageView * shadowImageView;

@property (copy, nonatomic) CALayer * doneLayer;

@end

@implementation PWCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = NO;
        self.clipsToBounds = NO;
        
        NSString *path = [[NSBundle bundleForClass:[PWCollectionViewCell class]] pathForResource:@"PWBundle" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        NSLayoutAttribute layoutAttributes[4] = {NSLayoutAttributeLeft,NSLayoutAttributeRight,NSLayoutAttributeTop,NSLayoutAttributeBottom};
        
        UIImage * normalImage = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"btn_normal@2x" ofType:@"png" inDirectory:@"Image"]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        UIImage * pressedImage = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"btn_pressed@2x" ofType:@"png" inDirectory:@"Image"]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        self.shadowImageView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:pressedImage];
        self.shadowImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.shadowImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.shadowImageView];
        CGFloat constants[4] = {-1,1,0,3.5};
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.shadowImageView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1.0 constant:constants[i]];
            [self.contentView addConstraint:constraint];
        }
        
        self.label = [UILabel new];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.label];
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.label attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1.0 constant:0];
            [self.contentView addConstraint:constraint];
        }
        
        NSString *file = [bundle pathForResource:@"delete@2x" ofType:@"png" inDirectory:@"Image"];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:file]];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1.0 constant:0];
            [self.contentView addConstraint:constraint];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    //不重写会使用父类的此方法，引起问题
}

- (void)setType:(PWKeyboardButtonType)type {
    _type = type;
    switch (type) {
        case PWKeyboardButtonTypeOutput: {
            self.label.hidden = NO;
            self.imageView.hidden = YES;
            self.shadowImageView.hidden = NO;
            self.label.textColor = [UIColor blackColor];
            self.contentView.backgroundColor = [UIColor clearColor];
            
            [self layerChangePosition:NO];
        } break;
        case PWKeyboardButtonTypeDelete: {
            self.label.hidden = YES;
            self.imageView.hidden = NO;
            self.shadowImageView.hidden = NO;
            self.contentView.backgroundColor = [UIColor clearColor];
            [self layerChangePosition:NO];
        } break;
        case PWKeyboardButtonTypeDone: {
            self.label.hidden = NO;
            self.imageView.hidden = YES;
            self.shadowImageView.hidden = YES;
            self.label.textColor = [UIColor whiteColor];
            [self layerChangePosition:YES];
        } break;
    }
}

- (void)setControlState:(UIControlState)controlState {
    _controlState = controlState;
    if (controlState != UIControlStateHighlighted) {
        self.shadowImageView.highlighted = NO;
    }
    if (self.type == PWKeyboardButtonTypeDone) {
        self.label.alpha = 1;
    }
    switch (controlState) {
        case UIControlStateNormal:
            self.userInteractionEnabled = YES;
            if (self.type == PWKeyboardButtonTypeDone) {
                [self layerChangeColor:self.selectedColor];
            }
            self.label.alpha = 1;
            break;
        case UIControlStateHighlighted:
            if (self.type == PWKeyboardButtonTypeDone) {
                self.label.alpha = 0.3;
            }
            self.shadowImageView.highlighted = YES;
            break;
        case UIControlStateDisabled:
            if (self.type == PWKeyboardButtonTypeDone) {
                [self layerChangeColor:[UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1.f]];
            } else {
                self.label.alpha = 0.3;
            }
            self.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}

- (void)layerChangeColor:(UIColor *)color {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.doneLayer.backgroundColor = color.CGColor;
    self.doneLayer.shadowColor = color.CGColor;
    [CATransaction commit];
}

- (void)layerChangePosition:(BOOL)isAdd {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isAdd) {
        if (![self.doneLayer superlayer]) {
            [self.layer insertSublayer:self.doneLayer atIndex:0];
            self.doneLayer.frame = self.layer.bounds;
        }
    } else {
        [self.doneLayer removeFromSuperlayer];
    }
    [CATransaction commit];
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = [UIColor colorWithRed:29.f/255.f green:143.f/255.f blue:238.f/255.f alpha:1.f];
    }
    return _selectedColor;
}


- (CALayer *)doneLayer {
    if (!_doneLayer) {
        _doneLayer = [CALayer new];
        _doneLayer.cornerRadius = 4.f;
        _doneLayer.shadowOpacity = .7f;
        _doneLayer.shadowOffset = CGSizeMake(0, 1);
        _doneLayer.shadowRadius = 1.f;
    }
    return _doneLayer;
}

@end
