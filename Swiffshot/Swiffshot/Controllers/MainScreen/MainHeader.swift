//
//  MainHeader.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 29.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

protocol MainHeaderDelegate: class {
    func headerTapped()
}

class MainHeader: UICollectionReusableView {

    @IBOutlet weak var headerBtn: UIButton!
    
    weak var delegate: MainHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillHeader(title: String){
        headerBtn.setTitle(title, for: .normal)
    }
    
    @IBAction func headerPressed(_ sender: AnyObject) {
        delegate?.headerTapped()
    }
}
