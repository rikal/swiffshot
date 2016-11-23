//
//  LatestStreamCollectionViewCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class LatestStreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var liveStreamIndicatorView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        liveStreamIndicatorView.layer.cornerRadius = liveStreamIndicatorView.frame.size.height/2
    }

}
