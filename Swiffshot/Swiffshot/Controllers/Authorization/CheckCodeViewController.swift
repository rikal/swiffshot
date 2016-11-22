//
//  CheckCodeViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 22.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class CheckCodeViewController: AuthorizationViewController {

    @IBOutlet weak var enterCodeLbl: UILabel!
    @IBOutlet weak var codeTxt: UITextField!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorBgView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var errorTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttomBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTxt.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setEnabledButton(){
        codeTxt.text == "" ? checkBtn.setTitleColor(UIColor.lightGray, for: .normal) : checkBtn.setTitleColor(UIColor.blue, for: .normal)
        checkBtn.isUserInteractionEnabled = codeTxt.text != ""
    }
    
    private func showError(){
        errorTopViewConstraint.constant = 64
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.errorTopViewConstraint.constant = -80
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideError(){
        
    }
    
    @IBAction func checkBtnPressed(_ sender: AnyObject) {
        //TODO: Made api call with code
        // ======= DELETE ====== //
        
        if codeTxt.text == "0000"{
            showError()
        } else {
            performSegue(withIdentifier: "fromCodeToProfile", sender: self)
        }
        
        // ======= DELETE ====== //
        
        
    }
}

extension CheckCodeViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setEnabledButton()
    }
}
