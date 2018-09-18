//
//  KeyboardLayoutRegistrar.swift
//  VehicleKeyboard
//
//  Created by cjz on 2018/9/18.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

class KeyboardLayoutRegistrar: NSObject {
    
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
    
    
    //键位注册
//    func keyRegist(keyString: String, inputIndex: Int, layout: KeyboardLayout, numberType: PWKeyboardNumType) -> KeyboardLayout
    func register(layout: KeyboardLayout, keyString: String, inputIndex: Int, numberType: PWKeyboardNumType) -> KeyboardLayout {
        
        var list = layout
        var okString = ""
        if numberType == .newEnergy || numberType == .wuJing {
            okString = keyString.count == 8 ? _STR_OK : ""
        }else {
            okString = keyString.count == 7 ? _STR_OK : ""
        }
        let disOkString = okString == "" ? _STR_OK : ""
        switch inputIndex {
        case 0:
            if numberType == .newEnergy {
                list = KeyboardEngine.disabledKey(keyString: [_STR_MORE,disOkString,_CHAR_TAI], listModel: list,reverseModel:false)
            } else {
                list = KeyboardEngine.disabledKey(keyString: [disOkString,_CHAR_TAI], listModel: list,reverseModel:false)
            }
        case 1:
            if numberType == .wuJing {
                list = KeyboardEngine.disabledKey(keyString:[_CHAR_J,_CHAR_DEL,okString], listModel: list,reverseModel:true)
            } else if numberType == .embassy {
                let stringArray = _STR_NUM1_3.map({ (a) -> String in
                    return String(a)
                })
                list = KeyboardEngine.disabledKey(keyString:[_CHAR_DEL,okString] + stringArray, listModel: list,reverseModel:true)
            } else if numberType == .airport {
                list = KeyboardEngine.disabledKey(keyString:[_CHAR_HANG,_CHAR_DEL,okString], listModel: list,reverseModel:true)
            } else {
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM4_0 + _CHAR_I + disOkString), listModel: list,reverseModel:false)
            }
        case 2:
            if numberType == PWKeyboardNumType.newEnergy {
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + okString), listModel: list,reverseModel:true)
            }else if numberType == .wuJing {
                list = KeyboardEngine.disabledKey(keyString:[disOkString,_STR_MORE,_CHAR_TAI] ,listModel: list,reverseModel:false)
            } else if numberType == .embassy{
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + okString) ,listModel: list,reverseModel:true)
            } else {
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: list,reverseModel:false)
            }
        case 3:
            if numberType == .embassy{
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + okString) ,listModel: list,reverseModel:true)
            }else {
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: list,reverseModel:false)
            }
        case 4,5:
            list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: list,reverseModel:false)
        case 6:
            if keyString.subString(0, length: 2) == "粤Z" {
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_DEL + okString), listModel: list,reverseModel:true)
            }else if numberType == .embassy || numberType == .airport || numberType == .newEnergy{
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_MORE + disOkString), listModel: list,reverseModel:false)
            }else{
                list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_MACAO + _CHAR_HK +  disOkString + _CHAR_HANG + _CHAR_SHI), listModel: list,reverseModel:false)
            }
        case 7:
            let complete = keyString.count == 8 ? _STR_OK : ""
            list = KeyboardEngine.disabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + complete), listModel: list,reverseModel:true)
        default:
            break
        }
        return layout
    }
    
    func disEnabledKey(keyString: [String], listModel: KeyboardLayout,reverseModel:Bool) ->KeyboardLayout {
        let list = listModel
        list.row0 = KeyboardEngine.disableKey(keyString: keyString, row: list.row0!,reverseModel:reverseModel)
        list.row1 = KeyboardEngine.disableKey(keyString: keyString, row: list.row1!,reverseModel:reverseModel)
        list.row2 = KeyboardEngine.disableKey(keyString: keyString, row: list.row2!,reverseModel:reverseModel)
        list.row3 = KeyboardEngine.disableKey(keyString: keyString, row: list.row3!,reverseModel:reverseModel)
        return list
    }
    
    
    func disEnableKey(keyString: [String], row: Array<Key>, reverseModel: Bool) -> Array<Key> {
        for model in row {
            model.enabled = !reverseModel
            model.keyCode = 0
            for str in keyString {
                if model.text == str {
                    model.enabled = reverseModel
                }
            }
            if model.text == "+" {
                model.text = "确定"
                model.keyCode = 2
            } else if model.text == "-" {
                model.text = "删除"
                model.keyCode = 1
            } else if model.text == ">" {
                model.keyCode = 3
                model.text = "更多"
            } else if model.text == "<" {
                model.keyCode = 4
                model.text = "返回"
            }
        }
        return row
    }
    
    static func chStringArray(string: String) -> [String] {
        var strArray = Array<String>()
        for ch in string{
            strArray.append(String(ch))
        }
        return strArray
    }
}
