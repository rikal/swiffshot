//
//  SubcribeViewController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 06.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit
import R5Streaming

class SubcribeViewController : R5VideoViewController{
    
    var config : R5Configuration!
    var stream : R5Stream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config = R5Configuration()
        config.host = Defaults.sharedDefaults.localHost
        config.port = Int32(Defaults.sharedDefaults.hostPort)
        config.contextName = "live"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stream.stop()
    }
    
    func start() {
        let connection = R5Connection(config: config)
        
        stream = R5Stream(connection: connection)
        self.attach(stream)
        stream.play("red5prostream")
    }
    
    func stop() {
        stream.stop()
    }
}
