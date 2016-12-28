//
//  LoginViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 28.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class LoginViewController: AuthorizationViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viaPhoneBtn: UIButton!
    @IBOutlet weak var viaEmailBtn: UIButton!
    @IBOutlet weak var alertViewBody: UIView!
    
    var userModel = ProfileModel()
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEnabledButton()
        nameTxt.delegate = self
        passwordTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualEffects()
        loginBtn.layer.cornerRadius = 10
    }
    
    //MARK: - VISUAL EFFECTS
    
    private func visualEffects(){
        alertViewBody.layer.cornerRadius = 10
        alertViewBody.layer.borderWidth = 1.0
        alertViewBody.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        viaPhoneBtn.layer.cornerRadius = 10
        viaPhoneBtn.layer.borderWidth = 1.0
        viaPhoneBtn.layer.borderColor = UIColor(colorLiteralRed: 75.0/255.0, green: 253.0/255.0, blue: 252.0/255.0, alpha: 1.0).CGColor
        
        viaEmailBtn.layer.cornerRadius = 10
        viaEmailBtn.layer.borderWidth = 1.0
        viaEmailBtn.layer.borderColor = UIColor(colorLiteralRed: 75.0/255.0, green: 253.0/255.0, blue: 252.0/255.0, alpha: 1.0).CGColor
    }
    
    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        if (nameTxt.text == "" || passwordTxt.text == "") {
            loginBtn.alpha = 0.6
        } else {
            loginBtn.alpha = 1.0
        }
        loginBtn.userInteractionEnabled = (nameTxt.text != "" && passwordTxt.text != "")
    }
    
    //MARK: - IB ACTIONS
    @IBAction func cancelPressed(sender: AnyObject) {
        alertView.hidden = true
    }
    
    @IBAction func viaEmailPressed(sender: AnyObject) {
    }
    
    @IBAction func forgetPressed(sender: AnyObject) {
        alertView.hidden = false
    }
    
    @IBAction func viaPhonePressed(sender: AnyObject) {
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        Defaults.sharedDefaults.userLogged = true
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}

