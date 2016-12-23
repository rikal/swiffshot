//
//  BirthdayViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {

    @IBOutlet weak var birthdayTxt: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    var userModel: ProfileModel!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        birthdayTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        continueBtn.layer.cornerRadius = 10
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
        if segue.identifier == "toNickName"{
            
        }
        
    }

    //MARK: - IB ACTIONS
    
    @IBAction func continuePressed(sender: AnyObject) {
        userModel.userBirthday = birthdayTxt.text!
        performSegueWithIdentifier("toNickName", sender: self)
    }
}

extension BirthdayViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}