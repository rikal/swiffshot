//
//  YourPhoneViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 22.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class YourPhoneViewController: AuthorizationViewController {

    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEnabledButton()
        phoneTxt.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        phoneTxt.text == "" ? sendCodeBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal) : sendCodeBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        sendCodeBtn.userInteractionEnabled = phoneTxt.text != ""
    }

    //MARK: - IB ACTIONS
    
    @IBAction func sendCodePressed(sender: AnyObject) {
        //TODO: Made api call with phone
        performSegueWithIdentifier("fromPhoneToCode", sender: self)
    }
}

extension YourPhoneViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
