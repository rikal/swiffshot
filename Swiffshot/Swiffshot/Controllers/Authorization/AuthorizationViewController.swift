//
//  AuthorizationViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 22.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBarHidden = true
        navigationController!.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true
        navigationController!.view.backgroundColor = UIColor.clearColor()
        
        addTapGesture()
        title = "SwiffShot"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func addTapGesture(){
        //add tap gesture recogniser
        let tap = UITapGestureRecognizer(target: self, action: #selector(AuthorizationViewController.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func getBackButton() -> UIBarButtonItem{
        let myBackButton:UIButton = UIButton(type: .Custom) as UIButton
        myBackButton.setImage(UIImage(named: "BackBtn"), forState: .Normal)
        myBackButton.addTarget(self, action: #selector(AuthorizationViewController.popToRoot(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.frame = CGRectMake(0, 0, 20, 30)
        return UIBarButtonItem(customView: myBackButton)
    }
    
    func popToRoot(sender:UIBarButtonItem){
        navigationController!.popViewControllerAnimated(true)
    }
}
