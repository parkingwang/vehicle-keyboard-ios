//
//  ViewController.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit
import VehicleKeyboard_swift

class ViewController: UIViewController,PWHandlerDelegate {
    
    var count = 0
    let handler = PWHandler()

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var newEnergyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.delegate = self
        //改变主题色
//     handler.mainColor = UIColor.red
        //UITextField绑定车牌键盘(输入框形式)
        self.myTextField.changeToPlatePWKeyBoardInpurView()
        
        //UICollectionView绑定车牌键盘(格子形式)
       handler.setKeyBoardView(collectionView: collectionView)
    }
    

    @IBAction func changeModeButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //uitextField输入框改变新能源
        myTextField.changePlateInputType(isNewEnergy:sender.isSelected)
        
        //格子输入框改变新能源
        handler.changeInputType(isNewEnergy: sender.isSelected)
    }
    
    //隐藏键盘
    @IBAction func buttonAction(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    //填充格子输入框的值
    @IBAction func setCollectionInputButtonAction(_ sender: UIButton) {
        newEnergyButton.isSelected = false
        self.handler.setPlate(plate: "湘JR0001", type: .auto)
    }
    
    //填充uitextfield的值
    @IBAction func setTextFieldPlateButtonAction(_ sender: UIButton) {
        newEnergyButton.isSelected = false
        myTextField.setPlate(plate: "粤BR0001", type: .auto)
    }
    
    //MARK:车牌键盘代理方法-格子输入框专用
    func plateInputComplete(plate: String) {
        print("输入完成车牌号为:" + plate)
    }
    
    func palteDidChnage(plate:String,complete:Bool) {
        print("输入完成车牌号为:" + plate + "\n输入是否完整？:" + (complete ? "完整" : "不完整"))
    }
    func plateKeyBoardShow() {
        print("车牌键盘显示")
    }
    func plateKeyBoardHidden() {
        print("车牌键盘隐藏")
    }
}

