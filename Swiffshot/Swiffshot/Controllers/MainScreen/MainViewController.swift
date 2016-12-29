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
    @IBOutlet weak var topView: UIView!
    
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
        self.navigationController?.navigationBarHidden = true
        
        //if first time - go to authorization
        if !Defaults.sharedDefaults.userLogged{
            performSegueWithIdentifier("fromMainToAuth", sender: self)
        }
        prepareCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.navigationBarHidden = false
        navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.translucent = true
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.view.backgroundColor = UIColor.clearColor()
        title = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        cameraView.delegate = self
    }
    
    //MARK: - PREPEARE CollectionView
    
    private func prepareCollectionView(){
        collectionView.registerClass(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.registerNib(UINib(nibName: "MainHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "mainHeader");
    }
    
    //MARK: - CATEGORY Cell delegate
    
    func moveToCamera() {
        hideShowCollectionView(true)
//        cameraView.showHideAlphaView(true)
    }
    
    func moveToStream(isonline: Bool) {
        isStreamingOn = isonline
        performSegueWithIdentifier("fromMainToVideo", sender: self)
    }
    
    //MARK: - HIDE/SHOW Collectionview
    
    private func hideShowCollectionView(isHide: Bool){
        var alpha: Float = 0.0
        if isHide {
            alpha = 0.0
            self.turnOnCamera()
        } else { alpha = 1.0 }
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(1.5, animations: {
                self.collectionView.alpha = CGFloat(alpha)
                self.topView.alpha = CGFloat(alpha)
                }, completion: { (finished) in
                    if !isHide { self.removePreviewLayer() }
            })
        }
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
//        removePreviewLayer()
    }
    
    func changeCamera(){
        removePreviewLayer()
        self.isBackCamera = !self.isBackCamera
        turnOnCamera()
    }
    
    func chooseVideo(){
        loadVideo()
    }
    
    //MARK: - Header delegate
    
    func headerTapped(){
        performSegueWithIdentifier("fromMainToExpandable", sender: self)
    }

    //MARK: - SEGUES
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromMainToVideo"{
            let controller = segue.destinationViewController as! VideoPlayerViewController
            controller.isSubscribing = isStreamingOn
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: self.collectionView.frame.size.width, height: 300)
        default:
            return CGSize(width: self.collectionView.frame.size.width, height: 110)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! CategoryCell
        cell.setupViews(indexPath.section)
        cell.delegate = self
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 1,2:
            return CGSize(width: self.collectionView.frame.width, height: 50)
        default:
            return CGSize(width: self.collectionView.frame.width, height: 0)
        }
            
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "mainHeader", forIndexPath: indexPath) as! MainHeader
            headerView.delegate = self
            switch indexPath.section {
            case 0:
                headerView.fillHeader("FRIENDS")
            case 1:
                headerView.fillHeader("RECENT")
            default:
                headerView.fillHeader("Trending + Now")
            }
            reusableView = headerView
        }
        return reusableView!
    }
}
