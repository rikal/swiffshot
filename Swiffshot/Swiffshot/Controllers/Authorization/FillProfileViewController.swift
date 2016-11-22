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
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.navigationBar.isTranslucent = false
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
        present(imagePicker, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) { () -> Void in
            self.imagePicker.topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        }
    }
    
    @IBAction func startBtnPressed(_ sender: AnyObject) {
        Defaults.sharedDefaults.userName = nameTxt.text!
        Defaults.sharedDefaults.userNick = nickNameTxt.text!
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        avatarBtn.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
        avatarBtn.setImage(info[UIImagePickerControllerOriginalImage] as? UIImage, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    private func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController.navigationItem.backBarButtonItem = backItem
        navigationController.navigationBar.isTranslucent = false
    }
    
}

extension FillProfileViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setEnabledButton()
    }
}
