//
//  MainViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class MainViewController: CameraViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var latestVideos = [String]()
    var trendingVideos = [String]()
    var discoverVideos = [String]()
    
    var allVideos = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        visualEffects()
    }
    
    private func visualEffects(){
        
    }
    
    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleTap(sender:)))
        tap.delegate = self
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        print("TAPPED")
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0:
            let spacing = (self.collectionView.frame.size.width/2 - 100)/2
            return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        default:
            let spacing = (self.collectionView.frame.size.width/3 - 70)/2
            return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5//allVideos[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        var cell = UICollectionViewCell()
        
        switch indexPath.section {
        case 0:
            let bigCell = collectionView.dequeueReusableCell(withReuseIdentifier: "streamCell", for: indexPath) as! LatestStreamCollectionViewCell
            indexPath.row == 0 ? bigCell.fillCell(isOnline: true) : bigCell.fillCell(isOnline: false)
            cell = bigCell
        default:
            let smallCell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCell", for: indexPath) as! SmallCollectionViewCell
            indexPath.row == 0 ? smallCell.fillCell(isOnline: true) : smallCell.fillCell(isOnline: false)
            cell = smallCell
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
    }
}
