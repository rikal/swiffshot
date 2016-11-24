//
//  MainViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    let camera = CameraManager.sharedCamera
    
    var latestVideos = [String]()
    var trendingVideos = [String]()
    var discoverVideos = [String]()
    
    var allVideos = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        previewLayer = camera.beginSession()
//        self.view.layer.insertSublayer(previewLayer!, below: cameraButtonsView.layer)
    }
    
    override func viewDidLayoutSubviews() {
        visualEffects()
    }
    
    private func visualEffects(){
        takePhotoBtn.layer.cornerRadius = takePhotoBtn.frame.size.height/2
        let spacing = (self.collectionView.frame.size.width/2 - 100)/2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
    
    @IBAction func takePhotoPressed(_ sender: AnyObject) {
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5//allVideos[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "streamCell", for: indexPath) as! LatestStreamCollectionViewCell
        indexPath.row == 0 ? cell.fillCell(isOnline: true) : cell.fillCell(isOnline: false)
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 3//allVideos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var header = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionHeader{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            switch indexPath.section {
            case 0:
                headerView.fillHeader(caption: "LATEST")
            case 1:
                headerView.fillHeader(caption: "TRANDING")
            case 2:
                headerView.fillHeader(caption: "DISCOVERING")
            default:
                headerView.fillHeader(caption: "")
            }
            
            header = headerView
            
        }
        
        return header
    }
}
