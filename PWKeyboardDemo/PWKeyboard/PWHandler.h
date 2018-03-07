//
//  PWHandler.h
//  HybridPlateKeyboard
//
//  Created by fzy on 2017/10/29.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWKeyboardView.h"

@protocol PWHandlerDelegate <NSObject>

/**
 车牌号发生改变时的回调

 @param plate 当前车牌号
 @param isCompletion 是否已输入完整
 */
- (void)plateChange:(NSString *)plate isCompletion:(BOOL)isCompletion index:(NSInteger)index previousIndex:(NSInteger)previousIndex;

- (void)plateIndexChange:(NSInteger)index previousIndex:(NSInteger)previousIndex;

- (void)plateBeginEditing:(NSString *)plate index:(NSInteger)index;

/**
 选中cell的回调
 */
- (void)collectionView:(UICollectionView *)collectionView currentIndexPath:(NSIndexPath *)indexPath cell:(UICollectionViewCell *)cell;

//- (void)plateEndEditing:(NSString *)plate index:(NSInteger)index;

//- (BOOL)shouldDone:(NSString *)plate index:(NSInteger)index;

- (void)plateKeyboardIsShow:(BOOL)isShow;

@end

@interface PWHandler : NSObject <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//PWHandler中(NSString *)plate提供车牌号的主动设置，可也用此属性过去当前的车牌号
@property (copy, nonatomic) NSString * plate;
//提供使用者切换车牌号类型 普通/能源
@property (assign, nonatomic) PWKeyboardNumType numType;
//键盘的选中颜色及标签视图的字体颜色
@property (copy, nonatomic) UIColor * keyboardSelectedColor;
//与使用者声明的UICollectionView进行关联
@property (strong, nonatomic) UICollectionView * collectionView;
//蒙版，在选中的view上面，可设置属性或者使用者重新初始化
@property (strong, nonatomic) UIView * maskView;
//cell间隔
@property (assign, nonatomic) CGFloat minimumInteritemSpacing;
//蒙版视图宽高的增量，(0,0)表示延cell边缘，正数向外扩充，负数向内聚合
@property (assign, nonatomic) CGSize maskViewOffset;

@property (weak, nonatomic) id <PWHandlerDelegate> delegate;

//注册方法
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

//在下一次runloop调用，比如viewDidAppear
- (void)show;
- (void)hide;

@end
