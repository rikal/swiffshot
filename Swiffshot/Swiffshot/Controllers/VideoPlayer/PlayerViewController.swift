//
//  PlayerViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 21.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {

    var url:NSURL!
    var cameraView: UIView?
    var isCircle: Bool = false
    var publisher: PublishViewController?
    
    //MARK: -SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let additionalCameraButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: self.view.frame.height - 85, width: 50, height: 50))
        additionalCameraButton.backgroundColor = UIColor.clearColor()
        additionalCameraButton.setImage(UIImage(named: "AdditionalCamera"), forState: .Normal)
        additionalCameraButton.addTarget(self, action: #selector(additionalCameraPressed), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(additionalCameraButton)
    }
    
    //MARK: - ACTIONS
    
    func additionalCameraPressed(sender: UIButton!) {
        if publisher != nil{
            publisher?.stop()
        }
        isCircle = !isCircle
        cameraView?.removeFromSuperview()
        cameraView = UIView(frame: CGRect(x: self.view.frame.width - 120, y: self.view.frame.height - 210, width: 0, height: 0))
        cameraView!.backgroundColor = UIColor.clearColor()
        self.view.addSubview(cameraView!)
        self.view.layoutIfNeeded()
        
        self.goStreaming()
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.cameraView!.frame.size.height = 100
            self.cameraView!.frame.size.width = 100
            if self.isCircle {
                self.cameraView!.layer.cornerRadius = self.cameraView!.frame.size.width/2
            }
            self.view.layoutIfNeeded()
            }, completion: {(value: Bool) in
                self.publisher!.start()
        })
        
    }
    
    //MARK: - VIDEOPLAYER
    
    func createVideoPlayer(videourl: NSURL){
        url = videourl
        self.player = AVPlayer(URL: url)
        self.showsPlaybackControls = true
    }
    
    //MARK: STREAMING METHODS
    
    func goStreaming(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("publishView")
        
        let frameSize = cameraView!.bounds
        publisher = controller as? PublishViewController
        publisher!.view.layer.frame = frameSize
        publisher!.preview(false)
        if self.isCircle {
            self.publisher!.view.layer.cornerRadius = self.publisher!.view.frame.size.width/2
        }
        
        cameraView!.addSubview(publisher!.view)
    }

}
