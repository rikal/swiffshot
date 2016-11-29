//
//  CategoryCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 29.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var globalIndexSection = 0
    private let cellId = "cellId"
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let videosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupViews(color: UIColor, globInd: Int){
        backgroundColor = color
        globalIndexSection = globInd
        addSubview(videosCollectionView)
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        videosCollectionView.backgroundColor = UIColor.brown
        videosCollectionView.showsHorizontalScrollIndicator = false
        if globInd == 0 { videosCollectionView.isScrollEnabled = false }
        
//        videosCollectionView.register(LatestStreamCollectionViewCell.self, forCellWithReuseIdentifier: "bigCell")
//        videosCollectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: "smallCell")
        videosCollectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": videosCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": videosCollectionView]))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch globalIndexSection {
        case 0:
            return 4
        default:
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
//        switch globalIndexSection {
//        case 0:
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bigCell", for: indexPath) as! LatestStreamCollectionViewCell
//        default:
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCell", for: indexPath) as! SmallCollectionViewCell
//        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)//cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch globalIndexSection {
        case 0:
            return CGSize(width: 100, height: 120)
        default:
            return CGSize(width: 70, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch globalIndexSection {
        case 0:
            let spacing = (collectionView.frame.size.width/2 - 100)
            return UIEdgeInsets(top: 10, left: spacing, bottom: 0, right: spacing)

        default:
            return UIEdgeInsetsMake(10, 10, 0, 10)
        }
    }
    
    
}

class VideoCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(){
        backgroundColor = UIColor.red
    }
}
