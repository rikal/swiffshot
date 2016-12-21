//
//  CategoryCell.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 29.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: class {
    func moveToStream(isonline: Bool)
    func moveToCamera()
}

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    weak var delegate: CategoryCellDelegate?
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
        layout.scrollDirection = .Horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }()
    
    func setupViews(globInd: Int){
        globalIndexSection = globInd
        addSubview(videosCollectionView)
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        videosCollectionView.backgroundColor = UIColor.clearColor()
        videosCollectionView.showsHorizontalScrollIndicator = false
        if globInd == 0 { videosCollectionView.scrollEnabled = false }

        videosCollectionView.registerNib(UINib(nibName: "LatestStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCell")
        videosCollectionView.registerNib(UINib(nibName: "SmallCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "smallCell")
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": videosCollectionView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": videosCollectionView]))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.handleTap(_:)))
        tap.delegate = self
        videosCollectionView.backgroundView = UIView()
        videosCollectionView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
            delegate?.moveToCamera()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch globalIndexSection {
        case 0:
            return 4
        default:
            return 9
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch globalIndexSection {
        case 0:
            let bigcell = collectionView.dequeueReusableCellWithReuseIdentifier("bigCell", forIndexPath: indexPath) as! LatestStreamCollectionViewCell
            indexPath.row == 0 ? bigcell.fillCell(true) : bigcell.fillCell(false)
            cell = bigcell
        default:
            let smallcell = collectionView.dequeueReusableCellWithReuseIdentifier("smallCell", forIndexPath: indexPath) as! SmallCollectionViewCell
            indexPath.row == 0 ? smallcell.fillCell(true) : smallcell.fillCell(false)
            cell = smallcell
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: NSIndexPath) -> CGSize {
        switch globalIndexSection {
        case 0:
            return CGSize(width: 100, height: 120)
        default:
            return CGSize(width: 70, height: 90)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch globalIndexSection {
        case 0:
            let spacing = (collectionView.frame.size.width/2 - 100)
            return UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)

        default:
            return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        var isOnline = false
        if (cell?.isKindOfClass(LatestStreamCollectionViewCell.self))!{
            isOnline = (cell as! LatestStreamCollectionViewCell).isOnlineCell
        } else {
            isOnline = (cell as! SmallCollectionViewCell).isOnlineCell
        }
        delegate?.moveToStream(isOnline)
    }
}
