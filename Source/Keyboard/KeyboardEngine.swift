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
    
    class func generateLayout(keyboardType: PWKeyboardType,
                              inputIndex: Int,
                              presetNumber: String,
                              numberType: PWKeyboardNumType,
                              isMoreType: Bool) -> KeyboardLayout {
        
        var detectedNumberType = numberType
        if  numberType == PWKeyboardNumType.auto {
           detectedNumberType = KeyboardEngine.detectNumberTypeOf(presetNumber: presetNumber)
        }
        
        //获取键位布局
        var layoutLout = KeyboardEngine.getKeyProvider(inputIndex: inputIndex, presetNumber: presetNumber,isMoreType:isMoreType)
        
        //注册键位
        layoutLout = KeyboardEngine.keyRegist(keyString: presetNumber, inputIndex: inputIndex, listModel: layoutLout, numberType: detectedNumberType)
    
        layoutLout.presetNumber = presetNumber
        layoutLout.numberType = numberType
        layoutLout.index = inputIndex
        layoutLout.keyboardType = keyboardType
        
        var keysArray = layoutLout.row1! + layoutLout.row0!
        keysArray += layoutLout.row2!
        keysArray += layoutLout.row3!
        layoutLout.keys = keysArray
        
        return layoutLout
    }
    
    //键位布局
    static func getKeyProvider(inputIndex: Int ,presetNumber: String, isMoreType: Bool) -> KeyboardLayout{
        var layout = KeyboardLayout()
        switch inputIndex {
        case 0:
            if !isMoreType {
                layout = KeyboardEngine.defaultProvinces()
            } else {
                layout.row0 = KeyboardEngine.getModelArrayWithString(keyString: _STR_NUM)
                layout.row1 = KeyboardEngine.getModelArrayWithString(keyString:_STR_Q_N)
                layout.row2 = KeyboardEngine.getModelArrayWithString(keyString:_STR_A_L)
                layout.row3 = KeyboardEngine.getModelArrayWithString(keyString:_STR_ZX + _CHAR_MIN + _CHAR_SHI + _STR_BACK + _STR_DEL_OK)
            }
            
        case 1:
            if KeyboardEngine.subString(str: presetNumber, start: 0, length: 1) == _CHAR_MIN {
                layout = KeyboardEngine.defaultSpecial()
            } else {
                layout = KeyboardEngine.defaultNumbersAndLetters()
            }
        case 2, 3, 4, 5:
            if inputIndex == 2 && KeyboardEngine.subString(str: presetNumber, start: 0, length: 2) == (_CHAR_W + _CHAR_J) {
                layout = KeyboardEngine.defaultProvinces()
            } else {
                layout = KeyboardEngine.defaultNumbersAndLetters()
            }
        case 6:
            if !isMoreType {
                layout = KeyboardEngine.defaultLast()
            } else {
                layout = KeyboardEngine.defaultSpecial()
            }
        case 7:
            layout = KeyboardEngine.defaultLast()
            
        default: break
        }
        return layout
    }
    
    //键位注册
    static func keyRegist(keyString:String , inputIndex: Int , listModel: KeyboardLayout ,numberType :PWKeyboardNumType) -> KeyboardLayout {
        var list = listModel
        var okString = ""
        if numberType == .newEnergy || numberType == .wuJing {
            okString = keyString.count == 8 ? _STR_OK : ""
        }else {
            okString = keyString.count == 7 ? _STR_OK : ""
        }
        let disOkString = okString == "" ? _STR_OK : ""
        switch inputIndex {
        case 0:
            if numberType == PWKeyboardNumType.newEnergy {
                list = KeyboardEngine.disEnabledKey(keyString: [_STR_MORE,disOkString,_CHAR_TAI], listModel: list,reverseModel:false)
            } else {
                list = KeyboardEngine.disEnabledKey(keyString: [disOkString,_CHAR_TAI], listModel: list,reverseModel:false)
            }
        case 1:
            if numberType == .wuJing {
                list = KeyboardEngine.disEnabledKey(keyString:[_CHAR_J,_CHAR_DEL,okString], listModel: list,reverseModel:true)
            } else if numberType == .embassy {
                let stringArray = _STR_NUM1_3.map({ (a) -> String in
                    return String(a)
                })
                list = KeyboardEngine.disEnabledKey(keyString:[_CHAR_DEL,okString] + stringArray, listModel: list,reverseModel:true)
            } else if numberType == .airport {
                list = KeyboardEngine.disEnabledKey(keyString:[_CHAR_HANG,_CHAR_DEL,okString], listModel: list,reverseModel:true)
            } else {
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM4_0 + _CHAR_I + disOkString), listModel: list,reverseModel:false)
            }
        case 2:
            if numberType == PWKeyboardNumType.newEnergy {
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + okString), listModel: list,reverseModel:true)
            }else if numberType == .wuJing {
                list = KeyboardEngine.disEnabledKey(keyString:[disOkString,_STR_MORE,_CHAR_TAI] ,listModel: list,reverseModel:false)
            } else if numberType == .embassy{
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + okString) ,listModel: list,reverseModel:true)
            } else {
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: list,reverseModel:false)
            }
        case 3:
            if numberType == .embassy{
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + okString) ,listModel: list,reverseModel:true)
            }else {
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: list,reverseModel:false)
            }
        case 4,5:
            list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_I + _CHAR_O + disOkString) ,listModel: list,reverseModel:false)
        case 6:
            if KeyboardEngine.subString(str: keyString, start: 0, length: 2) == "粤Z" {
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_DEL + okString + _STR_MORE), listModel: list,reverseModel:true)
            }else if numberType == .embassy || numberType == .airport || numberType == .newEnergy{
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_MORE + disOkString), listModel: list,reverseModel:false)
            }else{
                list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _CHAR_MACAO + _CHAR_HK +  disOkString + _CHAR_HANG + _CHAR_SHI), listModel: list,reverseModel:false)
            }
        case 7:
             let complete = keyString.count == 8 ? _STR_OK : ""
            list = KeyboardEngine.disEnabledKey(keyString:KeyboardEngine.chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + complete), listModel: list,reverseModel:true)
        default:break
        }
        return listModel
    }
    
    static func getModelArrayWithString(keyString :String) -> Array<Key> {
        var modelArray = Array<Key>()
        for ch in keyString{
            let model = Key()
            model.enabled = true
            model.text = String(ch)
            modelArray.append(model)
        }
        return modelArray
    }
    
    static func defaultNumbersAndLetters() ->KeyboardLayout{
        let listModel = KeyboardLayout()
        listModel.row0 = KeyboardEngine.getModelArrayWithString(keyString: _STR_NUM)
        listModel.row1 = KeyboardEngine.getModelArrayWithString(keyString:_STR_Q_OP)
        listModel.row2 = KeyboardEngine.getModelArrayWithString(keyString:_STR_A_M)
        listModel.row3 = KeyboardEngine.getModelArrayWithString(keyString:_STR_Z_N + _STR_DEL_OK)
        return listModel
    }
    
    static func defaultSpecial() ->KeyboardLayout{
        let listModel = KeyboardLayout()
        listModel.row0 = KeyboardEngine.getModelArrayWithString(keyString: _CHAR_SPECIAL)
        listModel.row1 = KeyboardEngine.getModelArrayWithString(keyString:_STR_NUM)
        listModel.row2 = KeyboardEngine.getModelArrayWithString(keyString:_STR_A_K)
        listModel.row3 = KeyboardEngine.getModelArrayWithString(keyString:_STR_W_Z + _STR_BACK + _STR_DEL_OK)
        return listModel
    }
    
    static func defaultLast() -> KeyboardLayout{
        let listModel = KeyboardLayout()
        listModel.row0 = KeyboardEngine.getModelArrayWithString(keyString: _STR_NUM)
        listModel.row1 = KeyboardEngine.getModelArrayWithString(keyString:_STR_Q_N)
        listModel.row2 = KeyboardEngine.getModelArrayWithString(keyString:_STR_A_B)
        listModel.row3 = KeyboardEngine.getModelArrayWithString(keyString:_STR_Z_V + _STR_MORE + _STR_DEL_OK)
        return listModel
    }
    
    static func defaultProvinces() ->KeyboardLayout{
        let listModel = KeyboardLayout()
        listModel.row0 = KeyboardEngine.getModelArrayWithString(keyString:KeyboardEngine.subString(str: _STR_CIVIL_PVS, start: 0, length: 10))
        listModel.row1 = KeyboardEngine.getModelArrayWithString(keyString:KeyboardEngine.subString(str: _STR_CIVIL_PVS, start: 10, length: 10))
        listModel.row2 = KeyboardEngine.getModelArrayWithString(keyString:KeyboardEngine.subString(str: _STR_CIVIL_PVS, start: 20, length: 8))
        listModel.row3 = KeyboardEngine.getModelArrayWithString(keyString:KeyboardEngine.subString(str: _STR_CIVIL_PVS, start: 28, length: 4) + _STR_MORE  + _STR_DEL_OK)
        return listModel
    }
    
    static func disEnabledKey(keyString: [String], listModel: KeyboardLayout,reverseModel:Bool) ->KeyboardLayout {
        let list = listModel
        list.row0 = KeyboardEngine.disEnableKey(keyString: keyString, row: list.row0!,reverseModel:reverseModel)
        list.row1 = KeyboardEngine.disEnableKey(keyString: keyString, row: list.row1!,reverseModel:reverseModel)
        list.row2 = KeyboardEngine.disEnableKey(keyString: keyString, row: list.row2!,reverseModel:reverseModel)
        list.row3 = KeyboardEngine.disEnableKey(keyString: keyString, row: list.row3!,reverseModel:reverseModel)
        return list
    }
    
    
    
    static func disEnableKey(keyString: [String], row: Array<Key>, reverseModel: Bool) -> Array<Key> {
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
    
    static func detectNumberTypeOf(presetNumber: String) -> PWKeyboardNumType {
        if presetNumber.count >= 1 {
            if KeyboardEngine.subString(str: presetNumber, start: 0, length: 1) == _CHAR_W{
                return .wuJing
            } else if KeyboardEngine.subString(str: presetNumber, start: 0, length: 1) == _CHAR_MIN {
                return .airport
            } else if KeyboardEngine.subString(str: presetNumber, start: 0, length: 1) == _CHAR_SHI {
                return .embassy
            }
        }
        if presetNumber.count == 8 {
            return PWKeyboardNumType.newEnergy
        }
        return PWKeyboardNumType.auto
    }
    
    static func subString(str: String, start: Int ,length: Int) -> String {
        if length == 0 {
            return ""
        }
        let startIndex = str.index(str.startIndex, offsetBy:start)
        let endIndex = str.index(startIndex, offsetBy:length)
        return str.substring(with: startIndex..<endIndex)
    }
}


