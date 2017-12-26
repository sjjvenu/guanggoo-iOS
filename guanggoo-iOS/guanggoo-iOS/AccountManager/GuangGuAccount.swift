//
//  GuangGuAccount.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/21.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit

struct GuangGuUser {
    var userName = "";
    var userImage = "";
    var userLink = "";
}

class GuangGuAccount: NSObject {
    static let shareInstance = GuangGuAccount();
    
    fileprivate var _user:GuangGuUser?
    var user:GuangGuUser? {
        get {
            return _user;
        }
        set {
            dispatch_sync_safely_main_queue {
                _user = newValue;
            }
        }
    }
    
    func isLogin() -> Bool {
        if let count = self.user?.userName.count,count > 0 {
            return true;
        }
        return false;
    }
}
