//
//  Device.swift
//  VehicleKeyboard
//
//  Created by cjz on 2018/9/18.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

class Device: NSObject {
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static func isIphoneX() -> Bool {
        return (CGSize.init(width: 375, height: 812) == UIScreen.main.bounds.size)
    }
}
