//
//  WebViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!, cachePolicy: .ReloadRevalidatingCacheData, timeoutInterval: 10))
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
