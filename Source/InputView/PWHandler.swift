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
    //当前格子中的输入内容
    @objc public  var paletNumber = ""
    
    @objc public weak var  delegate : PWHandlerDelegate?
    
    let identifier = "PWInputCollectionViewCell"
    var inputCollectionView :UICollectionView!
    var maxCount = 7
    var selectIndex = 0
    var inputTextfield :UITextField!
    let keyboardView = PWKeyBoardView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var selectView = UIView()
    var isSetKeyboard = false//预设值时不设置为第一响应对象
    var view = UIView()
    var collectionView :UICollectionView!
    
    
    
    
    /*
     将车牌输入框绑定到一个你自己创建的UIview
     **/
    @objc public func setKeyBoardView(view: UIView){
        
        self.view = view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifier, bundle: Bundle(for: PWHandler.self)), forCellWithReuseIdentifier: identifier)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        view.addGestureRecognizer(tap)
        view.addSubview(collectionView)
        if (view.constraints.count > 0) {
            let topCos = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let leftCos = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let rightCos = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            let bottomCos = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            view.addConstraints([topCos,leftCos,rightCos,bottomCos])
        }
        inputCollectionView = collectionView
        inputTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height))
        view.addSubview(inputTextfield)
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        keyboardView.delegate = self
        keyboardView.mainColor = mainColor
        inputTextfield.inputView = keyboardView
    
        //因为直接切给collectionView加边框 会盖住蓝色的选中边框   所以加一个和collectionView一样大的view再切边框
        setBackgroundView()
        
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(plateKeyBoardShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(plateKeyBoardHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    /*
     检查是否是符合新能源车牌的规则
     **/
    @objc public func checkNewEnginePlate() ->Bool{
        for i in 0..<paletNumber.count {
            let vpl = paletNumber.subString(0, length: i)
            let listModel =  KeyboardEngine.generateLayout(at: i, plateNumber: vpl, numberType:.newEnergy, isMoreType:false);
            var result = false
            for j in 0..<listModel.rowArray().count {
                for k in 0..<listModel.rowArray()[j].count{
                    let key = listModel.rowArray()[j][k]

                    if paletNumber.subString(i, length: 1) == key.text, key.enabled {
                        result = true
                    }
                }
            }
            if !result {
                return false
            }
        }
        return true
    }
 
    
    /*
     检查输入车牌的完整
     **/
    @objc public func isComplete()-> Bool{
        return paletNumber.count == maxCount
    }
    
    @objc public func setPlate(plate:String,type:PWKeyboardNumType){
        paletNumber = plate;
        let isNewEnergy = type == .newEnergy
        var numType = type;
        selectIndex = plate.count == 0 ? 0 : plate.count - 1
        if  numType == .auto, paletNumber.count > 0, paletNumber.subString(0, length: 1) == "W" {
            numType = .wuJing
        } else if numType == .auto,paletNumber.count == 8 {
            numType = .newEnergy
        }
        keyboardView.numType = numType
        isSetKeyboard = true
        changeInputType(isNewEnergy: isNewEnergy)
    }
    
    @objc  public func changeInputType(isNewEnergy: Bool){
        let keyboardView = inputTextfield.inputView as! PWKeyBoardView
        keyboardView.numType = isNewEnergy ? .newEnergy : .auto
        var numType = keyboardView.numType
        if  paletNumber.count > 0, paletNumber.subString(0, length: 1) == "W" {
            numType = .wuJing
        }
        maxCount = (numType == .newEnergy || numType == .wuJing) ? 8 : 7
        if paletNumber.count > maxCount {
            paletNumber = paletNumber.subString(0, length: paletNumber.count - 1)
        } else if maxCount == 8,paletNumber.count == 7 {
            selectIndex = 7
        }
        if selectIndex > (maxCount - 1) {
            selectIndex = maxCount - 1
        }
        keyboardView.updateText(text: paletNumber, isMoreType: false, inputIndex: selectIndex)
        updateCollection()
    }
    
    private func setBackgroundView(){
        let backgroundView = UIView(frame: inputCollectionView.bounds)
        inputCollectionView.backgroundView = backgroundView
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1).cgColor
        backgroundView.isUserInteractionEnabled = false
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 2
        selectView.isUserInteractionEnabled = false
        inputCollectionView.addSubview(selectView)
    }
    
    @objc func plateKeyBoardShow(){
        if inputTextfield.isFirstResponder {
            delegate?.plateKeyBoardShow?()
        }
    }
    
    @objc func plateKeyBoardHidden(){
        if inputTextfield.isFirstResponder {
            delegate?.plateKeyBoardHidden?()
        }
    }
    
    @objc func tapAction(tap:UILongPressGestureRecognizer){
        let tapPoint = tap.location(in: view)
        let indexPath = collectionView.indexPathForItem(at: tapPoint)
        collectionView(collectionView, didSelectItemAt: indexPath!)
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
        
        return CGSize(width: (collectionView.frame.size.width / CGFloat(maxCount)) - 0.01, height: collectionView.frame.height)
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
            let rightSpace :CGFloat = (maxCount - 1) == selectIndex ? 0 : 0.5
            selectView.center = CGPoint(x: cell.center.x + rightSpace, y: cell.center.y)
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
        inputCollectionView.reloadData()
        if !inputTextfield.isFirstResponder,!isSetKeyboard {
            inputTextfield.becomeFirstResponder()
        }
        isSetKeyboard = false
    }
    
    func selectComplete(char: String, inputIndex: Int) {
        
        var isMoreType = false
        if char == "删除" , paletNumber.count >= 1 {
//            KeyboardEngine.subString(str: paletNumber, start: 0, length: paletNumber.count - 1)
            paletNumber = paletNumber.subString(0, length: paletNumber.count - 1)
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
            let numType = keyboardView.numType == .newEnergy ? PWKeyboardNumType.newEnergy : KeyboardEngine.plateNumberType(with: paletNumber)
            maxCount = (numType == .newEnergy || numType == .wuJing) ? 8 : 7
            if maxCount > paletNumber.count || selectIndex < paletNumber.count - 1 {
                selectIndex += 1;
            }
        }
        keyboardView.updateText(text: paletNumber, isMoreType: isMoreType, inputIndex: selectIndex)
        updateCollection()
        if (!isMoreType){
            delegate?.palteDidChnage?(plate:paletNumber,complete:paletNumber.count == maxCount)
        }
    }
    
   
    
    func getPaletChar(index:Int) -> String{
        if paletNumber.count > index {
            let NSPalet = paletNumber as NSString
            let char = NSPalet.substring(with: NSRange(location: index, length: 1))
            return char
        }
        return ""
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
