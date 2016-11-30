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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "LatestStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bigCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        navigationController?.navigationItem.hidesBackButton = false
        title = "CATEGORY NAME"
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ExpandedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bigCell", for: indexPath) as! LatestStreamCollectionViewCell
        cell.fillCell(isOnline: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
}
