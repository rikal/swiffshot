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
        if isHide{
            UIView.animate(withDuration: 1.5, animations: {
                    self.alphaView.alpha = 0.0
                }, completion: { (finished) in
                    self.alphaView.isHidden = true
            })
        } else {
            self.alphaView.isHidden = false
            UIView.animate(withDuration: 1.5, animations: {
                self.alphaView.alpha = 5.5
            })
        }
    }
   
    @IBAction func shootVideo(_ sender: AnyObject) {
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
    }
    
    @IBAction func changeCameraPressed(_ sender: AnyObject) {
    }
}
