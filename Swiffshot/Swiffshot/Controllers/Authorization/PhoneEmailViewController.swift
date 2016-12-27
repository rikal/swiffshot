//
//  PhoneEmailViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 26.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class PhoneEmailViewController: AuthorizationViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var phoneEmailTxt: UITextField!
    @IBOutlet weak var textFieldCaption: UILabel!
    @IBOutlet weak var switchTypeOfSignUp: UIButton!
    
    var userModel: ProfileModel!
    var isPhone = true
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem  = getBackButton()
        self.title = ""
        phoneEmailTxt.delegate = self
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
        if phoneEmailTxt.text == "" {
            continueBtn.backgroundColor = UIColor.lightGrayColor()
        } else {
            continueBtn.backgroundColor = UIColor(colorLiteralRed: 63.0/255.0, green: 220.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        }
        continueBtn.userInteractionEnabled =  phoneEmailTxt.text != ""
    }
    
    //MARK: - SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toVerify"{
            let controller = segue.destinationViewController as! VerificationViewController
            controller.userModel = userModel
        }
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func switchTypeOfSigupPressed(sender: AnyObject) {
        if isPhone{
            switchTypeOfSignUp.setTitle("Sign up with phone instead", forState: .Normal)
            textFieldCaption.text = "E-MAIL"
            phoneEmailTxt.text = ""
            phoneEmailTxt.keyboardType = .EmailAddress
        } else {
            switchTypeOfSignUp.setTitle("Sign up with email instead", forState: .Normal)
            textFieldCaption.text = "MOBILE NUMBER"
            phoneEmailTxt.text = "US +1"
            phoneEmailTxt.keyboardType = .PhonePad
        }
        isPhone = !isPhone
    }
    
    @IBAction func continuePressed(sender: AnyObject) {
        if isPhone{
            userModel.phoneNumber = phoneEmailTxt.text!
        } else {
            userModel.email = phoneEmailTxt.text!
        }
        
        ApiManager.shared.getUserWithId(userModel, success: { (result) in
            print(result.id)
            ApiManager.shared.getCodeToVerify("\(result.id)", success: { (result) in
                if result == "Ok"{
                    self.performSegueWithIdentifier("toVerify", sender: self)
                }
            }, failure: { (error) in
                    print(error.debugDescription)
            })
        }) { (error) in
            print(error?.description)
        }
        //TODO: REMOVE
        self.performSegueWithIdentifier("toVerify", sender: self)
    }
}

extension PhoneEmailViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
