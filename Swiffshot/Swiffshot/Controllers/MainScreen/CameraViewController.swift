//
//  CameraViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 25.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var previewLayer : AVCaptureVideoPreviewLayer?
    var cameraView : CameraView!
    var captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var filePath : NSURL?
    var isBackCamera = true
    var publisher: PublishViewController!
    var isPublishing: Bool = false
    var isOnline: Bool = false
    var playerViewController = PlayerViewController()
    
    let videoFileOutput = AVCaptureMovieFileOutput()
    
    //MARK: - SYSTEMS METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pathTosave()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        cameraView = CameraView.instanceFromNib()
        cameraView.frame = self.view.frame
        self.view.insertSubview(cameraView, atIndex: 0)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        isPublishing = false
    }


    // MARK: - CAMERA METHODS
    
    func turnOnCamera(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
            let devices = AVCaptureDevice.devices()
            for device in devices! {
                if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                    if((device as AnyObject).position == AVCaptureDevicePosition.Back && self.isBackCamera) {
                        self.captureDevice = device as? AVCaptureDevice
                        if self.captureDevice != nil {
                            print("Capture device back camera found")
                            break
                        }
                    } else if((device as AnyObject).position == AVCaptureDevicePosition.Front && !self.isBackCamera) {
                        self.captureDevice = device as? AVCaptureDevice
                        if self.captureDevice != nil {
                            print("Capture device front camera found")
                            break
                        }
                    }
                }
            }
            self.previewLayer = self.beginSession()
            dispatch_async(dispatch_get_main_queue(), {
                self.cameraView.screenView.layer.addSublayer(self.previewLayer!)
                })
            })

    }
    
    private func pathTosave(){
        let fileName = "Swiffshot.mp4"
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        filePath = documentsURL.URLByAppendingPathComponent(fileName)
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
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(unsignedInt: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (captureSession.canAddOutput(dataOutput) == true) {
                captureSession.addOutput(dataOutput)
            }
            captureSession.commitConfiguration()
            
            let queue = dispatch_queue_create("com.invasivecode.videoQueue", nil)
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = self.view.frame
        previewLayer?.videoGravity = AVLayerVideoGravityResize
        captureSession.startRunning()
        return previewLayer!
    }
    
    private func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }
            if isBackCamera { device.focusMode = .ContinuousAutoFocus }
            device.unlockForConfiguration()
        }
    }
    
    func srartStopRecord(isStart: Bool){
        if isStart{
            self.captureSession.addOutput(videoFileOutput)
            
            let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
            videoFileOutput.startRecordingToOutputFileURL(filePath, recordingDelegate: recordingDelegate)
        } else {
            if isOnline{
                publisher.stop()
                isOnline = false
            } else {
                videoFileOutput.stopRecording()
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(self.filePath!)
                }) { saved, error in
                    if saved {
                        print("SAVED")
                    } else if (error != nil) {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    //MARK: STREAMING METHODS
    
    func stopStreaming(){
        publisher.stop()
    }
    
    func goStreaming(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("publishView")
        
        let frameSize = cameraView.screenView.bounds
        publisher = controller as! PublishViewController
        publisher.view.layer.frame = frameSize
        publisher.preview(isBackCamera)
        
        cameraView.screenView.addSubview(publisher.view)
        
        isPublishing ? publisher.stop() : publisher.start()
        isPublishing = !isPublishing
        isOnline = true
    }
    
    func removePreviewLayer(){
        captureSession = AVCaptureSession()
        previewLayer?.removeFromSuperlayer()
    }
    
    //MARK: - LOAD VIDEO
    
    func loadVideo(){
        removePreviewLayer()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        imagePicker.modalPresentationStyle = .OverFullScreen
        imagePicker.navigationBar.translucent = false
        imagePicker.navigationBar.barTintColor = UIColor(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - IMAGE PICKER METHODS
    
    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == "public.movie"{
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            playerViewController.createVideoPlayer(videoURL)
            showPlayer(playerViewController)
        }
    }
    
    func showPlayer(playerController: PlayerViewController){
        self.presentViewController(playerController, animated: true){
            print("PLAYING")
            dispatch_async(dispatch_get_main_queue()) {
                playerController.player?.play()
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: CATURE DELEGATE METHODS
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!){
        print("capture did finish")
        print(captureOutput)
        print(outputFileURL)
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!){
        print("capture output: started recording to \(fileURL)")
    }
}
