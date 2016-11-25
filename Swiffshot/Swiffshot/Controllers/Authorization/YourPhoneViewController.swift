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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEnabledButton()
        phoneTxt.delegate = self
    }
    
    func setEnabledButton(){
        phoneTxt.text == "" ? sendCodeBtn.setTitleColor(UIColor.lightGray, for: .normal) : sendCodeBtn.setTitleColor(UIColor.blue, for: .normal)
        sendCodeBtn.isUserInteractionEnabled = phoneTxt.text != ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendCodePressed(_ sender: AnyObject) {
        //TODO: Made api call with phone
        performSegue(withIdentifier: "fromPhoneToCode", sender: self)
    }
}

extension YourPhoneViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setEnabledButton()
    }
}
