//
//  KeyboardLayoutFactory.swift
//  VehicleKeyboard
//
//  Created by cjz on 2018/9/17.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

class KeyboardLayoutFactory: NSObject {
    
    let _STR_CIVIL_PVS = "京津晋冀蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新台"
    let _CHAR_DEL = "-"
    let _STR_OK = "+"
    let _STR_MORE = ">"
    let _STR_BACK = "<"
    let _STR_Q_OP = "QWERTYUIOP"
    let _STR_Q_N = "QWERTYUPMN"
    let _STR_Q_P = "QWERTYUP"
    let _STR_A_L = "ASDFGHJKL"
    let _STR_A_M = "ASDFGHJKLM"
    let _STR_A_B = "ASDFGHJKLB"
    let _STR_A_K = "ABCDEFGHJK"
    let _STR_Z_V = "ZXCV"
    let _STR_Z_N = "ZXCVBN"
    let _STR_W_Z = "WXYZ"
    let _CHAR_W = "W"
    let _CHAR_I = "I"
    let _CHAR_O = "O"
    let _CHAR_J = "J"
    let _STR_DF = "DF"
    let _STR_ZX = "ZX"
    let _STR_NUM = "1234567890"
    let _STR_NUM1_3 = "123"
    let _STR_NUM4_0 = "4567890"
    let _CHAR_MACAO = "澳"
    let _CHAR_HK = "港"
    let _CHAR_TAI = "台"
    let _CHAR_XUE = "学"
    let _CHAR_MIN = "民"
    let _CHAR_HANG = "航"
    let _CHAR_SHI = "使"
    let _CHAR_SPECIAL = "学警港澳航挂试超使领"
    
    //键位布局
    func keyboardLayout(inputIndex: Int ,plateNumber: String, isMoreType: Bool) -> KeyboardLayout {
        let plateNumberType = KeyboardEngine.plateNumberType(with: plateNumber)
        var layout = KeyboardLayout()
        switch inputIndex {
        case 0:
            if !isMoreType {
                layout = provinceLayout()
            } else {
                layout = firstSpecialCharLayout()
            }
            
        case 1:
            if plateNumberType == .airport {
                layout = specialCharLayout()
            } else {
                layout = numbersAndLettersLayout()
            }
        case 2, 3, 4, 5:
            if inputIndex == 2 && plateNumberType == .wuJing {
                layout = provinceLayout()
            } else {
                layout = numbersAndLettersLayout()
            }
        case 6:
            if !isMoreType && plateNumberType != .HK_MO {
                layout = lastCharLayout()
            } else {
                layout = specialCharLayout()
            }
        case 7:
            layout = lastCharLayout()
            
        default: break
        }
        return layout
    }
    
    private func firstSpecialCharLayout() -> KeyboardLayout {
        return LayoutGenerator.generateLayout(row0: _STR_NUM,
                                              row1: _STR_Q_N,
                                              row2: _STR_A_L,
                                              row3: _STR_ZX + _CHAR_MIN + _CHAR_SHI + _STR_BACK + _CHAR_DEL + _STR_OK)
    }
    
    private func numbersAndLettersLayout() -> KeyboardLayout {
        return LayoutGenerator.generateLayout(row0: _STR_NUM,
                                              row1: _STR_Q_OP,
                                              row2: _STR_A_M,
                                              row3: _STR_Z_N + _CHAR_DEL + _STR_OK)
    }
    
    private func specialCharLayout() ->KeyboardLayout {
        return LayoutGenerator.generateLayout(row0: _CHAR_SPECIAL,
                                              row1: _STR_NUM,
                                              row2: _STR_A_K,
                                              row3: _STR_W_Z + _STR_BACK + _CHAR_DEL + _STR_OK)
    }
    
    private func lastCharLayout() -> KeyboardLayout {
        return LayoutGenerator.generateLayout(row0: _STR_NUM,
                                              row1: _STR_Q_N,
                                              row2: _STR_A_B,
                                              row3: _STR_Z_V + _STR_MORE + _CHAR_DEL + _STR_OK)
    }
    
    private func provinceLayout() -> KeyboardLayout {
        return LayoutGenerator.generateLayout(row0: _STR_CIVIL_PVS.subString(0, length: 10),
                                              row1: _STR_CIVIL_PVS.subString(10, length: 10),
                                              row2: _STR_CIVIL_PVS.subString(20, length: 8),
                                              row3: _STR_CIVIL_PVS.subString(28, length: 4) + _STR_MORE  + _CHAR_DEL + _STR_OK)
    }
}

class LayoutGenerator {
    
    static func generateLayout(row0: String, row1: String, row2: String, row3: String) -> KeyboardLayout {
        let layout = KeyboardLayout()
        layout.row0 = createRow(keyString: row0)
        layout.row1 = createRow(keyString: row1)
        layout.row2 = createRow(keyString: row2)
        layout.row3 = createRow(keyString: row3)
        return layout
    }
    
    private static func createRow(keyString :String) -> [Key] {
        var modelArray = Array<Key>()
        for ch in keyString{
            let model = Key()
            model.enabled = true
            model.text = String(ch)
            modelArray.append(model)
        }
        return modelArray
    }
}
