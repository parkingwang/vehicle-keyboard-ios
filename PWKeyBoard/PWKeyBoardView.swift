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

let itemSpacing : CGFloat = 1

class PWKeyBoardView: UIView,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth, height: PWkeybordHeight),collectionViewLayout: UICollectionViewLayout())

    var listModel = Engine.update(keyboardType: PWKeyboardType.civilAndArmy, inputIndex: 0, presetNumber: "", numberType: PWKeyboardNumType.auto);
    
    let identifier = "PWKeyBoardCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0 , y: PWScreenHeight - PWkeybordHeight, width: PWScreenWidth, height: PWkeybordHeight))
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth, height: PWkeybordHeight),collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor(red: 238 / 256.0, green: 238 / 256.0, blue: 238 / 256.0, alpha: 0)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        self.addSubview(collectionView)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: PWScreenWidth, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/256.0, green: 204/256.0, blue: 204/256.0, alpha: 1)
        self.addSubview(lineView)
    }
    
    func show() {
        
    }
    
    func hidden()  {
        
    }
    
    func normalItemWith() -> CGFloat{
        //删除按钮的大小还需要加上左边的间距
        let width = (PWScreenWidth - 8 - itemSpacing * (CGFloat(listModel.rowArray()[0].count) - 1)) / CGFloat(listModel.rowArray()[0].count)
        return width
    }
    
    func submitItemWidth() -> CGFloat{
        let width = (normalItemWith() - 5) / 40 * 70 + 5
        return width
    }
    
    func delegateItemWidth() -> CGFloat{
        let width = (PWScreenWidth - 8 - submitItemWidth() - normalItemWith() * CGFloat(listModel.rowArray()[3].count - 2) - CGFloat(listModel.rowArray()[3].count - 1) * itemSpacing)
        return width
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModel.rowArray()[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PWKeyBoardCollectionViewCell
        cell.centerLabel.text = listModel.rowArray()[indexPath.section][indexPath.row].text
        if (listModel.rowArray()[indexPath.section][indexPath.row] == listModel.row3![listModel.row3!.count - 2]){
            let  left = delegateItemWidth() - (normalItemWith() - 5) / 40 * 42 - 5
            cell.setDeleteButton(left:left)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = normalItemWith()
        if (listModel.rowArray()[indexPath.section][indexPath.row] == listModel.row3![listModel.row3!.count - 2]){
            
            return CGSize(width: delegateItemWidth(), height: 52)
        } else if (listModel.rowArray()[indexPath.section][indexPath.row] == listModel.row3?.last){
            return CGSize(width: submitItemWidth(), height: 52)
        }
        return CGSize(width: width, height: 51)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = (PWScreenWidth - 8 - itemSpacing * (CGFloat(listModel.rowArray()[0].count) - 1)) / CGFloat(listModel.rowArray()[0].count)
        var leftWidth = (PWScreenWidth - width * CGFloat(listModel.rowArray()[section].count) - itemSpacing * CGFloat(listModel.rowArray()[section].count - 1)) / 2
        leftWidth = section == 3 ? 4 : leftWidth
        let topArray = [7,5,5,4]
        return UIEdgeInsets(top: CGFloat(topArray[section]), left: leftWidth, bottom:0, right: leftWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
