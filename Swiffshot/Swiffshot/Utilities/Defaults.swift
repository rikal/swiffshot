//
//  Defaults.swift
//  kixx
//
//  Created by Vladimir Borodko on 12/02/16.
//  Copyright © 2016 kixx.today. All rights reserved.
//

import UIKit


class Defaults {
    static let sharedDefaults = Defaults(defaults: UserDefaults.standard)
    
    private var defaults: UserDefaults
    private var token: NSObjectProtocol
    private enum Keys: String {
        case UserName
        case UserNick
        case UserAvatar
        case UserLogged
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        self.token = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: nil) { _ in
            defaults.synchronize()
        }
        defaults.register(defaults: [
            Keys.UserName.rawValue: "",
            Keys.UserNick.rawValue: "",
            Keys.UserAvatar.rawValue: "",
            Keys.UserLogged.rawValue: false,
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    var userName: String {
        get {
            return defaults.string(forKey: Keys.UserName.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Keys.UserName.rawValue)
            defaults.synchronize()
        }
    }
    
    var userNick: String {
        get {
            return defaults.string(forKey: Keys.UserNick.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Keys.UserNick.rawValue)
            defaults.synchronize()
        }
    }
    
    var userAvatar: String {
        get {
            return defaults.string(forKey: Keys.UserAvatar.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Keys.UserAvatar.rawValue)
            defaults.synchronize()
        }
    }
    
    var userLogged: Bool {
        get {
            return defaults.bool(forKey: Keys.UserLogged.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.UserLogged.rawValue)
            defaults.synchronize()
        }
    }
    
    func reset() {
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
}
