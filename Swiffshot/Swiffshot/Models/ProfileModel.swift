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
    
    func encodeWithCoder(encoder: NSCoder) {
        //Encode properties, other class variables, etc
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.userName, forKey: "userName")
        encoder.encodeObject(self.phoneNumber, forKey: "phoneNumber")
        encoder.encodeObject(self.deviceID, forKey: "deviceID")
        encoder.encodeObject(self.authToken, forKey: "authToken")
        encoder.encodeObject(self.verifyCode, forKey: "verifyCode")
        encoder.encodeObject(self.since, forKey: "since")
        encoder.encodeObject(self.verified, forKey: "verified")
    }
    
    func initWithCoder(decoder: NSCoder) -> ProfileModel {
        //decode properties, other class vars
        self.id = decoder.decodeObjectForKey("id") as! Int
        self.userName = decoder.decodeObjectForKey("userName") as! String
        self.phoneNumber = decoder.decodeObjectForKey("phoneNumber") as! String
        self.deviceID = decoder.decodeObjectForKey("deviceID") as! String
        self.authToken = decoder.decodeObjectForKey("authToken") as! String
        self.verifyCode = decoder.decodeObjectForKey("verifyCode") as! String
        self.since = decoder.decodeObjectForKey("since") as! Int
        self.verified = decoder.decodeObjectForKey("verified") as! Bool
        return self
    }
    
    func saveProfile() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: "currentUser")
        defaults.synchronize()
    }
    
    func loadProfile() -> ProfileModel {
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = defaults.objectForKey("currentUser") as! NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as! ProfileModel
    }
}