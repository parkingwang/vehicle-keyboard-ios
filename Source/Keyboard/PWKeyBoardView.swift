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

let kItemSpacing : CGFloat = 1

var kItemHeight : CGFloat = 51


protocol PWKeyBoardViewDeleagte {
    func selectComplete(char:String,inputIndex:Int)
}


class PWKeyBoardView: UIView,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth, height: PWkeybordHeight),collectionViewLayout: UICollectionViewLayout())

    var listModel : KeyboardLayout!
    
    var numType = PWKeyboardNumType.auto
    var inputIndex = 0;
    var delegate :PWKeyBoardViewDeleagte?
    
    let identifier = "PWKeyBoardCollectionViewCell"
    
    let promptView = Bundle(for: PWKeyBoardView.self).loadNibNamed("PWPromptView", owner: nil, options: nil)?.last as! PWPromptView
    var mainColor = UIColor(red: 65 / 256.0, green: 138 / 256.0, blue: 249 / 256.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0 , y: PWScreenHeight - PWkeybordHeight, width: PWScreenWidth, height: PWkeybordHeight))
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 30, height: 30)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth , height:iphonxKeyBoardHeight()),collectionViewLayout:flowLayout)
        collectionView.backgroundColor = UIColor(red: 238 / 256.0, green: 238 / 256.0, blue: 238 / 256.0, alpha: 0)
        collectionView.register(UINib(nibName: identifier, bundle: Bundle(for: PWKeyBoardView.self)), forCellWithReuseIdentifier: identifier)
        self.addSubview(collectionView)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false;
        collectionView.canCancelContentTouches = true;
        listModel =  KeyboardEngine.generateLayout(keyboardType: PWKeyboardType.civilAndArmy, inputIndex: 0, presetNumber: "", numberType:numType,isMoreType:false);
        collectionView.reloadData()
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/256.0, green: 204/256.0, blue: 204/256.0, alpha: 1)
        addSubview(lineView)
        promptView.isHidden = true
        promptView.frame = CGRect(x: 0, y: 0, width: 55, height: 74)
        addSubview(promptView)
    }
    
    func isIphoneX() -> Bool {
        return (CGSize.init(width: 375, height: 812) == UIScreen.main.bounds.size)
    }
    
    func iphoneXtabHeight() -> CGFloat {
        return isIphoneX() ? 34 : 0;
    }
    
    func iphonxKeyBoardHeight() -> CGFloat{
        return PWkeybordHeight + iphoneXtabHeight()
    }
    
    func updateText(text: String, isMoreType: Bool, inputIndex: Int){
        self.inputIndex = inputIndex
        listModel = KeyboardEngine.generateLayout(keyboardType: PWKeyboardType.civilAndArmy, inputIndex: inputIndex, presetNumber: text, numberType: numType,isMoreType:isMoreType);
        collectionView.reloadData()
    }
    
    func normalItemWith() -> CGFloat{
        
        let width = (PWScreenWidth - 8 - kItemSpacing * (CGFloat(listModel.rowArray()[0].count) - 1)) / CGFloat(listModel.rowArray()[0].count)
        return width
    }
    
    func submitItemWidth() -> CGFloat{
        let width = (normalItemWith() - 5) / 40 * 70 + 5
        return width
    }
    
    func deleteItemWidth() -> CGFloat{
        //在没有更多的情况下删除按钮的大小还需要加上左边的间距
        if listModel.row3![listModel.row3!.count - 3].keyCode! > 2 {
            return specialButtonWidth()
        }
        let width = (PWScreenWidth - 8 - submitItemWidth() - normalItemWith() * CGFloat(listModel.rowArray()[3].count - 2) - CGFloat(listModel.rowArray()[3].count - 1) * kItemSpacing) - 0.1
        return width
    }
    
    func moreItemWIdth() -> CGFloat {
        let width = (PWScreenWidth - 8 - submitItemWidth() - normalItemWith() * CGFloat(listModel.rowArray()[3].count - 3) - CGFloat(listModel.rowArray()[3].count - 1) * kItemSpacing) - 0.1 - deleteItemWidth()
        return width
    }
    
    func specialButtonWidth() -> CGFloat {
        let width = (normalItemWith() - 5) / 40 * 80 + 5
        return width
    }
    
    func showPrompt(item:PWKeyBoardCollectionViewCell){
        promptView.center = CGPoint(x: item.center.x, y: item.center.y - kItemHeight / 2 - 21)
        promptView.centerTextLabel.text = item.centerLabel.text
        promptView.centerTextLabel.textColor = mainColor
        promptView.isHidden = false
    }
    
    func hiddenPromt(){
        promptView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModel.rowArray()[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PWKeyBoardCollectionViewCell
        
        let currentKey = listModel.rowArray()[indexPath.section][indexPath.row]
        
        cell.resetUI()
        cell.mainColor = mainColor
        cell.centerLabel.text = currentKey.text
        cell.isEnabledStatus = currentKey.enabled
        
        if (currentKey == listModel.row3![listModel.row3!.count - 2]){
            //给加宽的删除键左边留间隙
            let  left = deleteItemWidth() - specialButtonWidth()
            cell.setDeleteButton(left:left)
        }
        
        if currentKey == listModel.row3![listModel.row3!.count - 3] ,
            listModel.row3![listModel.row3!.count - 3].keyCode! > 2 {
            //给加宽的更多键左边留间隙
            let  left = moreItemWIdth() - specialButtonWidth()
            cell.setMoreButton(left: left)
        }
        
        if (currentKey == listModel.row3?.last) {
            //确定键颜色特殊处理
            cell.setSubmitBUtton(isEnabled: currentKey.enabled)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = normalItemWith()
        kItemHeight = isIphoneX() ? 45 : kItemHeight
        //更多键的宽度需要加上左边空出来的宽度，没有更多时删除键加上
        if (listModel.rowArray()[indexPath.section][indexPath.row] == listModel.row3![listModel.row3!.count - 2]){
            return CGSize(width: deleteItemWidth(), height: kItemHeight)
        } else if (listModel.rowArray()[indexPath.section][indexPath.row] == listModel.row3?.last){
            return CGSize(width: submitItemWidth(), height: kItemHeight)
        } else if (listModel.rowArray()[indexPath.section][indexPath.row] == listModel.row3![listModel.row3!.count - 3]){
            //有更多的时候加长
            if listModel.row3![listModel.row3!.count - 3].keyCode! > 2 {
                return CGSize(width:moreItemWIdth(), height: kItemHeight)
            }
        }
        return CGSize(width: width, height: kItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = (PWScreenWidth - 8 - kItemSpacing * (CGFloat(listModel.rowArray()[0].count) - 1)) / CGFloat(listModel.rowArray()[0].count)
        var leftWidth = (PWScreenWidth - width * CGFloat(listModel.rowArray()[section].count) - kItemSpacing * CGFloat(listModel.rowArray()[section].count - 1)) / 2
        leftWidth = section == 3 ? 4 : leftWidth
        let topArray = [7,5,5,4]
        return UIEdgeInsets(top: CGFloat(topArray[section]), left: leftWidth, bottom:0, right: leftWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //没有值时点击删除键有点击效果但是不做处理
        if  listModel.presetNumber != nil,
            listModel.presetNumber!.count < 1 ,
            indexPath.section == 3,
            indexPath.row == listModel.rowArray()[indexPath.section].count - 2 {
            
            collectionView.reloadData()
            return
        }
        self.delegate?.selectComplete(char: listModel.rowArray()[indexPath.section][indexPath.row].text!,inputIndex:inputIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let currentKey = listModel.rowArray()[indexPath.section][indexPath.row]
        
         if (currentKey == listModel.row3?.last){
            
         } else if (currentKey == listModel.row3![listModel.row3!.count - 2]){
            
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
