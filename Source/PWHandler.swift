//
//  PWHandler.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/6/28.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

@objc public protocol PWHandlerDelegate{
    @objc  func plateInputComplete(plate: String)
    @objc  optional func palteDidChnage(plate:String,complete:Bool)
    @objc  optional func plateKeyBoardShow()
    @objc  optional func plateKeyBoardHidden()
}

public class PWHandler: NSObject,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,PWKeyBoardViewDeleagte {
    
    //格子中字体的颜色
    @objc public var textColor = UIColor.black
    //格子中字体的大小
    @objc public var textFontSize:CGFloat = 17
    //设置主题色（会影响格子的边框颜色、按下去时提示栏颜色、确定按钮可用时的颜色）
    @objc public var mainColor = UIColor(red: 65 / 256.0, green: 138 / 256.0, blue: 249 / 256.0, alpha: 1)
    
    let identifier = "PWInputCollectionViewCell"
    var inputCollectionView :UICollectionView!
    var maxCount = 7
    var selectIndex = 0
    var inputTextfield :UITextField!
     let keyboardView = PWKeyBoardView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var paletNumber = ""
    var selectView = UIView()
    var collectionViewResponder = false
    
    @objc public weak var  delegate : PWHandlerDelegate?
    
    @objc public func setKeyBoardView(collectionView:UICollectionView){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifier, bundle: Bundle(for: PWHandler.self)), forCellWithReuseIdentifier: identifier)
        inputCollectionView = collectionView
        inputTextfield = UITextField(frame: CGRect.zero)
        collectionView.addSubview(inputTextfield)
        keyboardView.delegate = self
        keyboardView.mainColor = mainColor
        inputTextfield.inputView = keyboardView
        
        //因为直接切给collectionView加边框 会盖住蓝色的选中边框   所以加一个和collectionView一样大的view再切边框
        let backgroundView = UIView(frame: collectionView.bounds)
        collectionView.backgroundView = backgroundView
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1).cgColor
        backgroundView.isUserInteractionEnabled = false
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 2
        selectView.isUserInteractionEnabled = false
        collectionView.addSubview(selectView)
        
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(plateKeyBoardShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(plateKeyBoardHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func plateKeyBoardShow(){
        if inputTextfield.isFirstResponder , !collectionViewResponder {
            delegate?.plateKeyBoardShow?()
        }
    }
    
    @objc func plateKeyBoardHidden(){
        if inputTextfield.isFirstResponder , !collectionViewResponder{
            delegate?.plateKeyBoardHidden?()
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row > paletNumber.count ? paletNumber.count : indexPath.row
        keyboardView.updateText(text: paletNumber, isMoreType: false, inputIndex: selectIndex)
        updateCollection()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.size.width / CGFloat(maxCount)), height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PWInputCollectionViewCell
        cell.charLabel.text = getPaletChar(index: indexPath.row)
        cell.charLabel.textColor = textColor
        cell.charLabel.font = UIFont.systemFont(ofSize: textFontSize)
        if indexPath.row == selectIndex {
            //给cell加上选中的边框
            selectView.layer.borderWidth = 2
            selectView.layer.borderColor = mainColor.cgColor
            selectView.frame = cell.frame
            corners(view: selectView, index: selectIndex)
        }
        corners(view: cell, index: indexPath.row)
        cell.layer.masksToBounds = true
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func updateCollection(){
        collectionViewResponder = true
        inputCollectionView.reloadData()
        if !inputTextfield.isFirstResponder {
            inputTextfield.becomeFirstResponder()
        }
        collectionViewResponder = false
    }
    
    func selectComplete(char: String, inputIndex: Int) {
        
        var isMoreType = false
        if char == "删除" , paletNumber.count >= 1 {
            paletNumber = Engine.subString(str: paletNumber, start: 0, length: paletNumber.count - 1)
            selectIndex = paletNumber.count
        }else  if char == "确定"{
            UIApplication.shared.keyWindow?.endEditing(true)
            delegate?.plateInputComplete(plate: paletNumber)
            return
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
        delegate?.palteDidChnage?(plate:paletNumber,complete:paletNumber.count == maxCount)
        keyboardView.updateText(text: paletNumber, isMoreType: isMoreType, inputIndex: selectIndex)
        updateCollection()
    }
    
    @objc public func setPlate(plate:String,type:PWKeyboardNumType){
        paletNumber = plate;
        let isNewEnergy = type == .newEnergy
        var numType = type;
        if  numType == .auto,paletNumber.count > 0,Engine.subString(str: paletNumber, start: 0, length: 1) == "W" {
            numType = .wuJing
        } else if numType == .auto,paletNumber.count == 8 {
            numType = .newEnergy
        }
        keyboardView.numType = numType
        changeInputType(isNewEnergy: isNewEnergy)
    }
    
    func getPaletChar(index:Int) -> String{
        if paletNumber.count > index {
            let NSPalet = paletNumber as NSString
            let char = NSPalet.substring(with: NSRange(location: index, length: 1))
            return char
        }
        return ""
    }
    
   @objc  public func changeInputType(isNewEnergy:Bool){
        let keyboardView = inputTextfield.inputView as! PWKeyBoardView
        keyboardView.numType = isNewEnergy ? .newEnergy : .auto
        var numType = keyboardView.numType
        if  paletNumber.count > 0,Engine.subString(str: paletNumber, start: 0, length: 1) == "W" {
            numType = .wuJing
        }
        maxCount = (numType == .newEnergy || numType == .wuJing) ? 8 : 7
        if paletNumber.count > maxCount {
            paletNumber = Engine.subString(str: paletNumber, start: 0, length: paletNumber.count - 1)
        } else if maxCount == 8,paletNumber.count == 7 {
            selectIndex = 7
        }
        if selectIndex > (maxCount - 1) {
            selectIndex = maxCount - 1
        }
        keyboardView.updateText(text: paletNumber, isMoreType: false, inputIndex: selectIndex)
        updateCollection()
    }
    
    func corners(view:UIView, index :Int){
        view.addRounded(cornevrs: UIRectCorner.allCorners, radii: CGSize(width: 0, height: 0))
        if index == 0{
            view.addRounded(cornevrs: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue))), radii: CGSize(width: 2, height: 2))
        } else if index == maxCount - 1 {
            view.addRounded(cornevrs: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue) | UInt8(UIRectCorner.bottomRight.rawValue))), radii: CGSize(width: 2, height: 2))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
