//
//  UITextField+Extension.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func changeInputView() {
        self.inputView = PWKeyBoardView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}
