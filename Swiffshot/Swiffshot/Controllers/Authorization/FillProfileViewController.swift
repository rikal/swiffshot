//
//  FillProfileViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 22.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class FillProfileViewController: AuthorizationViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nickNameTxt: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    
    private let imagePicker = UIImagePickerController()
    private var imageUrl: NSURL!
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTxt.delegate = self
        nickNameTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        visualEffects()
    }
    
    private func visualEffects(){
        avatar.layer.cornerRadius = avatar.frame.size.height/2
        avatar.clipsToBounds = true
    }
    
    //MARK: - CHECK FOR AVALABILITY
    
    func setEnabledButton(){
        (nameTxt.text == "" || nickNameTxt.text == "") ? startBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal) : startBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        startBtn.userInteractionEnabled = (nameTxt.text != "" && nickNameTxt.text != "")
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func chooseAvatarPressed(sender: AnyObject) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        imagePicker.modalPresentationStyle = .OverFullScreen
        imagePicker.navigationBar.translucent = false
        imagePicker.navigationBar.barTintColor = UIColor(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startBtnPressed(sender: AnyObject) {
        Defaults.sharedDefaults.userName = nameTxt.text!
        Defaults.sharedDefaults.userNick = nickNameTxt.text!
        Defaults.sharedDefaults.userLogged = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - IMAGE PICKER METHODS
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        avatar.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension FillProfileViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        self.setEnabledButton()
    }
}
