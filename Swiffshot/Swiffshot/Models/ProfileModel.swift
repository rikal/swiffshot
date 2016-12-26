//
//  ProfileModel.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.12.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import Foundation

class ProfileModel: NSObject {
    var id: Int = 0
    var userName : String = ""
    var userLastName : String = ""
    var userNickName: String = ""
    var userBirthday : String = ""
    var phoneNumber: String = ""
    var deviceID: String = ""
    var authToken: String = ""
    var verifyCode:  String = ""
    var since: Int = 0
    var verified: Bool = false
    var password: String = ""
    var email: String = ""
    //contacts: Contact[]
    
    var text : String = ""
    
    convenience required init(json: [String:AnyObject]) {
        self.init()
        if let id = json["id"] as? Int { self.id = id }
        if let userName = json["userName"] as? String { self.userName = userName }
        if let phoneNumber = json["phoneNumber"] as? String { self.phoneNumber = phoneNumber }
        if let deviceID = json["deviceID"] as? String { self.deviceID = deviceID }
        if let authToken = json["authToken"] as? String { self.authToken = authToken }
        if let verifyCode = json["verifyCode"] as? String { self.verifyCode = verifyCode }
        if let since = json["since"] as? Int { self.since = since }
        if let verified = json["verified"] as? Bool { self.verified = verified }
    }
}