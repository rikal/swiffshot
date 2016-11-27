//
//  ProfileHeaderView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 27.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    func fillHeader(){
        let randomNum:UInt32 = arc4random_uniform(10) + 1
        let someInt:Int = Int(randomNum)
        profileImg.image = UIImage(named: "avatar_\(someInt)")
    }
}
