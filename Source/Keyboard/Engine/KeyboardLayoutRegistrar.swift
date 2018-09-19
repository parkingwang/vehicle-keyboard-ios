//
//  KeyboardLayoutRegistrar.swift
//  VehicleKeyboard
//
//  Created by cjz on 2018/9/18.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

class KeyboardLayoutRegistrar: NSObject {
    
    private let _CHAR_DEL = "-"
    private let _STR_OK = "+"
    private let _STR_MORE = ">"
    private let _CHAR_I = "I"
    private let _CHAR_O = "O"
    private let _CHAR_J = "J"
    private let _STR_DF = "DF"
    private let _STR_NUM = "1234567890"
    private let _STR_NUM1_3 = "123"
    private let _STR_NUM4_0 = "4567890"
    private let _CHAR_MACAO = "澳"
    private let _CHAR_HK = "港"
    private let _CHAR_TAI = "台"
    private let _CHAR_HANG = "航"
    private let _CHAR_SHI = "使"
    
    /// 车牌键盘键位注册，把布局里面不符合规则的键禁用
    ///
    /// - Parameters:
    ///   - layout: 车牌键盘布局
    ///   - keyString: 正在输入的车牌
    ///   - inputIndex: 光标所在位置
    ///   - numberType: 车牌类型
    /// - Returns: 注册完成的布局
    func register(layout: KeyboardLayout, keyString: String, inputIndex: Int, numberType: PlateNumberType) -> KeyboardLayout {
        
        var mLayout = layout
        var okString = ""
        
        if numberType == .newEnergy || numberType == .wuJing {
            okString = keyString.count == 8 ? _STR_OK : ""
        } else {
            okString = keyString.count == 7 ? _STR_OK : ""
        }
        let disOkString = okString == "" ? _STR_OK : ""
        
        switch inputIndex {
        case 0:
            if numberType == .newEnergy {
                mLayout = disabledKey(keyString: [_STR_MORE,disOkString,_CHAR_TAI], listModel: mLayout,reverseModel:false)
            } else {
                mLayout = disabledKey(keyString: [disOkString,_CHAR_TAI], listModel: mLayout,reverseModel:false)
            }
        case 1:
            if numberType == .wuJing {
                mLayout = disabledKey(keyString:[_CHAR_J,_CHAR_DEL,okString], listModel: mLayout,reverseModel:true)
            } else if numberType == .embassy {
                let stringArray = _STR_NUM1_3.map({ (a) -> String in
                    return String(a)
                })
                mLayout = disabledKey(keyString:[_CHAR_DEL,okString] + stringArray, listModel: mLayout,reverseModel:true)
            } else if numberType == .airport {
                mLayout = disabledKey(keyString:[_CHAR_HANG,_CHAR_DEL,okString], listModel: mLayout,reverseModel:true)
            } else {
                mLayout = disabledKey(keyString:chStringArray(string: _STR_NUM4_0 + _CHAR_I + disOkString), listModel: mLayout,reverseModel:false)
            }
        case 2:
            if numberType == .newEnergy {
                mLayout = disabledKey(keyString:chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + okString), listModel: mLayout,reverseModel:true)
            }else if numberType == .wuJing {
                mLayout = disabledKey(keyString:[disOkString,_STR_MORE,_CHAR_TAI] ,listModel: mLayout,reverseModel:false)
            } else if numberType == .embassy{
                mLayout = disabledKey(keyString:chStringArray(string: _STR_NUM + _CHAR_DEL + okString) ,listModel: mLayout,reverseModel:true)
            } else {
                mLayout = disabledKey(keyString:chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: mLayout,reverseModel:false)
            }
        case 3:
            if numberType == .embassy {
                mLayout = disabledKey(keyString:chStringArray(string: _STR_NUM + _CHAR_DEL + okString) ,listModel: mLayout,reverseModel:true)
            } else {
                mLayout = disabledKey(keyString:chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: mLayout,reverseModel:false)
            }
        case 4,5:
            mLayout = disabledKey(keyString:chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: mLayout,reverseModel:false)
        case 6:
            if numberType == .HK_MO {
                mLayout = disabledKey(keyString:chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_DEL + okString), listModel: mLayout,reverseModel:true)
            } else if numberType == .embassy || numberType == .airport || numberType == .newEnergy{
                mLayout = disabledKey(keyString:chStringArray(string: _STR_MORE + disOkString), listModel: mLayout,reverseModel:false)
            } else {
                mLayout = disabledKey(keyString:chStringArray(string: _CHAR_MACAO + _CHAR_HK +  disOkString + _CHAR_HANG + _CHAR_SHI), listModel: mLayout,reverseModel:false)
            }
        case 7:
            let complete = keyString.count == 8 ? _STR_OK : ""
            mLayout = disabledKey(keyString:chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + complete), listModel: mLayout,reverseModel:true)
        default:
            break
        }
        return layout
    }
    
    private func disabledKey(keyString: [String], listModel: KeyboardLayout, reverseModel:Bool) -> KeyboardLayout {
        let list = listModel
        list.row0 = disableKey(keyString: keyString, row: list.row0!,reverseModel:reverseModel)
        list.row1 = disableKey(keyString: keyString, row: list.row1!,reverseModel:reverseModel)
        list.row2 = disableKey(keyString: keyString, row: list.row2!,reverseModel:reverseModel)
        list.row3 = disableKey(keyString: keyString, row: list.row3!,reverseModel:reverseModel)
        return list
    }
    
    
    private func disableKey(keyString: [String], row: [Key], reverseModel: Bool) -> [Key] {
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
    
    private func chStringArray(string: String) -> [String] {
        return string.map({ (char) -> String in
            return String(char)
        })
    }
}
