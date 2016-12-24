//
//  PasswordViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 24.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class PasswordViewController: AuthorizationViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    
    var userModel: ProfileModel!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem  = getBackButton()
        self.title = ""
        passwordTxt.delegate = self
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
        if passwordTxt.text == "" {
            continueBtn.backgroundColor = UIColor.lightGrayColor()
        } else {
            continueBtn.backgroundColor = UIColor(colorLiteralRed: 63.0/255.0, green: 220.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        }
        continueBtn.userInteractionEnabled =  passwordTxt.text != ""
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
    }
}

extension PasswordViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
