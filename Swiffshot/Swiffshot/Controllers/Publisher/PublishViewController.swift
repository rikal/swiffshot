//
//  PublishViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 01.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import R5Streaming

class PublishViewController : R5VideoViewController, R5StreamDelegate{
    
    var config : R5Configuration!
    var stream : R5Stream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config = R5Configuration()
        config.host = Defaults.sharedDefaults.localHost
        config.port = Int32(Defaults.sharedDefaults.hostPort)
        config.contextName = "live"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stop()
    }
    
    func preview(isBackCamera: Bool) {
        let cameraDevice: AVCaptureDevice = isBackCamera ? AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).first as! AVCaptureDevice : AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).last as! AVCaptureDevice
        let camera = R5Camera(device: cameraDevice, andBitRate: 512)
        camera?.orientation = (camera?.orientation)! + 90
        
        let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        let microphone = R5Microphone(device: audioDevice)
        
        let connection = R5Connection(config: config)
        
        stream = R5Stream.init(connection: connection)
        stream.attachVideo(camera)
        stream.attachAudio(microphone)
        
        stream.delegate = self
        self.attachStream(stream)
        self.showPreview(true)
    }
    
    func start() {
        self.showPreview(false)
        stream.publish("red5prostream", type:R5RecordTypeLive)
    }
    
    func stop() {
        stream.stop()
        stream.delegate = nil
    }
    
    func onR5StreamStatus(stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        print("Stream: \(r5_string_for_status(statusCode)) - \(msg!)")
    }
}
