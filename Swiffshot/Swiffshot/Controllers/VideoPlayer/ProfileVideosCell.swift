//
//  ProfileVideosCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 06.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit

class ProfileVideosCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    var isOnlineCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell(isOnline: Bool){
        isOnlineCell = isOnline
        bgView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bgView.layer.borderWidth = 1.0
        bgView.layer.cornerRadius = 10.0
        bgView.layer.masksToBounds  = true
    }
}
