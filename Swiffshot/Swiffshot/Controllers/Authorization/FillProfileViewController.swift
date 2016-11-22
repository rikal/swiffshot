//
//  FillProfileViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 22.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class FillProfileViewController: AuthorizationViewController {
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nickNameTxt: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxt.delegate = self
        nickNameTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        visualEffects()
    }
    
    private func visualEffects(){
        avatarBtn.layer.cornerRadius = avatarBtn.frame.size.height/2
        avatarBtn.clipsToBounds = true
    }
    
    func setEnabledButton(){
        (nameTxt.text == "" || nickNameTxt.text == "") ? startBtn.setTitleColor(UIColor.lightGray, for: .normal) : startBtn.setTitleColor(UIColor.blue, for: .normal)
        startBtn.isUserInteractionEnabled = (nameTxt.text != "" && nickNameTxt.text != "")
    }
    
    @IBAction func avatarBtnPressed(_ sender: AnyObject) {
    }
    
    @IBAction func startBtnPressed(_ sender: AnyObject) {
    }
    
}

extension FillProfileViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setEnabledButton()
    }
}
