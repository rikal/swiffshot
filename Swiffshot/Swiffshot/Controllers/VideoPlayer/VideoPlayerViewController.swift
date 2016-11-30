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
    
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoThumbs: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    
    var playerViewController = AVPlayerViewController()
    var player : AVPlayer!
    var url:NSURL!

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
        startPlayingVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.handleTap(sender:)))
        tap.delegate = self
        videosCollectionView.backgroundView = UIView()
        videosCollectionView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        hideShowCollectionView(isHide: true)
        cameraView.showHideAlphaView(isHide: true)
    }
    
    //MARK: - VIDEO METHODS

    func startPlayingVideo(){
        url = NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!
        
        player = AVPlayer(url: url as URL)
        
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        self.present(playerViewController, animated: true){
            print("PLAYING")
            self.playerViewController.player?.play()
        }
    }
    
    //MARK: - HIDE/SHOW Collectionview
    
    private func hideShowCollectionView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 1.0 }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.videosCollectionView.alpha = CGFloat(alpha)
            }, completion: { (finished) in
                if isHide { self.turnOnCamera() }
                self.videosCollectionView.isHidden = isHide
        })
    }
    
    //MARK: - CAMERA VIEW delegate
    
    func startStopRecordingVideo(isStart: Bool){
        srartStopRecord(isStart: isStart)
    }
    
    func cancelCameraView(){
        hideShowCollectionView(isHide: false)
        removePreviewLayer()
    }
    
    func changeCamera(){
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
        startPlayingVideo()
    }
}
