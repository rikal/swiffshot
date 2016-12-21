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
    
    func additionalCameraPressed(sender: UIButton!) {
        print("Button tapped")
    }
    
    func createVideoPlayer(videourl: NSURL){
        url = videourl
        self.player = AVPlayer(URL: url as NSURL)
        self.showsPlaybackControls = true
    }

}
