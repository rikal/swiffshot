//
//  CameraView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

protocol CameraViewDelegate {
    func startStopRecordingVideo(isStart: Bool)
    func cancelCameraView()
    func changeCamera()
}

class CameraView: UIView {

    @IBOutlet weak var shootBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alphaView: UIView!
    
    var delegate : CameraViewDelegate?
    var isStartToRecord : Bool = false
    

    class func instanceFromNib() -> CameraView {
        return UINib(nibName: "View", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CameraView
    }
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        shootBtn.layer.cornerRadius = 30
    }

    func showHideAlphaView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 0.6 }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.alphaView.alpha = CGFloat(alpha)
            }, completion: { (finished) in
                self.alphaView.isHidden = isHide
        })
    }
   
    @IBAction func shootVideo(_ sender: AnyObject) {
        isStartToRecord = !isStartToRecord
        delegate?.startStopRecordingVideo(isStart: isStartToRecord)
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
        showHideAlphaView(isHide: false)
        delegate?.cancelCameraView()
    }
    
    @IBAction func changeCameraPressed(_ sender: AnyObject) {
        delegate?.changeCamera()
    }
}
