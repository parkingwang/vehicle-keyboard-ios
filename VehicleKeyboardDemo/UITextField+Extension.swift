//
//  UITextField+Extension.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import Foundation
import UIKit

extension UITextField :PWKeyBoardViewDeleagte{
    
    func changeInputView(){
        let keyboardView = PWKeyBoardView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        inputView = keyboardView
        keyboardView.delegate = self
    }
    
    func changeInputType(isNewEnergy:Bool){
        let keyboardView = self.inputView as! PWKeyBoardView
        keyboardView.numType = isNewEnergy ? .newEnergy : .auto
        refreshKeyboard(isMoreType:false)
    }
    
    func selectComplete(char:String,inputIndex:Int) {
        if !hasText {
            text = ""
        }
        if char != "删除" ,char != "确定" ,inputIndex == text!.count - 1 {
            text = Engine.subString(str: text!, start: 0, length: text!.count - 1)
        }
        var isMoreType = false
        if char == "删除" , text!.count >= 1 {
            text = Engine.subString(str: text!, start: 0, length: text!.count - 1)
        }else  if char == "确定"{
            endEditing(true)
        }else if char == "更多" {
            isMoreType = true
        } else if char == "返回" {
            isMoreType = false
        } else {
            text! += char
        }
        refreshKeyboard(isMoreType:isMoreType)
    }
    private func refreshKeyboard(isMoreType:Bool){
        //当输入框处于填满状态时，输入的下标往前移动一位数
        let keyboardView = inputView as! PWKeyBoardView
        let numType = keyboardView.numType == .newEnergy ? PWKeyboardNumType.newEnergy : Engine.detectNumberTypeOf(presetNumber: text!)
        let maxCount = (numType == .newEnergy || numType == .wuJing) ? 8 : 7
        let inpuntIndex = maxCount <= text!.count  ? (text!.count - 1) : text!.count
        keyboardView.updateText(text: text!,isMoreType:isMoreType,inputIndex:inpuntIndex)
    }
}
