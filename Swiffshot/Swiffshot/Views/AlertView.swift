//
//  AlertView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 10.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var alertViewContainer: UIView!
    @IBOutlet weak var alertTextLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    static let shared = AlertView.instanceFromNib()
    
    class func instanceFromNib() -> AlertView {
        return UINib(nibName: "AlertView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AlertView
    }
    
    func showLoaderView(view: UIView, message: String){
        self.frame = view.frame
        view.addSubview(self)

        alertViewContainer.layer.cornerRadius = 10.0
        
        okBtn.layer.cornerRadius = 10
        okBtn.layer.borderWidth = 1.0
        okBtn.layer.borderColor = UIColor(colorLiteralRed: 75.0/255.0, green: 253.0/255.0, blue: 252.0/255.0, alpha: 1.0).CGColor
        alertTextLbl.text = message
    }
    
    @IBAction func okPressed(sender: AnyObject) {
        self.removeFromSuperview()
    }

}
