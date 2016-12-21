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
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTxt.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        codeTxt.text == "" ? checkBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal) : checkBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        checkBtn.userInteractionEnabled = codeTxt.text != ""
    }
    
    private func showError(){
        errorTopViewConstraint.constant = 64
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(3.0 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            {
                self.errorTopViewConstraint.constant = -80
                self.view.layoutIfNeeded()
            }
        )

    }
    
    @IBAction func checkBtnPressed(sender: AnyObject) {
        //TODO: Made api call with code
        // ======= DELETE ====== //
        
        if codeTxt.text == "0000"{
            showError()
        } else {
            performSegueWithIdentifier("fromCodeToProfile", sender: self)
        }
        
        // ======= DELETE ====== //
        
        
    }
}

extension CheckCodeViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
