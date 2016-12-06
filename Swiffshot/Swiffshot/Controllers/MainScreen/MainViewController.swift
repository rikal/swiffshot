//
//  MainViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class MainViewController: CameraViewController, CameraViewDelegate, CategoryCellDelegate, MainHeaderDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var latestVideos = [String]()
    var trendingVideos = [String]()
    var discoverVideos = [String]()
    var globalIndexPathSection = 0
    
    var allVideos = [[String]]()
    let cellId = "categoryCellId"
    
    var isStreamingOn: Bool = false
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        //if first time - go to authorization
        if !Defaults.sharedDefaults.userLogged{
            performSegue(withIdentifier: "fromMainToAuth", sender: self)
        }
        prepareCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cameraView.delegate = self
    }
    
    //MARK: - PREPEARE CollectionView
    
    private func prepareCollectionView(){
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "MainHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "mainHeader");
    }
    
    //MARK: - CATEGORY Cell delegate
    
    func moveToCamera() {
        hideShowCollectionView(isHide: true)
        cameraView.showHideAlphaView(isHide: true)
    }
    
    func moveToStream(isonline: Bool) {
        isStreamingOn = isonline
        performSegue(withIdentifier: "fromMainToVideo", sender: self)
    }
    
    //MARK: - HIDE/SHOW Collectionview
    
    private func hideShowCollectionView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide { alpha = 0.0 } else { alpha = 1.0 }
        
        UIView.animate(withDuration: 1.5, animations: {
            self.collectionView.alpha = CGFloat(alpha)
            }, completion: { (finished) in
                if isHide { self.turnOnCamera() }
                self.collectionView.isHidden = isHide
        })
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
        turnOnCamera()
    }
    
    //MARK: - Header delegate
    
    func headerTapped(){
        performSegue(withIdentifier: "fromMainToExpandable", sender: self)
    }

    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMainToVideo"{
            let controller = segue.destination as! VideoPlayerViewController
            controller.isSubscribing = isStreamingOn
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: self.collectionView.frame.size.width, height: 300)
        default:
            return CGSize(width: self.collectionView.frame.size.width, height: 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.setupViews(globInd: indexPath.section)
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "mainHeader", for: indexPath) as! MainHeader
            headerView.delegate = self
            switch indexPath.section {
            case 0:
                headerView.fillHeader(title: "FRIENDS")
            case 1:
                headerView.fillHeader(title: "TRENDS")
            default:
                headerView.fillHeader(title: "DISCOVERING")
            }
            reusableView = headerView
        }
        return reusableView!
    }
}
