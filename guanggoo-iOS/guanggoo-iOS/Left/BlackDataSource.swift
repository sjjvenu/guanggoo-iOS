//
//  BlackDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/1/4.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit
import SQLite

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
        guard userName != nil else {
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
}
