//
//  ExpandedViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 30.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class ExpandedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleLbl: String?
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "LatestStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        //TODO: Send a name from previous screen
        title = "CATEGORY NAME"
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ExpandedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bigCell", forIndexPath: indexPath) as! LatestStreamCollectionViewCell
        cell.fillCell(false)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
}
