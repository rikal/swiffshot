//
//  ProfileViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 27.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ProfileViewController: CameraViewController, UIGestureRecognizerDelegate, CameraViewDelegate {
    
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var minutesAwayLbl: UILabel!
    
    var player : AVPlayer?
    var videoLayer : AVPlayerLayer?
    var subscriber: SubcribeViewController?
    var isSubscribing: Bool = false

    let videoUrl = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
    let videosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }()
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGesture()
        addCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraView.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        videoPreview.layer.borderColor = UIColor.lightGrayColor().CGColor
        videoPreview.layer.borderWidth = 1.0
        videoPreview.layer.cornerRadius = videoPreview.frame.size.height/2
        videoPreview.layer.masksToBounds  = true
        videosCollectionView.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: bottomContainer.frame.size.height - 10)
    }
    
    //MARK: - ADD TAPGESTURE for collection view
    private func addCollectionView(){
        bottomContainer.addSubview(videosCollectionView)
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        videosCollectionView.backgroundColor = UIColor.clearColor()
        videosCollectionView.showsHorizontalScrollIndicator = false
        
        videosCollectionView.registerNib(UINib(nibName: "ProfileVideosCell", bundle: nil), forCellWithReuseIdentifier: "profileVideosCell")
    }
    
    private func addTapGesture(){
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(_:)))
        tap1.delegate = self
        tap2.delegate = self
        videoContainer.addGestureRecognizer(tap1)
        bottomContainer.addGestureRecognizer(tap2)
        
        let tapToVideo = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.videoTap(_:)))
        tapToVideo.delegate = self
        videoPreview.addGestureRecognizer(tapToVideo)
    }
    
    @objc(videoTap:)
    private func videoTap(sender: UITapGestureRecognizer){
        stopVideoInCircle()
        //TODO: SEND NEW URL
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        hideShowCollectionView(true)
    }
    
    // MARK: - VIDEO ACTIONS
    
    func playVideoInCircle(){
        player = AVPlayer(URL: videoUrl)
        player?.actionAtItemEnd = .None
        videoLayer = AVPlayerLayer(player: player)
        videoLayer?.frame = videoPreview.bounds
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreview.layer.addSublayer(videoLayer!)
        dispatch_async(dispatch_get_main_queue()) {
            self.player?.play()
        }
    }
    
    func stopVideoInCircle(){
        player?.pause()
        player?.actionAtItemEnd = .None
        videoLayer?.removeFromSuperlayer()
    }
    
    
    //MARK: - HIDE/SHOW Collectionview
    
    private func hideShowCollectionView(isHide: Bool){
        var alpha: Float?
        if isHide { alpha = 0.0 } else { alpha = 1.0 }
        
        if isHide { self.turnOnCamera() }
        UIView.animateWithDuration(1.5, animations: {
            self.bottomContainer.alpha = CGFloat(alpha!)
            self.videoContainer.alpha = CGFloat(alpha!)
            }, completion: { (finished) in
                self.bottomContainer.hidden = isHide
                self.videoContainer.hidden = isHide
        })
    }
    
    //MARK: - CAMERA VIEW delegate
    
    func startStopStream(isStart: Bool) {
        isStart ? goStreaming() : stopStreaming()
    }
    
    func startStopRecordingVideo(isStart: Bool){
        srartStopRecord(isStart)
    }
    
    func cancelCameraView(){
        hideShowCollectionView(false)
        removePreviewLayer()
    }
    
    func changeCamera(){
        removePreviewLayer()
        self.isBackCamera = !self.isBackCamera
        turnOnCamera()
    }
    
    func chooseVideo(){
        loadVideo()
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func settingsPressed(sender: AnyObject) {
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        let profileCell = collectionView.dequeueReusableCellWithReuseIdentifier("profileVideosCell", forIndexPath: indexPath) as! ProfileVideosCell
        profileCell.fillCell(false)
        cell = profileCell
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let spacing = (collectionView.frame.size.width/3 - 100)
        return UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        stopVideoInCircle()
        playVideoInCircle()
    }
}
