//
//  Engine.swift
//  PWKeyboardDemo
//
//  Created by 杨志豪 on 2018/3/26.
//  Copyright © 2018年 fzy. All rights reserved.
//

import UIKit

class Engine: NSObject {
    
    static let _STR_CIVIL_PVS = "京津晋冀蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新";
    static let _CHAR_DEL = "-"
    static let _STR_DEL_OK = _CHAR_DEL + "+"
    static let _STR_OK = "+"
    static let _STR_Q_OP = "QWERTYUOP";
    static let _STR_Q_P = "QWERTYUP";
    static let _STR_A_L = "ASDFGHJKL";
    static let _STR_A_L_WITHOUT_J = "ASDFGHKL";
    static let _STR_Z_M = "ZXCVBNM";
    static let _CHAR_W = "W";
    static let _CHAR_J = "J";
    static let _STR_DF = "DF";
    static let _STR_NUM = "1234567890"
    static let _CHAR_MACAO = "澳"
    static let _CHAR_HK = "港";
    static let _CHAR_XUE = "学"
    static let _STR_HK_MACAO = _CHAR_HK + _CHAR_MACAO;
    
    class func update(keyboardType: PWKeyboardType ,inputIndex: Int,presetNumber: String,numberType: PWKeyboardNumType) -> PWListModel {
        var detectedNumberType = numberType
        if  numberType == PWKeyboardNumType.auto{
           detectedNumberType = Engine.detectNumberTypeOf(presetNumber: presetNumber)
        }
        //获取键位布局
        var listModel = Engine.getKeyProvider(inputIndex: inputIndex, presetNumber: presetNumber)
        //注册键位
        listModel = Engine.keyRegist(keyString: presetNumber, inputIndex: inputIndex, listModel: listModel, numberType: detectedNumberType)
    
        listModel.presetNumber = presetNumber
        listModel.numberType = numberType
        listModel.index = inputIndex
        listModel.keyboardType = keyboardType
        var keysArray = listModel.row1! + listModel.row0!
        keysArray += listModel.row2!
        keysArray += listModel.row3!
        listModel.keys = keysArray
        return listModel
    }
    
    //键位布局
    static func getKeyProvider(inputIndex: Int ,presetNumber: String) -> PWListModel{
        let listModel = PWListModel()
        switch inputIndex {
        case 0:
            listModel.row0 = Engine.getModelArrayWithString(keyString:Engine.subString(str: _STR_CIVIL_PVS, start: 0, length: 9))
            listModel.row1 = Engine.getModelArrayWithString(keyString:Engine.subString(str: _STR_CIVIL_PVS, start: 9, length: 9))
            listModel.row2 = Engine.getModelArrayWithString(keyString:Engine.subString(str: _STR_CIVIL_PVS, start: 18, length: 8))
            listModel.row3 = Engine.getModelArrayWithString(keyString:Engine.subString(str: _STR_CIVIL_PVS, start: 26, length: 5) + _CHAR_W + _STR_DEL_OK)
        case 1:
            listModel.row0 = Engine.getModelArrayWithString(keyString: _STR_NUM)
            listModel.row1 = Engine.getModelArrayWithString(keyString:_STR_Q_OP + _CHAR_MACAO)
            listModel.row2 = Engine.getModelArrayWithString(keyString:_STR_A_L + _CHAR_HK)
            listModel.row3 = Engine.getModelArrayWithString(keyString:_STR_Z_M + _STR_DEL_OK)
        case 2, 3, 4, 5, 6, 7:
            if inputIndex == 2 && Engine.subString(str: presetNumber, start: 0, length: 2) == (_CHAR_W + _CHAR_J) {
                listModel.row0 = Engine.getModelArrayWithString(keyString: _STR_NUM + Engine.subString(str:_STR_CIVIL_PVS, start: 0, length: 1))
                listModel.row1 = Engine.getModelArrayWithString(keyString: Engine.subString(str:_STR_CIVIL_PVS, start: 1, length: 11))
                listModel.row2 = Engine.getModelArrayWithString(keyString: Engine.subString(str:_STR_CIVIL_PVS, start: 12, length: 11))
                listModel.row3 = Engine.getModelArrayWithString(keyString: Engine.subString(str:_STR_CIVIL_PVS, start: 22, length: 8) + _STR_DEL_OK)
            } else {
                listModel.row0 = Engine.getModelArrayWithString(keyString: _STR_NUM)
                listModel.row1 = Engine.getModelArrayWithString(keyString:_STR_Q_P + _STR_HK_MACAO)
                listModel.row2 = Engine.getModelArrayWithString(keyString:_STR_A_L + _CHAR_XUE)
                listModel.row3 = Engine.getModelArrayWithString(keyString:_STR_Z_M + _STR_DEL_OK)
            }
           
        default: break
        }
        return listModel
    }
    
    //键位注册
    static func keyRegist(keyString:String , inputIndex: Int , listModel: PWListModel ,numberType :PWKeyboardNumType) -> PWListModel {
        var list = listModel;
        switch inputIndex {
        case 0:
            if numberType == PWKeyboardNumType.newEnergy {
                list = Engine.disEnabledKey(keyString: [_CHAR_W,_STR_OK], listModel: list,reverseModel:false)
            }else {
                list = Engine.disEnabledKey(keyString: [_STR_OK], listModel: list,reverseModel:false)
            }
        case 1:
            if Engine.subString(str: keyString, start: 0, length: 1) == _CHAR_W {
                list = Engine.disEnabledKey(keyString:[_CHAR_J,_CHAR_DEL], listModel: list,reverseModel:true)
            }else {
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _STR_NUM + _CHAR_MACAO + _CHAR_HK + _STR_OK), listModel: list,reverseModel:false)
            }
        case 2:
            if numberType == PWKeyboardNumType.newEnergy {
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF), listModel: list,reverseModel:true)
            }else if Engine.subString(str: keyString, start: 0, length: 2) == (_CHAR_W + _CHAR_J) {
                list = Engine.disEnabledKey(keyString:[_STR_OK] ,listModel: list,reverseModel:false)
            }else {
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_XUE + _STR_OK) ,listModel: list,reverseModel:false)
            }
        case 3:
            list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_XUE + _STR_OK) ,listModel: list,reverseModel:false)
        case 4,5:
            if numberType == PWKeyboardNumType.newEnergy {
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _STR_NUM + _CHAR_DEL), listModel: list,reverseModel:true)
            }else {
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_XUE + _STR_OK) ,listModel: list,reverseModel:false)
            }
        case 6:
            if Engine.subString(str: keyString, start: 0, length: 2) == "粤Z" {
                //粤z尾号特殊处理
                let complete = keyString.count == 7 ? _STR_OK : ""
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _CHAR_MACAO + _CHAR_HK + _CHAR_DEL + complete), listModel: list,reverseModel:true)
            }else {
                let complete = keyString.count == 7 ? "" : _STR_OK
                let needXUE = Engine.subString(str: keyString, start: 0, length: 1) == _CHAR_W ? _CHAR_XUE : ""
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _CHAR_MACAO + _CHAR_HK +  complete + needXUE), listModel: list,reverseModel:false)
            }
            //新能源优先级比其他高
            if numberType == PWKeyboardNumType.newEnergy {
                list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _STR_NUM + _CHAR_DEL), listModel: list,reverseModel:true)
            }
        case 7:
             let complete = keyString.count == 8 ? _STR_OK : ""
            list = Engine.disEnabledKey(keyString:Engine.chStringArray(string: _STR_NUM + _CHAR_DEL + _STR_DF + complete), listModel: list,reverseModel:true)
        default:break
        }
        return listModel
    }
    
    static func getModelArrayWithString(keyString :String) -> Array<PWModel> {
        var modelArray = Array<PWModel>()
        for ch in keyString{
            let model = PWModel()
            model.enabled = true
            model.text = String(ch)
            modelArray.append(model)
        }
        return modelArray
    }
    
    static func disEnabledKey(keyString: [String], listModel: PWListModel,reverseModel:Bool) ->PWListModel {
        let list = listModel
        list.row0 = Engine.disEnableKey(keyString: keyString, row: list.row0!,reverseModel:reverseModel)
        list.row1 = Engine.disEnableKey(keyString: keyString, row: list.row1!,reverseModel:reverseModel)
        list.row2 = Engine.disEnableKey(keyString: keyString, row: list.row2!,reverseModel:reverseModel)
        list.row3 = Engine.disEnableKey(keyString: keyString, row: list.row3!,reverseModel:reverseModel)
        return list
    }
    
    static func disEnableKey(keyString: [String],row:Array<PWModel>,reverseModel:Bool) -> Array<PWModel> {
        for model in row {
             model.enabled = !reverseModel
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
        if presetNumber.count == 8 {
            return PWKeyboardNumType.newEnergy
        }
        return PWKeyboardNumType.auto
    }
    
    static func subString(str: String, start: Int ,length: Int) -> String {
        let startIndex = str.index(str.startIndex, offsetBy:start)
        let endIndex = str.index(startIndex, offsetBy:length)
        return str.substring(with: startIndex..<endIndex)
    }
}


