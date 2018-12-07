//
//  BlacklistViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/1/4.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit
import Toast_Swift

class BlacklistViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .plain);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.white;
            _tableView.allowsSelection = true;
            
            return _tableView;
        }
    }
    
    //MARK: - function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let yourBackImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin);
            } else {
                make.bottom.equalTo(self.view);
            }
        }
        
        let rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40));
        let uploadButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        uploadButton.setImage(UIImage.init(named: "ic_upload"), for: .normal);
        uploadButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        uploadButton.addTarget(self, action: #selector(BlacklistViewController.uploadClick(sender:)), for: UIControlEvents.touchUpInside);
        rightView.addSubview(uploadButton);
        
        let downloadButton = UIButton.init(frame: CGRect(x: 40, y: 0, width: 40, height: 40));
        downloadButton.setImage(UIImage.init(named: "ic_download"), for: .normal);
        downloadButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        rightView.addSubview(downloadButton);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView);
        downloadButton.addTarget(self, action: #selector(BlacklistViewController.downloadClick(sender:)), for: .touchUpInside);
        
        BlackDataSource.shareInstance.loginWithToken();
        self.view.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "Default", name: "BackColor");
        self.navigationController?.navigationBar.barTintColor = GuangGuColor.sharedInstance.getColor(node: "TOPBAR", name: "BackColor");
        self.navigationController?.navigationBar.isTranslucent = false;
        if let color = GuangGuColor.sharedInstance.getColor(node: "TOPBAR", name: "TxtColor") {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color];
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BlackDataSource.shareInstance.itemList.count;
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
        if indexPath.row < BlackDataSource.shareInstance.itemList.count {
            let array = Array(BlackDataSource.shareInstance.itemList);
            cell!.textLabel?.text = array[indexPath.row];
        }
        cell!.textLabel?.textAlignment = .center;
        cell!.backgroundColor = UIColor.clear;
        cell!.selectionStyle = .none;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row < BlackDataSource.shareInstance.itemList.count {
                let array = Array(BlackDataSource.shareInstance.itemList);
                BlackDataSource.shareInstance.deleteData(userName: array[indexPath.row])
                self.tableView.reloadData();
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLACKLISTTOREFRESH), object: nil);
            }
        }
    }
    
    @objc func uploadClick(sender: UIButton) {
        BlackDataSource.shareInstance.upload(view: self.view)
    }
    
    @objc func downloadClick(sender: UIButton) {
        if BlackDataSource.shareInstance.fetchDataFromRemote() {
            self.view.makeToast("下载成功", duration: 1.0, position: .center)
            self.tableView.reloadData();
        }
    }
}
