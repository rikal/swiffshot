//
//  Defaults.swift
//  kixx
//
//  Created by Vladimir Borodko on 12/02/16.
//  Copyright © 2016 kixx.today. All rights reserved.
//

import UIKit


class Defaults {
    static let sharedDefaults = Defaults(defaults: NSUserDefaults.standardUserDefaults())
    
    private var defaults: NSUserDefaults
    private var token: NSObjectProtocol
    private enum Keys: String {
        case UserName //TODO: Replace with Model
        case UserNick //TODO: Replace with Model
        case UserAvatar //TODO: Replace with Model
        case UserLogged
        case LocalHost
        case HostPort
    }
    
    init(defaults: NSUserDefaults) {
        self.defaults = defaults
        self.token = NSNotificationCenter.defaultCenter().addObserverForName("UIApplicationDidEnterBackground", object: nil, queue: nil) { _ in
            defaults.synchronize()
        }
        defaults.registerDefaults( [
            Keys.LocalHost.rawValue: "54.191.86.179",
            Keys.HostPort.rawValue: 8554,
            Keys.UserLogged.rawValue: false,
        ])
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(token)
    }
    
    var userName: String {
        get {
            return defaults.stringForKey(Keys.UserName.rawValue) ?? ""
        }
        set {
            defaults.setObject(newValue, forKey: Keys.UserName.rawValue)
            defaults.synchronize()
        }
    }
    
    var userNick: String {
        get {
            return defaults.stringForKey(Keys.UserNick.rawValue) ?? ""
        }
        set {
            defaults.setObject(newValue, forKey: Keys.UserNick.rawValue)
            defaults.synchronize()
        }
    }
    
    var userAvatar: String {
        get {
            return defaults.stringForKey(Keys.UserAvatar.rawValue) ?? ""
        }
        set {
            defaults.setObject(newValue, forKey: Keys.UserAvatar.rawValue)
            defaults.synchronize()
        }
    }
    
    var userLogged: Bool {
        get {
            return defaults.boolForKey(Keys.UserLogged.rawValue)
        }
        set {
            defaults.setBool(newValue, forKey: Keys.UserLogged.rawValue)
            defaults.synchronize()
        }
    }
    
    var localHost: String {
        get {
            return defaults.stringForKey(Keys.LocalHost.rawValue)!
        }
    }
    
    var hostPort: Int {
        get {
            return defaults.integerForKey(Keys.HostPort.rawValue)
        }
    }
    
    func reset() {
        defaults.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        defaults.synchronize()
    }
}
