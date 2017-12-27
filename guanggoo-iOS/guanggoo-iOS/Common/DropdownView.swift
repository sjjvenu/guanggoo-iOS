//
//  DropdownView.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/27.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit

public typealias DidSelectRowHandle = (UITableView,IndexPath) -> Void;

class DropdownView: UITableView ,UITableViewDelegate,UITableViewDataSource{
    
    fileprivate var data:[String]!
    fileprivate var selectedHandle: DidSelectRowHandle?
    init(array:[String],handle:DidSelectRowHandle?) {
        super.init(frame: CGRect.zero, style: .plain);
        if let count = data?.count,count > 0 {
            self.data = [String]();
        }
        else {
            self.data = array;
        }
        //self.separatorStyle = .none;
        self.delegate = self;
        self.dataSource = self;
        self.selectedHandle = handle;
        self.backgroundColor = UIColor.lightGray;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK : - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "DropdownViewCell";
        var cell = self.dequeueReusableCell(withIdentifier: identifer);
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifer);
        }
        cell?.textLabel?.text = self.data[indexPath.row];
        cell?.textLabel?.textColor = UIColor.white;
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12);
        cell?.textLabel?.textAlignment = .center;
        cell?.backgroundColor = UIColor.lightGray;
        cell?.selectionStyle = .none;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let handle = self.selectedHandle {
            handle(tableView,indexPath);
        }
    }
}
