//
//  PWModel.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

enum PWKeyboardType: Int{
    case full = 0,civil,civilAndArmy;
}

enum PWKeyboardNumType: Int {
    case auto = 0,civil,wuJing,wuJingLocal,army,newEnergy;
}

enum PWKeyboardButtonType: Int {
    case output = 0,delete,done;
}

class PWModel: NSObject {
    var text :String?
    var keyCode :Int?
    var enabled = false
    var isFunKey = false
}

class PWListModel: NSObject {
    var row0 :Array<PWModel>?
    var row1 :Array<PWModel>?
    var row2 :Array<PWModel>?
    var row3 :Array<PWModel>?
    var keys :Array<PWModel>?
    
    //index 当前键盘所处的键盘类型；
    var index = 0
    //presetNumber 当前预设的车牌号码；
    var presetNumber :String?
    //keyboardType 当前键盘所处的键盘类型；
    var keyboardType :PWKeyboardType?
    //numberType 当前预设的车牌号码类型（废弃参数）；
    var numberType :PWKeyboardNumType?
    //presetNumberType 同numberType；
    var presetNumberType :PWKeyboardNumType?
    //detectedNumberType 检测当前输入车牌号码的号码类型；
    var detectedNumberType :PWKeyboardNumType?
    //numberLength 当前预设的车牌号码长度；
    var numberLength :Int?
    //numberLimitLength 当前车牌号码的最大长度；
    var numberLimitLength :Int?
    
    func rowArray() -> [[PWModel]] {
        return [self.row0!,self.row1!,self.row2!,self.row3!]
    }
}
