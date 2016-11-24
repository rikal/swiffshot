//
//  HeaderView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 24.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
        
    @IBOutlet weak var captionLbl: UILabel!
    
    func fillHeader(caption: String){
        captionLbl.text = caption
    }
}
