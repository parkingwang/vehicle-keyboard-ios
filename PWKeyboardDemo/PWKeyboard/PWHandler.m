//
//  PWHandler.m
//  HybridPlateKeyboard
//
//  Created by fzy on 2017/10/29.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "PWHandler.h"

#import "PWSegmentCollectionViewCell.h"

#import "UIView+PWCorners.h"

typedef NS_ENUM(NSInteger,PWHandlerOperationType){
    PWHandlerOperationTypeSet = 0,
    PWHandlerOperationTypeDelete = 1,
};

@interface PWHandler () <PWKeyboardViewDelegate>

@property (copy, nonatomic) NSMutableArray * chars;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger previousIndex;
@property (copy, nonatomic) NSString * reuseIdentifier;

@property (assign, nonatomic) PWHandlerOperationType operationType;

@property (strong, nonatomic) PWKeyboardView * keyBoard;

@property (strong, nonatomic) UITextField * textField;

@end

@implementation PWHandler

- (instancetype)init {
    if (self = [super init]) {
        __weak typeof (self)weakSelf = self;
        self.keyBoard = [PWKeyboardView shareInstance];
        self.keyBoard.buttonClickBlock = ^(PWKeyboardButtonType buttonType, NSString *text) {
            switch (buttonType) {
                case PWKeyboardButtonTypeOutput: {
                    [weakSelf set:text];
                }  break;
                case PWKeyboardButtonTypeDelete: {
                    [weakSelf delete];
                }  break;
                case PWKeyboardButtonTypeDone: {
                    [weakSelf.keyBoard hide];
                }  break;
            }
        };
        self.keyBoard.delegate = self;
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.maskView.backgroundColor = [UIColor clearColor];
        self.maskView.layer.borderWidth = 2;
        self.maskView.layer.borderColor = [UIColor redColor].CGColor;
        self.maskView.userInteractionEnabled = NO;
        self.maskViewOffset = CGSizeMake(2, 0);
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self init];
    self.reuseIdentifier = reuseIdentifier;
    return self;
}

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PWSegmentCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.chars[indexPath.row];
    cell.selected = self.index == indexPath.row;
    if (self.index == indexPath.row) {
        [self changeMaskViewPlace:self.index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:currentIndexPath:cell:)]) {
            [self.delegate collectionView:collectionView currentIndexPath:indexPath cell:cell];
        }
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keyBoard.length;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView reloadData];
    if (!self.keyBoard.isShow && self.delegate && [self.delegate respondsToSelector:@selector(plateBeginEditing:index:)]) {
        [self.delegate plateBeginEditing:self.plate index:self.index];
    }
    if (![self.textField isFirstResponder]) {
        [self.textField becomeFirstResponder];
        [self.keyBoard show];
    }
    return [self isRightfulWithCurrentIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.index = indexPath.row;
    [self keyboardIndexChange];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) / self.keyBoard.length, CGRectGetHeight(collectionView.bounds));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumInteritemSpacing;
}

#pragma mark - PWKeyboardViewDelegate
- (void)modelAlreadyUpdate:(PWListModel *)listModel {
    NSString * key;
    if (self.operationType == PWHandlerOperationTypeSet && (self.plate.length == 1 || self.plate.length == self.keyBoard.length - 1) && (key = [self.keyBoard onlyOneKey])) {
        [self set:key];
    }
}

#pragma mark - logic
- (BOOL)isRightfulWithCurrentIndex:(NSUInteger)index {
    for (NSUInteger i = 0; i < index; i++) {
        if ([self.chars[i] isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (void)delete {
    self.operationType = PWHandlerOperationTypeDelete;
    if (self.plate.length == 0) {
        return;
    }
    for (NSInteger i = self.chars.count - 1; i >= 0; i--) {
        if (![self.chars[i] isEqualToString:@""]) {
            self.chars[i] = @"";
            self.index = i;
            [self keyboardChange];
            return;
        }
    }
}

- (void)set:(NSString *)string {
    self.operationType = PWHandlerOperationTypeSet;
    self.chars[self.index] = string;
    self.index ++;
    if (self.index == self.chars.count) {
        self.index = self.chars.count - 1;
    }
    [self keyboardChange];
}

- (void)keyboardChange {
    [self.keyBoard setPlate:self.plate type:self.keyBoard.type numType:self.keyBoard.numType index:self.index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(plateChange:isCompletion:index:previousIndex:)]) {
        [self.delegate plateChange:self.plate isCompletion:self.plate.length == self.keyBoard.length index:self.index previousIndex:self.previousIndex];
    }
    [self.collectionView reloadData];
}

- (void)keyboardIndexChange {
    [self.keyBoard setPlate:self.plate type:self.keyBoard.type numType:self.keyBoard.numType index:self.index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(plateIndexChange:previousIndex:)]) {
        [self.delegate plateIndexChange:self.index previousIndex:self.previousIndex];
    }
    [self.collectionView reloadData];
}

- (void)changeMaskViewPlace:(NSInteger)index {
    if (!self.maskView) {
        return;
    }
    if (!self.maskView.superview) {
         [self.collectionView addSubview:self.maskView];
    }
    self.maskView.frame = CGRectMake(CGRectGetWidth(self.collectionView.bounds)/self.keyBoard.length * index - self.maskViewOffset.width / 2, -self.maskViewOffset.height / 2, CGRectGetWidth(self.collectionView.bounds)/self.keyBoard.length + self.maskViewOffset.width, CGRectGetHeight(self.collectionView.bounds) + self.maskViewOffset.height);
    if (index == 0) {
        [self.maskView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(2,2)];
    } else if (index == self.keyBoard.length - 1) {
        [self.maskView addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight withRadii:CGSizeMake(2,2)];
    } else {
        [self.maskView addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(0,0)];
    }
}

#pragma mark - lazy
- (NSMutableArray *)chars {
    if (!_chars) {
        _chars = [NSMutableArray new];
        for (NSUInteger i = 0; i < self.keyBoard.length; i++) {
            [_chars addObject:@""];
        }
    }
    if (_chars.count < self.keyBoard.length) {
        [_chars addObject:@""];
    } else if (_chars.count > self.keyBoard.length) {
        if (self.index == _chars.count - 1) {
            self.index = _chars.count - 2;
        }
        [_chars removeLastObject];
    }
    return _chars;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.inputView = self.keyBoard;
        [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    }
    return _textField;
}

#pragma mark - get & set
- (NSString *)plate {
    return [self.chars componentsJoinedByString:@""];
}

- (void)setPlate:(NSString *)plate {
    if (plate.length > self.keyBoard.length) {
        plate = [plate substringToIndex:self.keyBoard.length];
    }
    for (NSInteger i = 0; i < self.keyBoard.length; i++) {
        if (i < plate.length) {
            self.chars[i] = [plate substringWithRange:NSMakeRange(i, 1)];
        } else {
            self.chars[i] = @"";
        }
    }
    self.index = plate.length == self.keyBoard.length ? plate.length - 1 : plate.length;
    [self keyboardChange];
}

- (void)setNumType:(PWKeyboardNumType)numType {
    _numType = numType;
    self.keyBoard.numType = numType;
    if (self.index > self.keyBoard.length - 1) {
        self.index --;
    } else if (self.index == self.keyBoard.length - 2 && self.plate.length == self.keyBoard.length -1) {
        self.index ++;
    }
    [self keyboardChange];
}

- (void)setKeyboardSelectedColor:(UIColor *)keyboardSelectedColor {
    _keyboardSelectedColor = keyboardSelectedColor;
    self.keyBoard.selectedColor = keyboardSelectedColor;
}

- (BOOL)isShow {
    return self.keyBoard.isShow;
}

- (void)setIndex:(NSInteger)index {
    self.previousIndex = _index;
    if (self.previousIndex > self.keyBoard.length - 1) {
        self.previousIndex --;
    }
    _index = index;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

@end
