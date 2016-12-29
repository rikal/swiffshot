//
//  CameraView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewDelegate {
    func startStopRecordingVideo(isStart: Bool)
    func startStopStream(isStart: Bool)
    func cancelCameraView()
    func changeCamera()
    func chooseVideo()
}

class CameraView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var leftSecBtn: UILabel!
    @IBOutlet weak var shootBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var shootBtnContainerView: UIView!
//    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var useVideoBtn: UIButton!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    
    var delegate : CameraViewDelegate?
    var isRecording : Bool = false
    var isStreaming: Bool = false
    
    //MARK: SYSTEMS METHODS
    
    class func instanceFromNib() -> CameraView {
        return UINib(nibName: "View", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CameraView
    }
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        shootBtnContainerView.layer.cornerRadius = shootBtnContainerView.frame.size.width/2
        shootBtn.layer.cornerRadius = shootBtn.frame.size.width/2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        shootBtn.addGestureRecognizer(tap)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideTapped))
        hideTap.delegate = self
        alphaView.addGestureRecognizer(hideTap)
    }
    
    // SHOW HIDE ALPHA VIEW

    func showHideAlphaView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 0.6 }
        
        UIView.animateWithDuration(1.5, animations: {
            self.alphaView.alpha = CGFloat(alpha)
            }, completion: nil)
    }
    
    // ACTIONS
    
    func hideTapped(){
        showHideAlphaView(true)
    }
    
    func doubleTapped() {
        if !isRecording{
            isRecording = !isRecording
            delegate?.startStopRecordingVideo(isRecording)
        }
    }
   
    @IBAction func shootVideo(sender: AnyObject) {
        if isRecording{
            isRecording = !isRecording
            delegate?.startStopRecordingVideo(isRecording)
            return
        }
        isStreaming = !isStreaming
        delegate?.startStopStream(isStreaming)
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        showHideAlphaView(false)
        delegate?.cancelCameraView()
    }
    
    @IBAction func changeCameraPressed(sender: AnyObject) {
        delegate?.changeCamera()
    }
    
    @IBAction func flashBtnPressed(sender: AnyObject) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func loadVideoPressed(sender: AnyObject) {
        delegate?.chooseVideo()
    }
}
