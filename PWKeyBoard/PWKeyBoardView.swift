//
//  PWKeyBoardView.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

let PWScreenWidth = UIScreen.main.bounds.width
let PWScreenHeight = UIScreen.main.bounds.height
let PWScreenBounds = UIScreen.main.bounds
let PWMainScreen = UIScreen.main

let PWkeybordHeight : CGFloat = 226

class PWKeyBoardView: UIView {
    
    
    
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth, height: PWkeybordHeight),collectionViewLayout: UICollectionViewLayout())

    var listModel = [Engine .update(keyboardType: PWKeyboardType.civilAndArmy, inputIndex: 0, presetNumber: "", numberType: PWKeyboardNumType.auto)];
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0 , y: PWScreenHeight - PWkeybordHeight, width: PWScreenWidth, height: PWkeybordHeight))
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        collectionView.backgroundColor = UIColor(red: 238 / 256.0, green: 238 / 256.0, blue: 238 / 256.0, alpha: 0)
        self.addSubview(collectionView)
    }
    
    func show() {
        
    }
    
    func hidden()  {
        
    }

}
