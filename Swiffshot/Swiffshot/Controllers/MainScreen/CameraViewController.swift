//
//  CameraViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {

    var previewLayer : AVCaptureVideoPreviewLayer?
    var cameraView : CameraView!
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var filePath : URL?
    var isBackCamera = true
    
    var publisher: PublishViewController!
    var isPublishing: Bool = false
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pathTosave()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cameraView = CameraView.instanceFromNib()
        cameraView.frame = self.view.frame
        self.view.insertSubview(cameraView, at: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPublishing = false
    }


    // MARK: - CAMERA METHODS
    
    func turnOnCamera(){
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if((device as AnyObject).position == AVCaptureDevicePosition.back && isBackCamera) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device back camera found")
                        break
                    }
                } else if((device as AnyObject).position == AVCaptureDevicePosition.front && !isBackCamera) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device front camera found")
                        break
                    }
                }
            }
        }
        previewLayer = beginSession()
        cameraView.screenView.layer.addSublayer(previewLayer!)
        isBackCamera = !isBackCamera
    }
    
    private func pathTosave(){
        let fileName = "Swiffshot.mp4";
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        filePath = documentsURL.appendingPathComponent(fileName)
    }
    
    
    private func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }
            if isBackCamera { device.focusMode = .continuousAutoFocus }
            device.unlockForConfiguration()
        }
        
    }
    
    private func beginSession() -> AVCaptureVideoPreviewLayer {
        configureDevice()
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.beginConfiguration()
            
            if (captureSession.canAddInput(deviceInput) == true) {
                captureSession.addInput(deviceInput)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (captureSession.canAddOutput(dataOutput) == true) {
                captureSession.addOutput(dataOutput)
            }
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.invasivecode.videoQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 128)
        previewLayer?.videoGravity = AVLayerVideoGravityResize
        captureSession.startRunning()
        return previewLayer!
    }
    
    func srartStopRecord(isStart: Bool){
        let videoFileOutput = AVCaptureMovieFileOutput()
        if isStart{
            self.captureSession.addOutput(videoFileOutput)
            
            let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
            videoFileOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
        } else {
            videoFileOutput.stopRecording()
        }
    }
    
    //MARK: STREAMING METHODS
    
    func goStreaming(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "publishView")
        
        let frameSize = self.view.bounds
        publisher = controller as! PublishViewController
        publisher.view.layer.frame = frameSize
        
        self.view.addSubview(publisher.view)
        self.view.sendSubview(toBack: publisher.view)
        
        isPublishing ? publisher.stop() : publisher.start()
        isPublishing = !isPublishing
        isPublishing ? cameraView.changeShootBtn(isStop: true) : cameraView.changeShootBtn(isStop: false)
    }
    
    func removePreviewLayer(){
        previewLayer?.removeFromSuperlayer()
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
        print("capture did finish")
        print(captureOutput)
        print(outputFileURL)
    }
}
