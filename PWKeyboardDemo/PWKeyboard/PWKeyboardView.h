//
//  PWKeyboardView.h
//  PWKeyboardDemo
//
//  Created by fzy on 2017/11/13.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UITextField+extension.h"
#import "PWModel.h"
#import "PWEnumeration.h"

#ifdef DEBUG
#define PWKBLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define PWKBLog(s, ...)
#endif

@class PWListModel;
@protocol PWKeyboardViewDelegate <NSObject>
- (void)modelAlreadyUpdate:(PWListModel *)listModel;
@end

/**
 按键的回调
 
 @param buttonType 键位类型
 @param text 键位对应的字符串(删除键对应字符串为@"")
 */
typedef void(^ButtonClickBlock)(PWKeyboardButtonType buttonType, NSString *text);

@interface PWKeyboardView : UIInputView

@property (strong, nonatomic) ButtonClickBlock buttonClickBlock;
@property (assign, nonatomic) PWKeyboardType type;
@property (assign, nonatomic) PWKeyboardNumType numType;
@property (assign, nonatomic, readonly) NSUInteger length;//车牌号限制长度
@property (copy, nonatomic) UIColor * selectedColor;//选中色

@property (weak, nonatomic) id<PWKeyboardViewDelegate> delegate;

@property (assign, nonatomic, readonly) BOOL isShow;

+ (instancetype)shareInstance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

//如果只有一个可输入的键，返回此键，否则返回nil
- (NSString *)onlyOneKey;

/**
 将当前的文本传递给js，刷新键盘，以获取对应的键位
 
 @param plate 当前的文本
 @param type 键盘类型
 @param numType 车牌类型
 @param index 光标所在的索引位置
 */
- (void)setPlate:(NSString *)plate type:(PWKeyboardType)type numType:(PWKeyboardNumType)numType index:(NSInteger)index;
- (void)setPlate:(NSString *)plate type:(PWKeyboardType)type index:(NSInteger)index;

- (void)show;
- (void)hide;

@end
