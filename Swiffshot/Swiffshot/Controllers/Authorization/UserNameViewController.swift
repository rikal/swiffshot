//
//  UserNameViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 24.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class UserNameViewController: AuthorizationViewController {
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    var userModel: ProfileModel!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxt.delegate = self
        userNameTxt.autocapitalizationType = .Sentences
        setEnabledButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem  = getBackButton()
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
    
    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        if userNameTxt.text == "" {
            continueBtn.backgroundColor = UIColor.lightGrayColor()
        } else {
            continueBtn.backgroundColor = UIColor(colorLiteralRed: 63.0/255.0, green: 220.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        }
        continueBtn.userInteractionEnabled =  userNameTxt.text != ""
    }
    
    //MARK: - SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPassword"{
            let controller = segue.destinationViewController as! PasswordViewController
            controller.userModel = userModel
        }
    }
    
    //MARK: - IB ACTIONS
    @IBAction func continuePressed(sender: AnyObject) {
        userModel.userNickName = userNameTxt.text!
        performSegueWithIdentifier("toPassword", sender: self)
    }
}

extension UserNameViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
