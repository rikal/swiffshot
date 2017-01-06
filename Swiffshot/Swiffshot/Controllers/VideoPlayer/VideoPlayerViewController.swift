//
//  VideoPlayerViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 04.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var userNameBtn: UIButton!
    
    var player : AVPlayer?
    var videoLayer : AVPlayerLayer?
    var subscriber: SubcribeViewController?
    var isSubscribing: Bool = false
    var isPaused = false
    var playerViewController = PlayerViewController()
    
    let videoUrl = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestures()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        
        if isSubscribing {
            streamingPrepare()
        } else {
            createAndPlayVideo()
        }
    }
    
    //MARK: - ADD GESTURES
    
    private func addGestures(){
        let shortTap = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.shortTap(_:)))
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.longTap(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.downSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(hold)
        self.view.addGestureRecognizer(shortTap)
    }
    
    private func createAndPlayVideo(){
        player = AVPlayer(URL: videoUrl)
        player?.actionAtItemEnd = .None
        videoLayer = AVPlayerLayer(player: player)
        videoLayer?.frame = self.view.frame
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(videoLayer!, below: userNameBtn.layer)
        dispatch_async(dispatch_get_main_queue()) {
            self.player?.play()
        }
    }
    
    private func stopVideo(){
        player?.pause()
        player?.actionAtItemEnd = .None
        videoLayer?.removeFromSuperlayer()
    }
    
    private func pauseVideo(){
        dispatch_async(dispatch_get_main_queue()) {
            self.player?.pause()
        }
    }
    
    private func playVideo(){
        dispatch_async(dispatch_get_main_queue()) {
            self.player?.play()
        }
    }
    
    //MARK: - STREAMING METHODS
    
    private func streamingPrepare(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("subscribeView")
        
        let frameSize = self.view.bounds
        subscriber = controller as? SubcribeViewController
        subscriber?.view.layer.frame = frameSize
        
        self.presentViewController(subscriber!, animated: true){
            print("PLAYING STREAM")
            dispatch_async(dispatch_get_main_queue()) {
                self.subscriber?.start("testStream")
            }
        }
    }
    
    //MARK: - GESTURES METHODS
    
    @objc(longTap:)
    private func longTap(sender: UILongPressGestureRecognizer){
        pauseVideo()
        isPaused = true
    }
    
    @objc(downSwipe:)
    private func downSwipe(sender: UISwipeGestureRecognizer){
        stopVideo()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc(shortTap:)
    private func shortTap(sender: UITapGestureRecognizer){
        if isPaused {
            playVideo()
            isPaused = false
        }
    }
    
    @IBAction func userNamePressed(sender: AnyObject) {
        stopVideo()
        performSegueWithIdentifier("toProfile", sender: self)
    }
}
