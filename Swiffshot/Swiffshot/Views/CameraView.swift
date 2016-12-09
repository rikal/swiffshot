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
    func startStream()
}

class CameraView: UIView {

    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var leftSecBtn: UILabel!
    @IBOutlet weak var shootBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var shootBtnContainerView: UIView!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    
    var delegate : CameraViewDelegate?
    var isStartToRecord : Bool = false
    
    //MARK: SYSTEMS METHODS
    
    class func instanceFromNib() -> CameraView {
        return UINib(nibName: "View", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CameraView
    }
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        shootBtnContainerView.layer.cornerRadius = shootBtnContainerView.frame.size.width/2
        shootBtn.layer.cornerRadius = shootBtn.frame.size.width/2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        shootBtn.addGestureRecognizer(tap)
    }
    
    // SHOW HIDE ALPHA VIEW

    func showHideAlphaView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 0.6 }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.alphaView.alpha = CGFloat(alpha)
            }, completion: nil)
    }
    
    
    // ACTIONS
    
    func changeShootBtn(isStop: Bool){
        shootBtn.isHidden = isStop
        stopBtn.isHidden = !isStop
    }
    
    func doubleTapped() {
        changeShootBtn(isStop: true)
        delegate?.startStream()
        isStartToRecord = !isStartToRecord
    }
    
    @IBAction func stopShootVideo(_ sender: AnyObject) {
        changeShootBtn(isStop: false)
        isStartToRecord = !isStartToRecord
        delegate?.startStopRecordingVideo(isStart: isStartToRecord)
    }
   
    @IBAction func shootVideo(_ sender: AnyObject) {
        changeShootBtn(isStop: true)
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
