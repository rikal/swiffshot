//
//  VerificationViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 26.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class VerificationViewController: AuthorizationViewController {
    var userModel: ProfileModel!
    
    @IBOutlet weak var codeTxt: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem  = getBackButton()
        self.title = ""
        codeTxt.delegate = self
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
        if codeTxt.text == "" {
            continueBtn.backgroundColor = UIColor.lightGrayColor()
        } else {
            continueBtn.backgroundColor = UIColor(colorLiteralRed: 63.0/255.0, green: 220.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        }
        continueBtn.userInteractionEnabled =  codeTxt.text != ""
    }
    
    //MARK: - SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPhoneEmail"{
            let controller = segue.destinationViewController as! PhoneEmailViewController
            controller.userModel = userModel
        }
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func continuePressed(sender: AnyObject) {
        userModel.password = codeTxt.text!
        performSegueWithIdentifier("toPhoneEmail", sender: self)
    }
}

extension VerificationViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}