//
//  MainViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class MainViewController: CameraViewController, UIGestureRecognizerDelegate, CameraViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var latestVideos = [String]()
    var trendingVideos = [String]()
    var discoverVideos = [String]()
    var globalIndexPathSection = 0
    
    var allVideos = [[String]]()
    
    let cellId = "categoryCellId"
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
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
        addTapGesture()
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    //MARK: - ADD TAPGESTURE for collection view
    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleTap(sender:)))
        tap.delegate = self
//        collectionView.backgroundView = UIView()
//        collectionView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
//        hideShowCollectionView(isHide: true)
        cameraView.showHideAlphaView(isHide: true)
    }
    
    //MARK: - HIDE/SHOW Collectionview
    
//    private func hideShowCollectionView(isHide: Bool){
//        var alpha: Float = 0.0
//        if isHide { alpha = 0.0 } else { alpha = 1.0 }
//        
//        UIView.animate(withDuration: 1.5, animations: {
//            self.collectionView.alpha = CGFloat(alpha)
//            }, completion: { (finished) in
//                if isHide { self.turnOnCamera() }
//                self.collectionView.isHidden = isHide
//        })
//    }
    
    //MARK: - CAMERA VIEW delegate
    
    func startStopRecordingVideo(isStart: Bool){
        srartStopRecord(isStart: isStart)
    }
    
    func cancelCameraView(){
//        hideShowCollectionView(isHide: false)
        removePreviewLayer()
    }
    
    func changeCamera(){
        removePreviewLayer()
        turnOnCamera()
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
        switch indexPath.section {
        case 0:
            cell.setupViews(color: UIColor.red, globInd: 0)
        case 1:
            cell.setupViews(color: UIColor.blue, globInd: 1)
        default:
            cell.setupViews(color: UIColor.green, globInd: 2)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}
