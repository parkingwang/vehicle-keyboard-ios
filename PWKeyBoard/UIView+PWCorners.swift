//
//  UIView+PWCorners.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/7/6.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addRounded(cornevrs:UIRectCorner, radii:CGSize){
        let rounded = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornevrs, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape;
    }
}
