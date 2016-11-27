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

class VideoPlayerViewController: CameraViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var playerViewController = AVPlayerViewController()
    var player : AVPlayer!
    var url:NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGesture()
        startPlayingVideo()
    }

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
    
    //MARK: - ADD TAPGESTURE for collection view
    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.handleTap(sender:)))
        tap.delegate = self
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        hideShowCollectionView(isHide: true)
        cameraView.showHideAlphaView(isHide: true)
    }
    
    //MARK: - HIDE/SHOW Collectionview
    
    private func hideShowCollectionView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 1.0 }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.collectionView.alpha = CGFloat(alpha)
            }, completion: { (finished) in
                self.turnOnCamera()
                self.collectionView.isHidden = isHide
        })
    }
}

extension VideoPlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var cell = UICollectionViewCell()
        
        
        let smallCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userVideoCell", for: indexPath) as! ProfilesVideosCollectionViewCell
        smallCell.fillCell()
        cell = smallCell
        
        
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        startPlayingVideo()
    }
}
