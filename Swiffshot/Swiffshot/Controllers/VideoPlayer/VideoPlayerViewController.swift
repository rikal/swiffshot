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

class VideoPlayerViewController: CameraViewController, UIGestureRecognizerDelegate, CameraViewDelegate {
    
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var videoThumbs: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    
    var playerViewController = AVPlayerViewController()
    var player : AVPlayer?
    var videoLayer : AVPlayerLayer?
    var url:NSURL!
    
    var subscriber: SubcribeViewController?
    var isSubscribing: Bool = false

    let videosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGesture()
        if isSubscribing {
            streamingPrepare()
        } else {
            createVideoPlayer()
            startPlayingVideo()
        }
    }
    
    //MARK: - SYSTEMS METHODS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
        //TODO: name from profile model
        title = "@UserName"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cameraView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        videoThumbs.layer.cornerRadius = videoThumbs.frame.size.height/2
        videoThumbs.layer.masksToBounds  = true
        videosCollectionView.frame = CGRect(x: 0, y: videoContainerView.frame.size.height + 64, width: self.view.frame.size.width, height: 150)
    }
    
    //MARK: - ADD TAPGESTURE for collection view
    
    private func addTapGesture(){
        self.view.addSubview(videosCollectionView)
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        videosCollectionView.backgroundColor = UIColor.clear
        videosCollectionView.showsHorizontalScrollIndicator = false
        
        videosCollectionView.register(UINib(nibName: "LatestStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCell")
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.handleTap(sender:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.handleTap(sender:)))
        tap1.delegate = self
        tap2.delegate = self
        videoContainerView.addGestureRecognizer(tap1)
        bottomViewContainer.addGestureRecognizer(tap2)
        
        let tapToVideo = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.videoTap(sender:)))
        tapToVideo.delegate = self
        videoThumbs.addGestureRecognizer(tapToVideo)
    }
    
    @objc(videoTap:)
    private func videoTap(sender: UITapGestureRecognizer){
        stopVideoInCircle()
        startPlayingVideo()
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        hideShowCollectionView(isHide: true)
        cameraView.showHideAlphaView(isHide: true)
    }
    
    //MARK: - VIDEO METHODS
    
    func createVideoPlayer(){
        url = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
        player = AVPlayer(url: url as URL)
    }
    
    func playVideoInCircle(){
        player?.actionAtItemEnd = .none
        videoLayer = AVPlayerLayer(player: player)
        videoLayer?.frame = videoThumbs.bounds
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoThumbs.layer.addSublayer(videoLayer!)
        DispatchQueue.main.async {
            self.player?.play()
        }
    }
    
    func stopVideoInCircle(){
        player?.pause()
        player?.actionAtItemEnd = .none
        videoLayer?.removeFromSuperlayer()
    }

    func startPlayingVideo(){
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        self.present(playerViewController, animated: true){
            print("PLAYING")
            DispatchQueue.main.async {
                self.playerViewController.player?.play()
            }
        }
    }
    
    //MARK: - HIDE/SHOW Collectionview
    
    private func hideShowCollectionView(isHide: Bool){
        var alpha: Float?
        if isHide { alpha = 0.0 } else { alpha = 1.0 }
        
        if isHide { self.turnOnCamera() }
        UIView.animate(withDuration: 1.5, animations: {
            self.videosCollectionView.alpha = CGFloat(alpha!)
            self.videoContainerView.alpha = CGFloat(alpha!)
            }, completion: { (finished) in
                self.videosCollectionView.isHidden = isHide
                self.videoContainerView.isHidden = isHide
        })
    }
    
    //MARK: - STREAMING METHODS
    
    func streamingPrepare(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "subscribeView")
        
        let frameSize = self.view.bounds
        subscriber?.view.layer.frame = frameSize
        subscriber = controller as? SubcribeViewController
        subscriber?.view.layer.frame = frameSize
        
        self.present(subscriber!, animated: true){
            print("PLAYING STREAM")
            DispatchQueue.main.async {
                self.subscriber?.start(streamName: "testStream")
            }
        }
    }
    
    //MARK: - CAMERA VIEW delegate
    
    func startStream() {
        goStreaming()
    }
    
    func startStopRecordingVideo(isStart: Bool){
        srartStopRecord(isStart: isStart)
    }
    
    func cancelCameraView(){
        hideShowCollectionView(isHide: false)
        removePreviewLayer()
    }
    
    func changeCamera(){
        removePreviewLayer()
        self.isBackCamera = !self.isBackCamera
        turnOnCamera()
    }
}

extension VideoPlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var cell: UICollectionViewCell?
        let bigcell = collectionView.dequeueReusableCell(withReuseIdentifier: "bigCell", for: indexPath) as! LatestStreamCollectionViewCell
        indexPath.row == 0 ? bigcell.fillCell(isOnline: true) : bigcell.fillCell(isOnline: false)
        cell = bigcell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var header = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionHeader{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
            headerView.fillHeader()
            
            header = headerView
            
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stopVideoInCircle()
        createVideoPlayer()
        playVideoInCircle()
    }
}
