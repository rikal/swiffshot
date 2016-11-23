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
    }
    
    @IBAction func takePhotoPressed(_ sender: AnyObject) {
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = UICollectionViewCell()
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let header = UICollectionReusableView()
        return header
    }
}
