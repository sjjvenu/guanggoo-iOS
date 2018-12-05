//
//  RightViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/11.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit



class RightViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?;
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    fileprivate var nodesData = NodesDataSource.init(urlString: GUANGGUSITE + "nodes",bInsertAll: true)
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .grouped);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.lightGray;
            _tableView.allowsSelection = true;
            _tableView.separatorStyle = .singleLine;
            
            return _tableView;
        }
    }
    
    //MARK: - function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGray;
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin);
            } else {
                make.bottom.equalTo(self.view);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if self.nodesData.itemList.count == 0 {
            self.nodesData = NodesDataSource.init(urlString: GUANGGUSITE + "nodes",bInsertAll: true)
            self.tableView.reloadData();
        }
    }
    
    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nodesData.itemList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LEFTVIEWCELL" + String(indexPath.row);
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier);
        }
        let item = self.nodesData.itemList[indexPath.row];
        cell!.textLabel?.text = item.name;
        cell!.textLabel?.textAlignment = .center;
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
        cell!.textLabel?.textColor = UIColor.white;
        cell!.backgroundColor = UIColor.clear;
        return cell!;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.vcDelegate ,indexPath.row < self.nodesData.itemList.count {
            appDelegate.drawController?.closeDrawer(animated: true, completion: nil);
            let item = self.nodesData.itemList[indexPath.row];
            let msg = NSMutableDictionary.init();
            msg["MSGTYPE"] = "changeNode";
            msg["PARAM1"] = item;
            delegate.OnPushVC(msg: msg);
        }
    }
}
