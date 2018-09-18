//
//  Engine.swift
//  PWKeyboardDemo
//
//  Created by 杨志豪 on 2018/3/26.
//  Copyright © 2018年 fzy. All rights reserved.
//

import UIKit

class KeyboardEngine: NSObject {
    
    static let _STR_CIVIL_PVS = "京津晋冀蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新台"
    static let _CHAR_DEL = "-"
    static let _STR_DEL_OK = _CHAR_DEL + "+"
    static let _STR_OK = "+"
    static let _STR_MORE = ">"
    static let _STR_BACK = "<"
    static let _STR_Q_OP = "QWERTYUIOP"
    static let _STR_Q_N = "QWERTYUPMN"
    static let _STR_Q_P = "QWERTYUP"
    static let _STR_A_L = "ASDFGHJKL"
    static let _STR_A_M = "ASDFGHJKLM"
    static let _STR_A_B = "ASDFGHJKLB"
    static let _STR_A_K = "ABCDEFGHJK"
    static let _STR_Z_V = "ZXCV"
    static let _STR_Z_N = "ZXCVBN"
    static let _STR_W_Z = "WXYZ"
    static let _CHAR_W = "W"
    static let _CHAR_I = "I"
    static let _CHAR_O = "O"
    static let _CHAR_J = "J"
    static let _STR_DF = "DF"
    static let _STR_ZX = "ZX"
    static let _STR_NUM = "1234567890"
    static let _STR_NUM1_3 = "123"
    static let _STR_NUM4_0 = "4567890"
    static let _CHAR_MACAO = "澳"
    static let _CHAR_HK = "港"
    static let _CHAR_TAI = "台"
    static let _CHAR_XUE = "学"
    static let _CHAR_MIN = "民"
    static let _CHAR_HANG = "航"
    static let _CHAR_SHI = "使"
    static let _CHAR_SPECIAL = "学警港澳航挂试超使领"
    static let _STR_HK_MACAO = _CHAR_HK + _CHAR_MACAO;
    
    class func generateLayout(at inputIndex: Int,
                              plateNumber: String,
                              numberType: PWKeyboardNumType,
                              isMoreType: Bool) -> KeyboardLayout {
        var detectedNumberType = numberType
        if  numberType == PWKeyboardNumType.auto {
           detectedNumberType = KeyboardEngine.plateNumberType(with: plateNumber)
        }
        
        //获取键位布局
        var layoutLout = KeyboardLayoutFactory().keyboardLayout(inputIndex: inputIndex, plateNumber: plateNumber, isMoreType: isMoreType)

        layoutLout = KeyboardLayoutRegistrar().register(layout: layoutLout, keyString: plateNumber, inputIndex: inputIndex, numberType: detectedNumberType)
        
    
        layoutLout.presetNumber = plateNumber
        layoutLout.index = inputIndex
        
        var keysArray = layoutLout.row1! + layoutLout.row0!
        keysArray += layoutLout.row2!
        keysArray += layoutLout.row3!
        layoutLout.keys = keysArray
        
        return layoutLout
    }    
    
    static func plateNumberType(with presetNumber: String) -> PWKeyboardNumType {
        if presetNumber.count >= 1 {
            let subString = presetNumber.subString(0, length: 1)
            if subString == _CHAR_W {
                return .wuJing
            } else if subString == _CHAR_MIN {
                return .airport
            } else if subString == _CHAR_SHI {
                return .embassy
            }
        }
        
        if presetNumber.starts(with: "粤Z") {
            return .HK_MO
        }
        

        if presetNumber.count == 8 {
            return .newEnergy
        }
        
        return .auto
    }
}


