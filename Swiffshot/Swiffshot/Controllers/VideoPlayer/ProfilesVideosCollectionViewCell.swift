//
//  ProfilesVideosCollectionViewCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 27.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class ProfilesVideosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var previewImage: UIImageView!
    
    func fillCell(){
        previewImage.backgroundColor = UIColor.grayColor()
    }
}
