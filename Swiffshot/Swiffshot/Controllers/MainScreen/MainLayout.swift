//
//  MainLayout.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

protocol MainLayoutDelegate {

    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
                        withWidth:CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class MainLayout: UICollectionViewLayout {
    
    // 1
    var delegate: MainLayoutDelegate!
    
    // 2
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    // 3
    private var cache = [UICollectionViewLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }

}
