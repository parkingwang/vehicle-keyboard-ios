//
//  PWKeyboardView.m
//  PWKeyboardDemo
//
//  Created by fzy on 2017/11/13.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "PWKeyboardView.h"
#import "PWCollectionViewCell.h"

#define PWKeyboardViewHorizontalMargin 4
#define PWKeyboardViewHorizontalEdge 4
#define PWKeyboardViewVerticalMargin 4
#define PWKeyboardViewVerticalEdge 3.5

#define PWKeyboardViewHeightLow 196
#define PWKeyboardViewHeightNormal 240
#define PWKeyboardViewHeightPlus 258

@interface PWCollectionLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) NSArray<NSArray<PWModel *> *> * source;
@property (assign, nonatomic) CGSize doneCellSize;
@property (assign, nonatomic) CGSize deleteCellSize;
@property (strong, nonatomic) UICollectionView * linkCollectionView;

@end

@implementation PWCollectionLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
    if (!attributes.count) {
        return attributes;
    }
    NSInteger startIndex = 0;
    for (NSInteger i = 0; i < self.source.count - 1; i++) {
        startIndex += self.source[i].count;
    }
    
    CGFloat horizontalMargin = PWKeyboardViewHorizontalMargin;
    UICollectionViewLayoutAttributes* attri = attributes.firstObject;
    CGFloat width = attri.frame.size.width;
    CGFloat deleteCellX = CGRectGetWidth(self.linkCollectionView.bounds) - PWKeyboardViewHorizontalEdge - PWKeyboardViewHorizontalMargin - self.doneCellSize.width - self.deleteCellSize.width - 1.5;
    if (self.source.firstObject.count == 11) {
        horizontalMargin = PWKeyboardViewHorizontalMargin / 2;
        width = (deleteCellX - PWKeyboardViewHorizontalEdge) / (self.source.lastObject.count - 2) - horizontalMargin;
    }
    for (NSInteger i = 0; i < self.source.lastObject.count; i++) {
        UICollectionViewLayoutAttributes* attri = attributes[startIndex + i];
        CGRect rect = attri.frame;
        if (i == 0) {
            rect.size.width = width;
            rect.origin.x = PWKeyboardViewHorizontalEdge;
        } else if (i == self.source.lastObject.count - 2) {
            rect.origin.x = deleteCellX;
        } else {
            UICollectionViewLayoutAttributes * preAttri = attributes[startIndex + i - 1];
            if (i == self.source.lastObject.count - 1) {
                rect.origin.x = CGRectGetMaxX(preAttri.frame) + PWKeyboardViewHorizontalMargin + 1;
                rect.origin.y = CGRectGetMinY(preAttri.frame);
            } else {
                rect.size.width = width;
                rect.origin.x = CGRectGetMaxX(preAttri.frame) + horizontalMargin;
            }
        }
        attri.frame = rect;
    }
    return attributes;
}

@end

@interface PWMarkView : UIImageView

@property (strong, nonatomic) UILabel * label;

@end

@implementation PWMarkView

- (instancetype)init {
    if (self = [super init]) {
        self.label = [UILabel new];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.font = [UIFont systemFontOfSize:29 weight:UIFontWeightMedium];
        [self addSubview:self.label];
        NSLayoutAttribute layoutAttributes[4] = {NSLayoutAttributeLeft,NSLayoutAttributeRight,NSLayoutAttributeTop,NSLayoutAttributeBottom};
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            CGFloat constant;
            if (layoutAttribute == NSLayoutAttributeTop) {
                constant = -25;
            } else {
                constant = 0;
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.label attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:layoutAttribute multiplier:1.0 constant:constant];
            [self addConstraint:constraint];
        }
        
        NSString *path = [[NSBundle bundleForClass:[PWCollectionViewCell class]] pathForResource:@"PWBundle" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        NSString *file = [bundle pathForResource:@"pressed@2x" ofType:@"png" inDirectory:@"Image"];
        self.image = [UIImage imageWithContentsOfFile:file];
        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

@end

@interface PWKeyboardView()<UIWebViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIWebView *webview;

@property (strong, nonatomic) JSContext *jsContext;

@property (copy, nonatomic) NSArray<NSArray<PWModel *> *> * source;

@property (strong, nonatomic) UICollectionView * collectionView;

@property (strong, nonatomic) UIView * divisionLine;

@property (copy, nonatomic) NSString * recordPlate;

@property (strong, nonatomic) PWMarkView * markView;

@property (strong, nonatomic) PWCollectionLayout * collectionViewLayout;

@property (assign, nonatomic) CGFloat horizontalMargin;

@end



@implementation PWKeyboardView

@synthesize selectedColor = _selectedColor;

+ (instancetype)shareInstance {
    static PWKeyboardView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PWKeyboardView alloc]init];
        instance.markView = [PWMarkView new];
    });
    return instance;
}

- (instancetype)init {
    CGFloat height = CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds) ? CGRectGetWidth([UIScreen mainScreen].bounds) : CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat keyboardHeight;
    if (height == 812) {
        keyboardHeight = PWKeyboardViewHeightPlus;
    } else if (height > 667) {
        keyboardHeight = PWKeyboardViewHeightNormal;
    } else {
        keyboardHeight = PWKeyboardViewHeightLow;
    }
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, keyboardHeight) inputViewStyle:UIInputViewStyleKeyboard]) {
        self.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
        self.type = PWKeyBoardTypeCivilAndArmy;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStatusBarOrientationChange:)
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [self setupWebView];
    }
    return self;
}

//界面方向改变的处理
- (void)handleStatusBarOrientationChange: (NSNotification *)notification{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setConstraints];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (void)setConstraints {
    [self removeConstraints:self.constraints];
    [self updateConstraintsIfNeeded];
    NSLayoutAttribute layoutAttributes[4] = {NSLayoutAttributeLeft,NSLayoutAttributeRight,NSLayoutAttributeTop,NSLayoutAttributeBottom};
    if (CGRectGetWidth([UIScreen mainScreen].bounds) == 812) {
        CGFloat constants[4] = {34,-34,2,-14};
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:layoutAttribute multiplier:1.0 constant:constants[i]];
            [self addConstraint:constraint];
        }
    } else if (CGRectGetHeight([UIScreen mainScreen].bounds) == 812) {
        CGFloat constants[4] = {0,0,2,-34};
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:layoutAttribute multiplier:1.0 constant:constants[i]];
            [self addConstraint:constraint];
        }
    } else {
        CGFloat constants[4] = {0,0,2,3};
        for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
            NSLayoutAttribute layoutAttribute = layoutAttributes[i];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:layoutAttribute multiplier:1.0 constant:constants[i]];
            [self addConstraint:constraint];
        }
    }
    
    for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
        NSLayoutAttribute layoutAttribute = layoutAttributes[i];
        NSLayoutConstraint *constraint;
        if (i != 3) {
            constraint = [NSLayoutConstraint constraintWithItem:self.divisionLine attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:layoutAttribute multiplier:1.0 constant:0];
        } else {
            constraint = [NSLayoutConstraint constraintWithItem:self.divisionLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1 / [[UIScreen mainScreen] scale]];
        }
        
        [self addConstraint:constraint];
    }
}

- (void)setupWebView{
    self.webview = [UIWebView new];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"PWBundle" ofType:@"bundle"]];
    NSString *keboardPath = [bundle pathForResource:@"index" ofType:@"html" inDirectory:@"js"];
    
    NSString *htmlCont = [NSString stringWithContentsOfFile:keboardPath encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlCont baseURL:[NSURL fileURLWithPath:keboardPath]];
    self.webview.delegate = self;
    
    self.divisionLine = [UIView new];
    self.divisionLine.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
    self.divisionLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.divisionLine];
    
    self.collectionViewLayout = [PWCollectionLayout new];
    self.collectionViewLayout.minimumInteritemSpacing = PWKeyboardViewHorizontalMargin / 2;
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.collectionViewLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.collectionViewLayout.linkCollectionView = self.collectionView;
    self.collectionView.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.delaysContentTouches = NO;
    self.collectionView.canCancelContentTouches = YES;
    self.markView = [PWMarkView new];
    
    [self.collectionView registerClass:PWCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(PWCollectionViewCell.class)];
    [self addSubview:self.collectionView];
    [self setConstraints];
    
    self.markView = [PWMarkView new];
}

- (void)resetSourceWithModel:(PWListModel *)listModel {
    NSMutableArray * tempArr = [NSMutableArray new];
    if (listModel.row0.count) [tempArr addObject:listModel.row0];
    if (listModel.row1.count) [tempArr addObject:listModel.row1];
    if (listModel.row2.count) [tempArr addObject:listModel.row2];
    if (listModel.row3.count) [tempArr addObject:listModel.row3];
    if (listModel.row4.count) [tempArr addObject:listModel.row4];
    self.source = tempArr;
    self.collectionViewLayout.source = self.source;
}

#pragma mark - cell size

- (CGSize)cellSize {
    NSInteger maxCount = 0;
    for (NSInteger i = 0; i < self.source.count; i++) {
        if (maxCount < self.source[i].count) {
            maxCount = self.source[i].count;
        }
    }
    if (maxCount == 11) {
        self.horizontalMargin = PWKeyboardViewHorizontalMargin / 2;
    } else {
        self.horizontalMargin = PWKeyboardViewHorizontalMargin;
    }
    return CGSizeMake((CGRectGetWidth(self.collectionView.bounds) - PWKeyboardViewHorizontalEdge * 2 + self.horizontalMargin) / maxCount - self.horizontalMargin, (CGRectGetHeight(self.collectionView.bounds) - PWKeyboardViewVerticalMargin) / self.source.count - PWKeyboardViewVerticalMargin * 2);;
}

- (CGSize)doneCellSize {
    CGFloat width = ((CGRectGetWidth(self.collectionView.bounds) - PWKeyboardViewHorizontalEdge * 2) / 10 - PWKeyboardViewHorizontalMargin) * 2;
    CGFloat height = (CGRectGetHeight(self.collectionView.bounds)) / self.source.count - PWKeyboardViewVerticalMargin * 2;
    self.collectionViewLayout.doneCellSize = CGSizeMake(width, height);
    return CGSizeMake(width, height);
}

- (CGSize)deleteCellSize {
    CGFloat width = ((CGRectGetWidth(self.collectionView.bounds) - PWKeyboardViewHorizontalEdge * 2) / 10 - PWKeyboardViewHorizontalMargin) + PWKeyboardViewHorizontalMargin;
    CGFloat height = (CGRectGetHeight(self.collectionView.bounds)) / self.source.count - PWKeyboardViewVerticalMargin * 2;
    self.collectionViewLayout.deleteCellSize = CGSizeMake(width, height);
    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == self.source.count - 1) {
        return UIEdgeInsetsMake(PWKeyboardViewVerticalMargin, PWKeyboardViewHorizontalEdge, PWKeyboardViewVerticalMargin, PWKeyboardViewHorizontalEdge);
    } else {
        CGFloat diff = (CGRectGetWidth(collectionView.bounds) - (([self cellSize].width + self.horizontalMargin) * self.source[section].count + PWKeyboardViewHorizontalEdge * 2 - self.horizontalMargin)) / 2;
        return UIEdgeInsetsMake(PWKeyboardViewVerticalMargin, PWKeyboardViewHorizontalEdge + diff, PWKeyboardViewVerticalMargin, PWKeyboardViewHorizontalEdge + diff);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.source.count - 1) {
        if (indexPath.row == self.source[indexPath.section].count - 2) {
            return [self deleteCellSize];
        } else if (indexPath.row == self.source[indexPath.section].count - 1) {
            return [self doneCellSize];
        }
    }
    return [self cellSize];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.source.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.source[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PWCollectionViewCell" forIndexPath:indexPath];
    cell.selectedColor = self.selectedColor;
    PWModel * model = self.source[indexPath.section][indexPath.row];
    cell.type = model.keyCode;
    [cell setType:model.keyCode];
    switch (model.keyCode) {
        case PWKeyboardButtonTypeOutput: {
            cell.label.text = model.text;
            if (model.enabled) {
                [cell setControlState:UIControlStateNormal];
            } else {
                [cell setControlState:UIControlStateDisabled];
            }
        } break;
        case PWKeyboardButtonTypeDelete: {
            cell.label.text = @"";
            [cell setControlState:UIControlStateNormal];
        } break;
        case PWKeyboardButtonTypeDone: {
            cell.label.text = model.text;
            if (self.recordPlate.length == self.length) {
                [cell setControlState:UIControlStateNormal];
            } else {
                [cell setControlState:UIControlStateDisabled];
            }
        } break;
    }
    if ([self isChinese:cell.label.text]) {
        cell.label.font = [UIFont systemFontOfSize:21];
    } else {
        cell.label.font = [UIFont systemFontOfSize:23];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionViewCell * cell = (PWCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(cell.type,cell.label.text);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    PWCollectionViewCell * cell = (PWCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.type == PWKeyboardButtonTypeOutput) {
        [self markViewShowOnCell:cell];
    }
    [cell setControlState:UIControlStateHighlighted];
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PWCollectionViewCell * cell = (PWCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self markViewHide];
        [cell setControlState:UIControlStateReserved];
    });
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    __weak typeof (self)weakSelf = self;
    self.jsContext= [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        if (exceptionValue) {
            [weakSelf setPlate:@"" type:weakSelf.type index:0];
        }
        PWKBLog(@"[ParkWangKeyBoard] --- JS Exception [%@]", exceptionValue);
    };
    [self setPlate:@"" type:self.type index:0];
}

#pragma mark - display

- (void)markViewShowOnCell:(PWCollectionViewCell *)cell {
    if (CGRectGetWidth(self.markView.bounds) < 10) {
        CGFloat width = [self cellSize].width + 18;
        CGFloat height = [self cellSize].height + 30;
        if (width > 54) width = 54;
        if (height > 84) height = 84;
        self.markView.frame = CGRectMake(0, 0, width, height);
    }
    self.markView.center = CGPointMake(CGRectGetMidX(cell.frame), CGRectGetMinY(cell.frame) - CGRectGetHeight(self.markView.bounds) / 3);
    self.markView.label.text = cell.label.text;
    if ([self isChinese:self.markView.label.text]) {
        self.markView.label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    } else {
        self.markView.label.font = [UIFont systemFontOfSize:29 weight:UIFontWeightMedium];
    }
    self.markView.hidden = NO;
    if (![self.markView superview]) {
        [self.collectionView addSubview:self.markView];
    }
    
}

- (void)markViewHide {
    self.markView.hidden = YES;
}

#pragma mark - plate

- (void)setPlate:(NSString *)plate type:(PWKeyboardType)type index:(NSInteger)index {
    self.type = type;
    [self setPlate:plate type:type numType:PWKeyboardNumTypeAuto index:index];
}

- (void)setPlate:(NSString *)plate type:(PWKeyboardType)type numType:(PWKeyboardNumType)numType index:(NSInteger)index {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.jsContext) {
            self.numType = numType;
            self.recordPlate = plate;
            NSString *jsMethod = [NSString stringWithFormat:@"engine.update(%@,%@,'%@',%@)",@(type),@(index),plate,@(numType)];
            PWKBLog(@"[ParkWangKeyBoard] --- Keyboard init [%@]",jsMethod);
            JSValue * jsValue = [self.jsContext evaluateScript:jsMethod];
            PWListModel * listModel = [[PWListModel alloc] initWithDictionary:[jsValue toDictionary] error:nil];
            if (listModel) {
                [self resetSourceWithModel:listModel];
                if (self.delegate && [self.delegate respondsToSelector:@selector(modelAlreadyUpdate:)]) {
                    [self.delegate modelAlreadyUpdate:listModel];
                }
            } else {
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
            }
            [self.collectionView reloadData];
        }
    });
}

#pragma mark - set get
- (NSUInteger)length {
    return self.numType == PWKeyboardNumTypeNewEnergy ? 8 : 7;
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = [UIColor colorWithRed:29.f/255.f green:143.f/255.f blue:238.f/255.f alpha:1.f];
    }
    return _selectedColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.markView.label.textColor = selectedColor;
}

#pragma mark - Logical
- (NSString *)onlyOneKey {
    NSInteger count = 0;
    NSString * key = nil;
    for (NSInteger i = 0; i < self.source.count; i++) {
        for (NSInteger j = 0; j < self.source[i].count; j++) {
            PWModel * model = self.source[i][j];
            if (!model.isFunKey && model.enabled) {
                count ++;
                if (count > 1) {
                    return nil;
                } else {
                    key = model.text;
                }
            }
        }
    }
    return key;
}

- (BOOL)isChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

@end
