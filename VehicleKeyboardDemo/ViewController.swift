//
//  ViewController.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var count = 0

    @IBOutlet weak var myTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTextField.changeInputView()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        self.view.endEditing(false)
    }
    
    @IBAction func testButtonAction(_ sender: UIButton) {
        count += 1
        print("点击了最下面的按钮\(count)");
    }
}

