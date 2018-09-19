//
//  PlateNumberInputViewDelegate.swift
//  VehicleKeyboard
//
//  Created by cjz on 2018/9/19.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

@objc(PWPlateNumberInputViewDelegate)
public protocol PlateNumberInputViewDelegate: NSObjectProtocol {
    @objc  func plateInputComplete(plate: String)
    @objc  optional func palteDidChnage(plate:String,complete:Bool)
    @objc  optional func plateKeyBoardShow()
    @objc  optional func plateKeyBoardHidden()
}
