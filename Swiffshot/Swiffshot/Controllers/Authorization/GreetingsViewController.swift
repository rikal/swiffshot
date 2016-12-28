//
//  GreetingsViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 27.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class GreetingsViewController: AuthorizationViewController {
    var userModel: ProfileModel!
    
    @IBOutlet weak var searchContactLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.title = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        continueBtn.layer.cornerRadius = 10
    }
    
    override func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: - ADD TAP
    
    private func addTapGesture(){
        //add tap gesture recogniser
        let tap = UITapGestureRecognizer(target: self, action: #selector(GreetingsViewController.labelHandleTap(_:)))
        tap.delegate = self
        searchContactLbl.addGestureRecognizer(tap)
    }
    
    @objc(labelHandleTap:)
    private func labelHandleTap(sender: UITapGestureRecognizer){
        print("WILL SEARCH CONTACTS")
    }
    
    //MARK: - SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPhoneEmail"{
            let controller = segue.destinationViewController as! PhoneEmailViewController
            controller.userModel = userModel
        } else if segue.identifier == "toPrivacy"{
            let controller = segue.destinationViewController as! WebViewController
            controller.url = "https://policies.yahoo.com/us/en/yahoo/terms/utos/index.htm"
        }
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func privacyBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("toPrivacy", sender: self)
    }

    @IBAction func continuePressed(sender: AnyObject) {
        Defaults.sharedDefaults.userLogged = true
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
