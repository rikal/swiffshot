//
//  VideoPlayerViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 27.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    var playerViewController = AVPlayerViewController()
    var player : AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let url = NSURL(fileURLWithPath: "/Users/Dmitry/Documents/Job/swiffshot/Swiffshot/Swiffshot/video_2016-11-23_16-35-23.mov")
        //        player = AVPlayer(url: url as URL)
        let url:NSURL = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
        let asset = AVURLAsset(url: url as URL)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)

        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        self.present(playerViewController, animated: true){
            self.playerViewController.player?.play()
        }
    }

}
