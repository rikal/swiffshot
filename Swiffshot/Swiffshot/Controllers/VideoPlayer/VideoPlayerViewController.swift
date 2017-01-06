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
    @IBOutlet weak var messagesContainer: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var player : AVPlayer?
    var videoLayer : AVPlayerLayer?
    var subscriber: SubcribeViewController?
    var isSubscribing: Bool = false
    var isPaused = false
    var playerViewController = PlayerViewController()
    
    let messagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }()
    
    let messages = ["How is your trip going?", "Best ever I've seen!", "Hi! How are you?", "Give your feelings", "Are you crazy man?", "Nice try!", "Come to me!"]
    
    let videoUrl = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestures()
        addCollectionView()
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
    
    override func viewDidLayoutSubviews() {
        messagesCollectionView.frame = CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: messagesContainer.frame.size.height - 30)
    }
    
    //MARK: - ADD COLLECTION VIEW
    private func addCollectionView(){
        messagesContainer.addSubview(messagesCollectionView)
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        messagesCollectionView.backgroundColor = UIColor.clearColor()
        messagesCollectionView.showsHorizontalScrollIndicator = false
        
        messagesCollectionView.registerNib(UINib(nibName: "MessageCentralCell", bundle: nil), forCellWithReuseIdentifier: "messageCentralCell")
    }
    
    //MARK: - ADD GESTURES
    
    private func addGestures(){
        let shortTap = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.shortTap(_:)))
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.longTap(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.downSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        let swipeMessageDown = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.downMessageSwipe(_:)))
        swipeMessageDown.direction = UISwipeGestureRecognizerDirection.Down
        let swipeMessageUp = UISwipeGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.upMessageSwipe(_:)))
        swipeMessageUp.direction = UISwipeGestureRecognizerDirection.Up
        
        self.view.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(hold)
        self.view.addGestureRecognizer(shortTap)
        messagesContainer.addGestureRecognizer(swipeMessageDown)
        messagesContainer.addGestureRecognizer(swipeMessageUp)
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
    
    @objc(downMessageSwipe:)
    private func downMessageSwipe(sender: UISwipeGestureRecognizer){
        bottomConstraint.constant = -100
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc(upMessageSwipe:)
    private func upMessageSwipe(sender: UISwipeGestureRecognizer){
        bottomConstraint.constant = 0
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
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

extension VideoPlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        let profileCell = collectionView.dequeueReusableCellWithReuseIdentifier("messageCentralCell", forIndexPath: indexPath) as! MessageCentralCell
        profileCell.fillCell(messages[indexPath.row])
        cell = profileCell
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
