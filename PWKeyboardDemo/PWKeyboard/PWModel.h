//
//  PWModel.h
//  PlateKeyboard
//
//  Created by Zy.Feng on 2017/7/28.
//  Copyright © 2017年 fzy. All rights reserved.
//


#if __has_include(<JSONModel/JSONModel.h>)
#import <JSONModel/JSONModel.h>
#else
#import "JSONModelLib.h"
#endif

#import "PWEnumeration.h"

@protocol PWModel <NSObject> @end

@interface PWModel : JSONModel

@property (copy, nonatomic) NSString * text;
@property (assign, nonatomic) NSInteger keyCode;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL isFunKey;

@end

@interface PWListModel : JSONModel

//row0 - row4 键盘中每一行的键位数组；
@property (copy, nonatomic) NSArray<PWModel> * row0;
@property (copy, nonatomic) NSArray<PWModel> * row1;
@property (copy, nonatomic) NSArray<PWModel> * row2;
@property (copy, nonatomic) NSArray<PWModel> * row3;
@property (copy, nonatomic) NSArray<PWModel> * row4;

@property (copy, nonatomic) NSArray<PWModel> * keys;

//index 当前键盘所处的键盘类型；
@property (assign, nonatomic) NSInteger index;
//presetNumber 当前预设的车牌号码；
@property (copy, nonatomic) NSString * presetNumber;
//keyboardType 当前键盘所处的键盘类型；
@property (assign, nonatomic) PWKeyboardType keyboardType;
//numberType 当前预设的车牌号码类型（废弃参数）；
@property (assign, nonatomic) PWKeyboardNumType numberType;
//presetNumberType 同numberType；
@property (assign, nonatomic) PWKeyboardNumType presetNumberType;
//detectedNumberType 检测当前输入车牌号码的号码类型；
@property (assign, nonatomic) PWKeyboardNumType detectedNumberType;
//numberLength 当前预设的车牌号码长度；
@property (assign, nonatomic) NSInteger numberLength;
//numberLimitLength 当前车牌号码的最大长度；
@property (assign, nonatomic) NSInteger numberLimitLength;

@end
