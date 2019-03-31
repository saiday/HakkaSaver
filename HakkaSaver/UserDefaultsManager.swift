//
//  Preferences.swift
//  HakkaSaver
//
//  Created by saiday on 2019/3/5.
//  Copyright © 2019 saiday. All rights reserved.
//

import Foundation
import ScreenSaver

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private struct Keys {
        static let appName = "saiday.HakkaSaver"
        static let blurRadius = "blurRadius"
    }
    
    private init() {
        let defaultValues: [String: Any] = [Keys.blurRadius: 0.0]
        userDefaults.register(defaults: defaultValues)
    }
    
    private lazy var userDefaults: UserDefaults = {
        guard let screenSaverUserDefaults = ScreenSaverDefaults(forModuleWithName: Keys.appName) else {
            let message = "Cannot load ScreenSaverDefaults for \(Keys.appName)"
            return UserDefaults()
        }
        
        return screenSaverUserDefaults
    }()
    
    var blurRadius: Double {
        get {
            return userDefaults.double(forKey: Keys.blurRadius)
        }
        
        set(new) {
            userDefaults.set(new, forKey: Keys.blurRadius)
            userDefaults.synchronize()
        }
    }
}
