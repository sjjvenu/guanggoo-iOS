//
//  BlackDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/1/4.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit
import SQLite
import LeanCloud

class BlackDataSource: NSObject {
    
    static let shareInstance = BlackDataSource();
    
    fileprivate var db:Connection?;
    fileprivate var blackListTable:Table?
    
    var itemList = Set<String>();
    
    override init() {
        super.init();
        
        do {
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
            let path = documentPath[0];
            self.db = try Connection(path + "/" + DBFILE);
            self.blackListTable = Table("user_blacklist");
            
            if let table = self.blackListTable {
                let id = Expression<Int64>("id")
                let userName = Expression<String>("name")
                let blackList = Expression<String?>("blacklist")
                
                if let db = self.db {
                    try db.run(table.create(ifNotExists: true) { t in
                        t.column(id, primaryKey: .autoincrement)
                        t.column(userName)
                        t.column(blackList)
                    })
                }
                
                self.reloadData();
            }
        } catch {
            print("read sqlite file error");
        }
    }
    
    func reloadData() -> Void {
        guard GuangGuAccount.shareInstance.isLogin() == true else {
            return;
        }
        if let table = self.blackListTable {
            
            do {
                let name = Expression<String>("name")
                let blackList = Expression<String?>("blacklist")
                
                let filter = table.filter( name == GuangGuAccount.shareInstance.user!.userName);
                var blackUserList = Set<String>();
                
                if let db = self.db {
                    for item in try db.prepare(filter)
                    {
                        if let blackUser = try item.get(blackList) {
                            blackUserList.insert(blackUser);
                        }
                    }
                }
                self.itemList.removeAll();
                self.itemList = blackUserList;
            } catch {
                print("reload sqlite file error");
            }
        }
    }
    
    func insertData(userName:String?) -> Void {
        guard userName != nil && GuangGuAccount.shareInstance.isLogin() else {
            return ;
        }
        
        if let table = self.blackListTable {
            do {
                let name = Expression<String>("name")
                let blackList = Expression<String?>("blacklist")
                
                if let db = self.db ,self.itemList.contains(userName!) == false {
                    
                    let insert = table.insert(name <- GuangGuAccount.shareInstance.user!.userName, blackList <- userName);
                    try db.run(insert);
                    
                    
                    
                    self.reloadData();
                }
            } catch {
                print("insert sqlite file error");
            }
        }
    }
    
    func deleteData(userName:String?) -> Void {
        guard userName != nil else {
            return ;
        }
        
        if let table = self.blackListTable {
            do {
                let name = Expression<String>("name")
                let blackList = Expression<String?>("blacklist")
                
                if let db = self.db ,self.itemList.contains(userName!) == true {
                    let deleteFilter = table.filter(name == GuangGuAccount.shareInstance.user!.userName).filter(blackList == userName)
                    try db.run(deleteFilter.delete());
                    self.reloadData();
                }
            } catch {
                print("insert sqlite file error");
            }
        }
    }
    
    func upload() -> Void {
        if let currentUser = LCUser.current {
            // 上传当前数据
            currentUser.set("black_list", value: Array(self.itemList))
            
            currentUser.save { result in
                switch result {
                case .success:
                    break;
                case .failure(let error):
                    print(error)
                    break;
                }
            }
        }
    }
    
    func fetchDataFromRemote() -> Bool {
        var returnValue = false;
        if let currentUser = LCUser.current {
            let value = currentUser.get("black_list")
            if let array = value?.arrayValue {
                var blackUserList = Set<String>();
                for item in array {
                    if let userName = item.lcValue.stringValue,userName.count > 0 {
                        self.insertData(userName: userName);
                        blackUserList.insert(userName);
                    }
                }
                self.itemList.removeAll();
                self.itemList = blackUserList;
                returnValue = true;
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLACKLISTTOREFRESH), object: nil);
            }
        }
        return returnValue;
    }
    
    
    func login(userName:String,password:String) -> Void {
        let randomUser = LCUser()
        
        randomUser.username = LCString(userName)
        randomUser.password = LCString(password)
        
        let _ = randomUser.signUp()
        
        LCUser.logIn(username: userName, password: password) { result in
            switch result {
            case .success(let user):
                _ = self.fetchDataFromRemote();
                let sessionToken = user.sessionToken;
                let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = documentDirectory.appendingPathComponent(TOKENFILE)
                do {
                    try sessionToken?.value.write(to: fileURL, atomically: false, encoding: .ascii)
                }
                catch {
                    print("write token to file failed")
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loginWithToken() -> Void {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent(TOKENFILE)
        do {
            let tokenText = try String(contentsOf: fileURL)
            LCUser.logIn(sessionToken: tokenText){ result in
                switch result {
                case .success( _):
                    break
                case .failure(let error):
                    print(error)
                }
            }
        }
        catch {
            print("write token to file failed")
        }
    }

    func deleteTokenFile() -> Void {
        if LCUser.current != nil {
            LCUser.logOut();
        }
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent(TOKENFILE)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
}
