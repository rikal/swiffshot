//
//  CameraViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var previewLayer : AVCaptureVideoPreviewLayer?
    let camera = CameraManager.sharedCamera
    var cameraView : CameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        cameraView = CameraView.instanceFromNib()
        cameraView.frame = self.view.frame
        self.view.insertSubview(cameraView, at: 0)
    }
    
    func getCameraView() -> CameraView{
        cameraView.frame = self.view.frame
        return cameraView
    }
    

    func turnOnCamera(){
        previewLayer = camera.beginSession()
        self.view.layer.insertSublayer(previewLayer!, at: 0)
    }

}
