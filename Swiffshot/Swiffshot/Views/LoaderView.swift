//
//  LoaderView.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 10.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    static let shared = LoaderView.instanceFromNib()
    
    class func instanceFromNib() -> LoaderView {
        return UINib(nibName: "LoaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! LoaderView
    }
    
    func showLoaderView(view: UIView){
        self.frame = view.frame
        view.addSubview(self)
        self.loader.startAnimating()
    }
    
    func hideLoaderView(){
        self.loader.stopAnimating()
        self.removeFromSuperview()
    }

}
