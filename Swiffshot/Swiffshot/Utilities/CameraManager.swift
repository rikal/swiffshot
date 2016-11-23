//
//  CameraManager.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraManager {
    static let sharedCamera = CameraManager()
    
    let captureSession = AVCaptureSession()
    let screenFrame = UIScreen.main.bounds
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    init() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device found")
                        break
                    }
                }
            }
        }
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }
            device.focusMode = .locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() -> AVCaptureVideoPreviewLayer {
        configureDevice()
        var input = AVCaptureDeviceInput()
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            //TODO: error
        }
        
        captureSession.addInput(input)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = screenFrame
        captureSession.startRunning()
        return previewLayer!
    }
}
