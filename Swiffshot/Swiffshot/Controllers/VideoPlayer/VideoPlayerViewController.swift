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
    
    @IBOutlet weak var nextMessage: UILabel!
    @IBOutlet weak var previousResponse: UILabel!
    @IBOutlet weak var currentMessage: UILabel!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var messagesContainer: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textTypeTxtField: UITextView!
    @IBOutlet weak var sendContainerView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var player : AVPlayer?
    var videoLayer : AVPlayerLayer?
    var subscriber: SubcribeViewController?
    var isSubscribing: Bool = false
    var isPaused = false
    var playerViewController = PlayerViewController()
    var globalMessageIndex = 1
    
    let messages = ["How is your trip going?", "Best ever I've seen!", "Hi! How are you?", "Give your feelings", "Are you crazy man?", "Nice try!", "Come to me!"]
    let answers = ["Thank you man!", "What do you mean?", "Yes, sir!", "Come with me"]
    
    let videoUrl = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMessage.text = messages[0]
        nextMessage.text = messages[globalMessageIndex]
        
        addGestures()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoPlayerViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoPlayerViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
//        let currentUser = ProfileModel().loadProfile()
        
//        MessageManager.shared.getAccessToken(43, channelName: "general", success: { (token) in
//                print(token)
//            }) { (error) in
//                print(error?.description)
//        }
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
        let shortTapMessage = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.messageShortTap(_:)))
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.longTap(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.downSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        let swipeMessageDown = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.downMessageSwipe(_:)))
        swipeMessageDown.direction = UISwipeGestureRecognizerDirection.Down
        let swipeMessageUp = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.upMessageSwipe(_:)))
        swipeMessageUp.direction = UISwipeGestureRecognizerDirection.Up
        
        let swipeMessageLeft = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.leftMessageSwipe(_:)))
        swipeMessageLeft.direction = UISwipeGestureRecognizerDirection.Left
        let swipeMessageRight = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.rightMessageSwipe(_:)))
        swipeMessageRight.direction = UISwipeGestureRecognizerDirection.Right
        
        self.view.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(hold)
        self.view.addGestureRecognizer(shortTap)
        messagesContainer.addGestureRecognizer(swipeMessageDown)
        messagesContainer.addGestureRecognizer(swipeMessageUp)
        messagesContainer.addGestureRecognizer(swipeMessageLeft)
        messagesContainer.addGestureRecognizer(swipeMessageRight)
        messagesContainer.addGestureRecognizer(shortTapMessage)
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
        textTypeTxtField.resignFirstResponder()
        pauseVideo()
        isPaused = true
    }
    
    @objc(downSwipe:)
    private func downSwipe(sender: UISwipeGestureRecognizer){
        textTypeTxtField.resignFirstResponder()
        stopVideo()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc(downMessageSwipe:)
    private func downMessageSwipe(sender: UISwipeGestureRecognizer){
        bottomConstraint.constant = -100
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        textTypeTxtField.resignFirstResponder()
    }
    
    @objc(upMessageSwipe:)
    private func upMessageSwipe(sender: UISwipeGestureRecognizer){
        bottomConstraint.constant = 0
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc(leftMessageSwipe:)
    private func leftMessageSwipe(sender: UISwipeGestureRecognizer){
        if globalMessageIndex > 1{
            globalMessageIndex -= 1
            nextMessage.text = messages[globalMessageIndex]
            if globalMessageIndex <= 1{
                currentMessage.text = messages[0]
            } else {
                currentMessage.text = messages[globalMessageIndex - 1]
            }
        }
        textTypeTxtField.resignFirstResponder()
    }
    
    @objc(rightMessageSwipe:)
    private func rightMessageSwipe(sender: UISwipeGestureRecognizer){
        if globalMessageIndex < messages.count{
            currentMessage.text = messages[globalMessageIndex]
            globalMessageIndex += 1
            if globalMessageIndex < messages.count - 1{
                nextMessage.text = messages[globalMessageIndex]
            } else {
                nextMessage.text = ""
            }
        }
        textTypeTxtField.resignFirstResponder()
    }
    
    @objc(shortTap:)
    private func shortTap(sender: UITapGestureRecognizer){
        if isPaused {
            playVideo()
            isPaused = false
        }
        textTypeTxtField.resignFirstResponder()
    }
    
    @objc(messageShortTap:)
    private func messageShortTap(sender: UITapGestureRecognizer){
        sendContainerView.hidden = false
        textTypeTxtField.becomeFirstResponder()
        
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func userNamePressed(sender: AnyObject) {
        stopVideo()
        performSegueWithIdentifier("toProfile", sender: self)
    }
    
    @IBAction func sendPressed(sender: AnyObject) {
        
    }
    //MARK: - KEYBOARDS
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                bottomConstraint.constant = keyboardHeight
                textTypeTxtField.userInteractionEnabled = true
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        bottomConstraint.constant = 0
        sendContainerView.hidden = true
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}