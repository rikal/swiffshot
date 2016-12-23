//
//  FirstStepSignUpViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class FirstStepSignUpViewController: AuthorizationViewController {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    
    var urlWebView = ""
    var userModel = ProfileModel()
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEnabledButton()
        nameTxt.delegate = self
        lastNameTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signUpBtn.layer.cornerRadius = 10
    }
    
    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        if (nameTxt.text == "" || lastNameTxt.text == "") {
            signUpBtn.alpha = 0.6
        } else {
            signUpBtn.alpha = 1.0
        }
        signUpBtn.userInteractionEnabled = (nameTxt.text != "" && lastNameTxt.text != "")
    }
    
    //MARK: - SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toWebView"{
            let controller = segue.destinationViewController as! WebViewController
            controller.url = urlWebView
        } else if segue.identifier == "toBirthday"{
            let controller = segue.destinationViewController as! BirthdayViewController
            controller.userModel = userModel
        }
    }
    
    //MARK: - IB ACTIONS

    @IBAction func termsPressed(sender: AnyObject) {
        urlWebView = "https://policies.yahoo.com/us/en/yahoo/privacy/index.htm"
        performSegueWithIdentifier("toWebView", sender: self)
    }
    
    @IBAction func privacyPressed(sender: AnyObject) {
        urlWebView = "https://policies.yahoo.com/us/en/yahoo/terms/utos/index.htm"
        performSegueWithIdentifier("toWebView", sender: self)
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        userModel.userName = nameTxt.text!
        userModel.userLastName = lastNameTxt.text!
        performSegueWithIdentifier("toBirthday", sender: self)
    }
}

extension FirstStepSignUpViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
