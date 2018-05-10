//
//  GuangGuSettings.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/5/10.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit

let keyPrefix =  "me.fin.V2EXSettings."
class GuangGuSettings: NSObject {

    static let sharedInstance = GuangGuSettings()
    fileprivate override init(){
        super.init()
    }
    
    subscript(key:String) -> String? {
        get {
            return UserDefaults.standard.object(forKey: keyPrefix + key) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyPrefix + key )
        }
    }
}
