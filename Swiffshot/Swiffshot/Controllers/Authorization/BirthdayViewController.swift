//
//  BirthdayViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class BirthdayViewController: AuthorizationViewController {

    @IBOutlet weak var birthdayTxt: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    var userModel: ProfileModel!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem  = getBackButton()
        self.title = ""
        birthdayTxt.delegate = self
        setEnabledButton()
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
    
    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        if birthdayTxt.text == "" {
            continueBtn.alpha = 0.6
        } else {
            continueBtn.alpha = 1.0
        }
        continueBtn.userInteractionEnabled =  birthdayTxt.text != ""
    }
    
    //MARK: - SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toUserName"{
            let controller = segue.destinationViewController as! UserNameViewController
            controller.userModel = userModel
        }
        
    }

    //MARK: - IB ACTIONS
    
    @IBAction func continuePressed(sender: AnyObject) {
        userModel.userBirthday = birthdayTxt.text!
        performSegueWithIdentifier("toUserName", sender: self)
    }
}

extension BirthdayViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}