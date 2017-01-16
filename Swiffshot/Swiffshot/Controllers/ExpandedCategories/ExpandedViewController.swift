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
    @IBOutlet weak var addGroupBtn: UIButton!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    
    var titleLbl: String?
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "LatestStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBarHidden = true
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        addGroupBtn.layer.borderWidth = 1.0
        addGroupBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        addFriendBtn.layer.borderWidth = 1.0
        addFriendBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        addGroupBtn.layer.cornerRadius = 5.0
        addFriendBtn.layer.cornerRadius = 5.0
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addGroupBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func addFriendBtnPressed(sender: AnyObject) {
    }

    @IBAction func profilePressed(sender: AnyObject) {
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
