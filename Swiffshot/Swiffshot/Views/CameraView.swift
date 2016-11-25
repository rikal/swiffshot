//
//  CameraView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class CameraView: UIView {

    @IBOutlet weak var shootBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alphaView: UIView!

    class func instanceFromNib() -> CameraView {
        return UINib(nibName: "View", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CameraView
    }
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        shootBtn.layer.cornerRadius = 30
    }

    func showHideAlphaView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 0.55 }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.alphaView.alpha = CGFloat(alpha)
            }, completion: { (finished) in
                self.alphaView.isHidden = isHide
        })
    }
   
    @IBAction func shootVideo(_ sender: AnyObject) {
        print("SHOOTING")
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
        showHideAlphaView(isHide: false)
    }
    
    @IBAction func changeCameraPressed(_ sender: AnyObject) {
        print("CHANGING")
    }
}
