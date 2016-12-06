//
//  LatestStreamCollectionViewCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 24.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class LatestStreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var onlineStreamIndicatorView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var isOnlineCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell(isOnline: Bool){
        isOnlineCell = isOnline
        onlineStreamIndicatorView.layer.cornerRadius = 50
        onlineStreamIndicatorView.isHidden = !isOnline
        let randomNum:UInt32 = arc4random_uniform(10) + 1
        let someInt:Int = Int(randomNum)
        avatarImg.image = UIImage(named: "avatar_\(someInt)")
    }
}
