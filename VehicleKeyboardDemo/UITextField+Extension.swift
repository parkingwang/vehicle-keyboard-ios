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
    
    func selectComplete(char: String) {
        if !hasText {
            text = ""
        }
        if char == "删除" , text!.count >= 1 {
            text = Engine.subString(str: text!, start: 0, length: text!.count - 1)
        }else  if char == "确定"{
            endEditing(true)
        }else {
            text! += char
        }
        let keyboardView = inputView as! PWKeyBoardView
        keyboardView.updateText(text: text!)
        
    }
}
