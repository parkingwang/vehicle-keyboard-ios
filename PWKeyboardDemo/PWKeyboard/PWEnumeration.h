//
//  PWEnumeration.h
//  PlateKeyboard
//
//  Created by fzy on 2017/11/1.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 车牌键盘类型
 
 - PWKeyBoardTypeFull: 全车牌键盘
 - PWKeyBoardTypeCivil: 纯民用车牌键盘
 - PWKeyBoardTypeCivilAndArmy: 民用+武警车牌键盘
 */
typedef NS_ENUM(NSInteger,PWKeyboardType){
    PWKeyBoardTypeFull = 0,
    PWKeyBoardTypeCivil = 1,
    PWKeyBoardTypeCivilAndArmy = 2,
};

/**
 车牌类型

 - PWKeyboardNumTypeAuto: 自动探测试
 - PWKeyboardNumTypeCivil: 民用车牌
 - PWKeyboardNumTypeWuJing: 武警总队
 - PWKeyboardNumTypeWuJingLocal: 武警地方
 - PWKeyboardNumTypeArmy: 军队车牌
 - PWKeyboardNumTypeNewEnergy: 新能源车牌
 - PWKeyboardNumTypeEmbassy: 大使馆车牌
 - PWKeyboardNumTypeEmbassyNew: 新大使馆车牌
 */
typedef NS_ENUM(NSInteger,PWKeyboardNumType){
    PWKeyboardNumTypeAuto = 0,
//    PWKeyboardNumTypeCivil,
//    PWKeyboardNumTypeWuJing,
//    PWKeyboardNumTypeWuJingLocal,
//    PWKeyboardNumTypeArmy,
    PWKeyboardNumTypeNewEnergy = 5,
//    PWKeyboardNumTypeEmbassy,
//    PWKeyboardNumTypeEmbassyNew,
};

/**
 按键的类型
 
 - PWKeyboardButtonTypeOutput: 输出文字
 - PWKeyboardButtonTypeDelete: 删除文字
 - PWKeyboardButtonTypeDone: 确定
 */
typedef NS_ENUM(NSInteger,PWKeyboardButtonType){
    PWKeyboardButtonTypeOutput = 0,
    PWKeyboardButtonTypeDelete = 1,
    PWKeyboardButtonTypeDone = 2
};

@interface PWEnumeration : NSObject

@end
