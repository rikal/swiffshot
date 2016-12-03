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
        self.preview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stop()
    }
    
    func preview() {
        let cameraDevice: AVCaptureDevice = AVCaptureDevice.devices(withMediaType:AVMediaTypeVideo).last as! AVCaptureDevice
        let camera = R5Camera(device: cameraDevice, andBitRate: 512)
        
        let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        let microphone = R5Microphone(device: audioDevice)
        
        let connection = R5Connection(config: config)
        
        stream = R5Stream.init(connection: connection)
        stream.attachVideo(camera)
        stream.attachAudio(microphone)
        
        stream.delegate = self
        self.attach(stream)
        self.showPreview(true)
    }
    
    func start() {
        self.showPreview(false)
        stream.publish("red5prostream", type:R5RecordTypeLive)
    }
    
    func stop() {
        stream.stop()
        stream.delegate = nil
        self.preview()
    }
    
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        print("Stream: \(r5_string_for_status(statusCode)) - \(msg!)")
    }
}
