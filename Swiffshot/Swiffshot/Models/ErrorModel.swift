//
//  ErrorModel.swift
//  underdog
//
//  Created by Дмитрий on 20.05.16.
//  Copyright © 2016 underdog. All rights reserved.
//

import Foundation

class ErrorModel: NSObject {
    var code : Int = 0
    var text : String = ""
    
    convenience required init(json: [String:AnyObject]) {
        self.init()
        if let code = json["code"] as? Int { self.code = code }
        if let text = json["text"] as? String { self.text = text }
    }
}
