//
//  PWKeyBoardView.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/4/8.
//  Copyright © 2018年 Xi'an iRain IoT. Technology Service CO., Ltd. All rights reserved.
//

import UIKit

let KeybordHeight : CGFloat = 226

let kItemSpacing : CGFloat = 1

var kItemHeight : CGFloat = 51


protocol PWKeyBoardViewDeleagte {
    func selectComplete(char:String, inputIndex:Int)
}

class KeyBoardView: UIView,
                        UICollectionViewDelegate,
                        UICollectionViewDelegateFlowLayout,
                        UICollectionViewDataSource {
    
    var collectionView: UICollectionView!

    var keyboardLayout : KeyboardLayout!
    
    var numType = PWKeyboardNumType.auto
    var inputIndex = 0;
    var delegate: PWKeyBoardViewDeleagte?
    
    let identifier = "PWKeyBoardCollectionViewCell"
    
    let promptView = Bundle(for: KeyBoardView.self).loadNibNamed("PWPromptView", owner: nil, options: nil)?.last as! PWPromptView
    var mainColor = UIColor(red: 65 / 256.0, green: 138 / 256.0, blue: 249 / 256.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0 , y: Device.screenHeight - KeybordHeight, width: Device.screenWidth, height: KeybordHeight))
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        keyboardLayout =  KeyboardEngine.generateLayout(at: 0, plateNumber: "", numberType: numType, isMoreType: false);
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 30, height: 30)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Device.screenWidth , height:iphonxKeyBoardHeight()),collectionViewLayout:flowLayout)
        collectionView.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
        collectionView.register(UINib(nibName: identifier, bundle: Bundle(for: KeyBoardView.self)), forCellWithReuseIdentifier: identifier)
        self.addSubview(collectionView)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false;
        collectionView.canCancelContentTouches = true;
        collectionView.reloadData()
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: Device.screenWidth, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/256.0, green: 204/256.0, blue: 204/256.0, alpha: 1)
        addSubview(lineView)
        
        promptView.isHidden = true
        promptView.frame = CGRect(x: 0, y: 0, width: 55, height: 74)
        addSubview(promptView)
    }
    
    func iphoneXtabHeight() -> CGFloat {
        return Device.isIphoneX() ? 34 : 0;
    }
    
    func iphonxKeyBoardHeight() -> CGFloat{
        return KeybordHeight + iphoneXtabHeight()
    }
    
    func updateText(text: String, isMoreType: Bool, inputIndex: Int){
        self.inputIndex = inputIndex
        keyboardLayout = KeyboardEngine.generateLayout(at: inputIndex, plateNumber: text, numberType: numType,isMoreType:isMoreType);
        collectionView.reloadData()
    }
    
    func normalItemWith() -> CGFloat{
        
        let width = (Device.screenWidth - 8 - kItemSpacing * (CGFloat(keyboardLayout.rowArray()[0].count) - 1)) / CGFloat(keyboardLayout.rowArray()[0].count)
        return width
    }
    
    func submitItemWidth() -> CGFloat{
        let width = (normalItemWith() - 5) / 40 * 70 + 5
        return width
    }
    
    func deleteItemWidth() -> CGFloat{
        //在没有更多的情况下删除按钮的大小还需要加上左边的间距
        if keyboardLayout.row3![keyboardLayout.row3!.count - 3].keyCode! > 2 {
            return specialButtonWidth()
        }
        let width = (Device.screenWidth - 8 - submitItemWidth() - normalItemWith() * CGFloat(keyboardLayout.rowArray()[3].count - 2) - CGFloat(keyboardLayout.rowArray()[3].count - 1) * kItemSpacing) - 0.1
        return width
    }
    
    func moreItemWIdth() -> CGFloat {
        let width = (Device.screenWidth - 8 - submitItemWidth() - normalItemWith() * CGFloat(keyboardLayout.rowArray()[3].count - 3) - CGFloat(keyboardLayout.rowArray()[3].count - 1) * kItemSpacing) - 0.1 - deleteItemWidth()
        return width
    }
    
    func specialButtonWidth() -> CGFloat {
        let width = (normalItemWith() - 5) / 40 * 80 + 5
        return width
    }
    
    func showPrompt(item: PWKeyBoardCollectionViewCell){
        promptView.center = CGPoint(x: item.center.x, y: item.center.y - kItemHeight / 2 - 21)
        promptView.centerTextLabel.text = item.centerLabel.text
        promptView.centerTextLabel.textColor = mainColor
        promptView.isHidden = false
    }
    
    func hiddenPromt(){
        promptView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboardLayout.rowArray()[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PWKeyBoardCollectionViewCell
        
        let currentKey = keyboardLayout.rowArray()[indexPath.section][indexPath.row]
        
        cell.resetUI()
        cell.mainColor = mainColor
        cell.centerLabel.text = currentKey.text
        cell.isEnabledStatus = currentKey.enabled
        
        if (currentKey == keyboardLayout.row3![keyboardLayout.row3!.count - 2]){
            //给加宽的删除键左边留间隙
            let  left = deleteItemWidth() - specialButtonWidth()
            cell.setDeleteButton(left:left)
        }
        
        if currentKey == keyboardLayout.row3![keyboardLayout.row3!.count - 3] ,
            keyboardLayout.row3![keyboardLayout.row3!.count - 3].keyCode! > 2 {
            //给加宽的更多键左边留间隙
            let  left = moreItemWIdth() - specialButtonWidth()
            cell.setMoreButton(left: left)
        }
        
        if (currentKey == keyboardLayout.row3?.last) {
            //确定键颜色特殊处理
            cell.setSubmitBUtton(isEnabled: currentKey.enabled)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = normalItemWith()
        kItemHeight = Device.isIphoneX() ? 45 : kItemHeight
        //更多键的宽度需要加上左边空出来的宽度，没有更多时删除键加上
        if (keyboardLayout.rowArray()[indexPath.section][indexPath.row] == keyboardLayout.row3![keyboardLayout.row3!.count - 2]){
            return CGSize(width: deleteItemWidth(), height: kItemHeight)
        } else if (keyboardLayout.rowArray()[indexPath.section][indexPath.row] == keyboardLayout.row3?.last){
            return CGSize(width: submitItemWidth(), height: kItemHeight)
        } else if (keyboardLayout.rowArray()[indexPath.section][indexPath.row] == keyboardLayout.row3![keyboardLayout.row3!.count - 3]){
            //有更多的时候加长
            if keyboardLayout.row3![keyboardLayout.row3!.count - 3].keyCode! > 2 {
                return CGSize(width:moreItemWIdth(), height: kItemHeight)
            }
        }
        return CGSize(width: width, height: kItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = (Device.screenWidth - 8 - kItemSpacing * (CGFloat(keyboardLayout.rowArray()[0].count) - 1)) / CGFloat(keyboardLayout.rowArray()[0].count)
        var leftWidth = (Device.screenWidth - width * CGFloat(keyboardLayout.rowArray()[section].count) - kItemSpacing * CGFloat(keyboardLayout.rowArray()[section].count - 1)) / 2
        leftWidth = section == 3 ? 4 : leftWidth
        let topArray = [7,5,5,4]
        return UIEdgeInsets(top: CGFloat(topArray[section]), left: leftWidth, bottom:0, right: leftWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //没有值时点击删除键有点击效果但是不做处理
        if  keyboardLayout.presetNumber != nil,
            keyboardLayout.presetNumber!.count < 1 ,
            indexPath.section == 3,
            indexPath.row == keyboardLayout.rowArray()[indexPath.section].count - 2 {
            
            collectionView.reloadData()
            return
        }
        self.delegate?.selectComplete(char: keyboardLayout.rowArray()[indexPath.section][indexPath.row].text!,inputIndex:inputIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let currentKey = keyboardLayout.rowArray()[indexPath.section][indexPath.row]
        
         if (currentKey == keyboardLayout.row3?.last){
            
         } else if (currentKey == keyboardLayout.row3![keyboardLayout.row3!.count - 2]){
            
         } else if currentKey.keyCode != nil ,
            currentKey.keyCode! > 2 {
            
         } else if currentKey.enabled {
            let item = collectionView.cellForItem(at: indexPath) as! PWKeyBoardCollectionViewCell
            showPrompt(item: item)
        }
        return currentKey.enabled
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        hiddenPromt()
    }
}
