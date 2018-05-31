//
//  PWKeyBoardCollectionViewCell.swift
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/5/30.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

import UIKit

class PWKeyBoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var shadowImageVIew: UIImageView!
    
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = Bundle(for: self.classForCoder).path(forResource: "PWBundle", ofType: "bundle")
        let pwBundle = Bundle(path: path!)
        let normalImage = UIImage(contentsOfFile: (pwBundle?.path(forResource: "btn_normal@2x", ofType: "png", inDirectory: "Image"))!)?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        let pressedImage = UIImage(contentsOfFile: (pwBundle?.path(forResource: "btn_pressed@2x", ofType: "png", inDirectory: "Image"))!)?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        shadowImageVIew.image = normalImage
        shadowImageVIew.highlightedImage = pressedImage
        backgroundColor = UIColor.clear
    }
    
    func resetUI(){
        imageViewLeftConstraint.constant = 0
        iconImageView.isHidden = true
    }
    
    func setDeleteButton(left:CGFloat) {
        imageViewLeftConstraint.constant = left
        centerLabel.text = ""
        iconImageView.isHidden = false
        let path = Bundle(for: self.classForCoder).path(forResource: "PWBundle", ofType: "bundle")
        let pwBundle = Bundle(path: path!)
        iconImageView.image =  UIImage(contentsOfFile: (pwBundle?.path(forResource: "delete@2x", ofType: "png", inDirectory: "Image"))!)?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}
