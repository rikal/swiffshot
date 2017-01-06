//
//  MessageCentralCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 06.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit

class MessageCentralCell: UICollectionViewCell {

    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillCell(message: String){
        messageLbl.text = message
    }
}
