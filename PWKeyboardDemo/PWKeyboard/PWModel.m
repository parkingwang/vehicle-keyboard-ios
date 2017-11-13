//
//  PWModel.m
//  PlateKeyboard
//
//  Created by Zy.Feng on 2017/7/28.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "PWModel.h"
#import <objc/runtime.h>

@implementation PWModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"text":@"text",
                                                                 @"keyCode":@"keyCode",
                                                                 @"enabled":@"enabled",
                                                                 @"isFunKey":@"isFunKey",
                                                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation PWListModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"row0":@"row0",
                                                                 @"row1":@"row1",
                                                                 @"row2":@"row2",
                                                                 @"row3":@"row3",
                                                                 @"row4":@"row4",
                                                                 @"keys":@"keys",
                                                                 @"presetNumber":@"presetNumber",
                                                                 @"keyboardType":@"keyboardType",
                                                                 @"numberType":@"numberType",
                                                                 @"presetNumberType":@"presetNumberType",
                                                                 @"detectedNumberType":@"detectedNumberType",
                                                                 @"numberLength":@"numberLength",
                                                                 @"keyboardType":@"keyboardType",
                                                                 @"numberLimitLength":@"numberLimitLength"
                                                                 }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
