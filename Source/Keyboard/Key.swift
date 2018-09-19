//
//  Key.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. All rights reserved.
//

import UIKit

@objc public enum PlateNumberType: Int {
    case auto = 0,airport,wuJing,police,embassy,newEnergy,HK_MO;
}

class Key: NSObject {
    var text :String?
    var keyCode :Int?
    var enabled = false
    var isFunKey = false
}


