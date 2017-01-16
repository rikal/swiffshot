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
    @IBOutlet weak var shootBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var shootBtnContainerView: UIView!
    
    var delegate : CameraViewDelegate?
    var isRecording : Bool = false
    var isStreaming: Bool = false
    
    var circleLayer: CAShapeLayer?
    var timer: NSTimer?
    
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
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(CameraView.longTap(_:)))
        shootBtn.addGestureRecognizer(hold)
        
        if Defaults.sharedDefaults.userKnowAboutCamera{
            alphaView.hidden = true
        }
    }
    
    //MARK: - CIRcLE ANIMATION
    
    func createCirclePath(){
        let circlePath = UIBezierPath(arcCenter: shootBtnContainerView.center, radius: shootBtnContainerView.frame.size.width/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer!.path = circlePath.CGPath
        circleLayer!.fillColor = UIColor.clearColor().CGColor
        circleLayer!.strokeColor = UIColor.redColor().CGColor
        circleLayer!.lineWidth = 3.0;

        circleLayer!.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer!)
    }
    
    func animateCircle(duration: NSTimeInterval) {
        circleLayer?.removeFromSuperlayer()
        createCirclePath()
        circleLayer!.strokeEnd = 0.0
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer!.strokeEnd = 1.0
        circleLayer!.addAnimation(animation, forKey: "animateCircle")
    }

    
    // SHOW HIDE ALPHA VIEW

    func showHideAlphaView(isHide: Bool){
        Defaults.sharedDefaults.userKnowAboutCamera = true
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
        delegate?.chooseVideo()
    }
    
    @objc(longTap:)
    private func longTap(sender: UILongPressGestureRecognizer){
        if isRecording{
            isRecording = !isRecording
            delegate?.startStopRecordingVideo(isRecording)
            return
        }
        isStreaming = !isStreaming
        delegate?.startStopStream(isStreaming)
    }
    
    func updateTimer() {
        isRecording = !isRecording
        delegate?.startStopRecordingVideo(isRecording)
        timer?.invalidate()
    }
   
    @IBAction func shootVideo(sender: AnyObject) {
        if !isRecording{
            timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(CameraView.updateTimer), userInfo: nil, repeats: true)
            animateCircle(20)
        } else {
            timer?.invalidate()
            circleLayer?.removeAnimationForKey("animateCircle")
            circleLayer!.strokeEnd = 0.0
        }
        isRecording = !isRecording
        delegate?.startStopRecordingVideo(isRecording)
    }

    @IBAction func cancelPressed(sender: AnyObject) {
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
                    flashBtn.setImage(UIImage(named: "Flash"), forState: .Normal)
                } else {
                    flashBtn.setImage(UIImage(named: "NoFlash"), forState: .Normal)
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
        
    }
}
