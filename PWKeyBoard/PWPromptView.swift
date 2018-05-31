//
//  PWPromptView.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/5/31.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

class PWPromptView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var centerTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = Bundle(for: self.classForCoder).path(forResource: "PWBundle", ofType: "bundle")
        let pwBundle = Bundle(path: path!)
        backgroundImageView.image =  UIImage(contentsOfFile: (pwBundle?.path(forResource: "pressed@2x", ofType: "png", inDirectory: "Image"))!)
    }

}
