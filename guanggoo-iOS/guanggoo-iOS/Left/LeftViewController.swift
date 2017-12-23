//
//  LeftViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/11.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class LeftViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .grouped);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.clear;
            _tableView.allowsSelection = true;
            _tableView.separatorStyle = .none;
            
            return _tableView;
        }
    }
    
    fileprivate var _userImage: UIButton!
    fileprivate var userImage: UIButton {
        get {
            guard _userImage == nil else {
                return _userImage;
            }
            _userImage = UIButton.init();
            _userImage.backgroundColor = UIColor.clear;
            if GuangGuAccount.shareInstance.isLogin(), GuangGuAccount.shareInstance.user!.userImage.count > 0{
                _userImage.sd_setBackgroundImage(with: URL.init(string: GuangGuAccount.shareInstance.user!.userImage), for: .normal, completed: nil);
            }
            else {
                _userImage.setBackgroundImage(UIImage.init(named: "default_head_photo"), for: .normal)
            }
            _userImage.addTarget(self, action: #selector(LeftViewController.userImageClick(sender:)), for: UIControlEvents.touchUpInside);
            return _userImage;
        }
    }
    
    fileprivate var _userName: UIButton!
    fileprivate var userName: UIButton {
        get {
            guard _userName == nil else {
                return _userName;
            }
            _userName = UIButton.init();
            _userImage.backgroundColor = UIColor.clear;
            if GuangGuAccount.shareInstance.isLogin() {
                _userName.setTitle(GuangGuAccount.shareInstance.user!.userName, for: .normal);
            }
            else {
                _userName.setTitle("尚未登录", for: .normal);
            }
            _userImage.setTitleColor(UIColor.black, for: .normal);
            _userName.titleLabel?.font = UIFont.systemFont(ofSize: 14);
            _userImage.addTarget(self, action: #selector(LeftViewController.userImageClick(sender:)), for: UIControlEvents.touchUpInside);
            return _userName;
        }
    }

    //MARK: - function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView.init(image: UIImage.init(named: "left_backgroundImage"));
        self.view.addSubview(backgroundImage);
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if GuangGuAccount.shareInstance.isLogin(), GuangGuAccount.shareInstance.user!.userImage.count > 0{
            self.userImage.sd_setBackgroundImage(with: URL.init(string: GuangGuAccount.shareInstance.user!.userImage), for: .normal, completed: nil);
            self.userName.setTitle(GuangGuAccount.shareInstance.user!.userName, for: .normal);
        }
    }
    
    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130;
        }
        return 44;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LEFTVIEWCELL" + String(indexPath.row);
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = LeftViewTableViewCell.init(style: .default, reuseIdentifier: identifier);
            switch indexPath.row {
            case 0:
                let userImageWidth = 80;
                cell!.contentView.addSubview(self.userImage);
                self.userImage.snp.makeConstraints({ (make) in
                    make.top.equalTo(cell!.contentView).offset(20);
                    make.centerX.equalTo(cell!.contentView);
                    make.width.height.equalTo(userImageWidth);
                })
                cell!.contentView.addSubview(self.userName);
                self.userName.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.userImage.snp.bottom).offset(8);
                    make.centerX.equalTo(cell!.contentView);
                    make.width.equalTo(200);
                    make.height.equalTo(20);
                })
                break;
            case 1:
                cell!.textLabel?.text = "个人中心";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 2:
                cell!.textLabel?.text = "我的消息";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 3:
                cell!.textLabel?.text = "我的收藏";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 4:
                cell!.textLabel?.text = "我的主题";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 5:
                cell!.textLabel?.text = "我的回复";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            default:
                break;
            }
        }
        cell!.backgroundColor = UIColor.clear;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushLoginViewController();
    }
    
    //MARK: - event
    @objc func userImageClick(sender:UIButton) -> Void {
        pushLoginViewController();
    }
    
    func pushLoginViewController() -> Void {
        if !GuangGuAccount.shareInstance.isLogin() {
            appDelegate.drawController?.closeDrawer(animated: false, completion: nil);
            let vc = LoginViewController.init(completion: { [weak self](loginSuccess) in
                if let delegate = self?.vcDelegate {
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "reloadData";
                    self?.dismiss(animated: true, completion: nil);
                    delegate.OnPushVC(msg: msg);
                }
            });
            vc.vcDelegate = self.vcDelegate;
            self.present(vc, animated: true, completion: nil);
        }
    }
}
