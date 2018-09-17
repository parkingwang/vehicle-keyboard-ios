//
//  String+SubString.swift
//  VehicleKeyboard
//
//  Created by cjz on 2018/9/17.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

extension String {
    
    public func subString(_ start: Int ,length: Int) -> String {
        if length == 0 {
            return ""
        }
        let sIndex = index(self.startIndex, offsetBy:start)
        let eIndex = index(sIndex, offsetBy:length)
        return String(self[sIndex...eIndex])
    }
}

