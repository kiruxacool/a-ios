//
//  RCValues.swift
//  agro24
//
//  Created by Кирилл on 15/11/2018.
//  Copyright © 2018 a24. All rights reserved.
//

import Foundation
import Firebase

class RCValues {
    enum startPage: String {
        case startPage
    }
    
    static let sharedInstance = RCValues()
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
//        let appDefaults: [String: Any?] = [
//            "start_page" : "https://agro24.ru"
//        ]
//        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchCloudValues() {
        // 1
        // WARNING: Don't actually do this in production!
        let fetchDuration: TimeInterval = 61
//        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
//
//            if let error = error {
//                print("Uh-oh. Got an error fetching remote values \(error)")
//                return
//            }
//
//        }
    }
    
    func getStartPage() -> String! {
        let sp = RemoteConfig.remoteConfig()
            .configValue(forKey: "start_page")
            .stringValue ?? "undefined"
        print("RC")
        print(sp)
        return sp
    }
}


