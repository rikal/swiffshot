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
        addTapGesture()
        self.title = "SwiffShot"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func addTapGesture(){
        //add tap gesture recogniser
        let tap = UITapGestureRecognizer(target: self, action: #selector(AuthorizationViewController.handleTap(sender:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    @objc(handleTap:)
    private func handleTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}
