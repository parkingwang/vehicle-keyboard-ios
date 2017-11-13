//
//  PWCollectionViewCell.h
//  PlateKeyboard
//
//  Created by Zy.Feng on 2017/7/26.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWKeyboardView.h"
#import "PWEnumeration.h"

@interface PWCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;

@property (assign, nonatomic) PWKeyboardButtonType type;

@property (assign, nonatomic) UIControlState controlState;

@property (copy, nonatomic) UIColor * selectedColor;

@end
