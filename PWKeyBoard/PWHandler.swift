//
//  PWHandler.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/6/28.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

class PWHandler: NSObject,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,PWKeyBoardViewDeleagte {
    
    let identifier = "PWInputCollectionViewCell"
    var inputCollectionView :UICollectionView!
    var maxCount = 7
    var selectIndex = 0
    var inputTextfield :UITextField!
    let keyboardView = PWKeyBoardView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var paletNumber = ""
    
    func setKeyBoardView(collectionView:UICollectionView){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        inputCollectionView = collectionView
        inputTextfield = UITextField(frame: CGRect.zero)
        collectionView.addSubview(inputTextfield)
        keyboardView.delegate = self
        inputTextfield.inputView = keyboardView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row > paletNumber.count ? paletNumber.count : indexPath.row
        keyboardView.updateText(text: paletNumber, isMoreType: false, inputIndex: selectIndex)
        updateCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.size.width / CGFloat(maxCount)), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PWInputCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
        cell.charLabel.text = getPaletChar(index: indexPath.row)
        if indexPath.row == selectIndex {
            cell.layer.borderColor = UIColor.blue.cgColor
        }
        return cell
    }
    
    
    func updateCollection(){
        inputCollectionView.reloadData()
        if !inputTextfield.isFirstResponder {
            inputTextfield.becomeFirstResponder()
        }
    }
    
    func selectComplete(char: String, inputIndex: Int) {
        
        var isMoreType = false
        if char == "删除" , paletNumber.count >= 1 {
            paletNumber = Engine.subString(str: paletNumber, start: 0, length: paletNumber.count - 1)
            selectIndex = paletNumber.count
        }else  if char == "确定"{
            inputTextfield.resignFirstResponder()
        }else if char == "更多" {
            isMoreType = true
        } else if char == "返回" {
            isMoreType = false
        } else {
            if paletNumber.count <= inputIndex{
                paletNumber += char
            } else {
                let NSPalet = NSMutableString(string: paletNumber)
                NSPalet.replaceCharacters(in: NSRange(location: inputIndex, length: 1), with: char)
                paletNumber = NSString.init(format: "%@", NSPalet) as String
            }
            let keyboardView = inputTextfield.inputView as! PWKeyBoardView
            let numType = keyboardView.numType == .newEnergy ? PWKeyboardNumType.newEnergy : Engine.detectNumberTypeOf(presetNumber: paletNumber)
            maxCount = (numType == .newEnergy || numType == .wuJing) ? 8 : 7
            if maxCount > paletNumber.count || selectIndex < paletNumber.count - 1 {
                selectIndex += 1;
            }
        }
        keyboardView.updateText(text: paletNumber, isMoreType: isMoreType, inputIndex: selectIndex)
        updateCollection()
    }
    
    func getPaletChar(index:Int) -> String{
        if paletNumber.count > index {
            let NSPalet = paletNumber as NSString
            let char = NSPalet.substring(with: NSRange(location: index, length: 1))
            return char
        }
        return ""
    }
    func changeInputType(isNewEnergy:Bool){
        let keyboardView = inputTextfield.inputView as! PWKeyBoardView
        keyboardView.numType = isNewEnergy ? .newEnergy : .auto
        var numType = keyboardView.numType
        if  paletNumber.count > 0,Engine.subString(str: paletNumber, start: 0, length: 1) == "W" {
            numType = .wuJing
        }
        maxCount = (numType == .newEnergy || numType == .wuJing) ? 8 : 7
        if paletNumber.count > maxCount {
            paletNumber = Engine.subString(str: paletNumber, start: 0, length: paletNumber.count - 1)
            selectIndex = maxCount - 1
        } else if maxCount == 8,paletNumber.count == 7 {
            selectIndex = 7
        }
        keyboardView.updateText(text: paletNumber, isMoreType: false, inputIndex: selectIndex)
        updateCollection()
        
    }
}
