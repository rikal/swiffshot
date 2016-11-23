//
//  FillProfileViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 22.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class FillProfileViewController: AuthorizationViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nickNameTxt: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    
    private let imagePicker = UIImagePickerController()
    private var imageUrl: NSURL!
    
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
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.navigationBar.isTranslucent = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startBtnPressed(_ sender: AnyObject) {
        Defaults.sharedDefaults.userName = nameTxt.text!
        Defaults.sharedDefaults.userNick = nickNameTxt.text!
        Defaults.sharedDefaults.userLogged = true
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        avatarBtn.setBackgroundImage(UIImage(), for: .normal)
        avatarBtn.contentMode = .scaleAspectFit
        avatarBtn.setImage(chosenImage, for: .normal)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FillProfileViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setEnabledButton()
    }
}
