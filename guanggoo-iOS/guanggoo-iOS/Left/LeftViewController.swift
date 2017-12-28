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
import Alamofire

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
            _tableView.backgroundColor = UIColor.lightGray;
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
            _userName.backgroundColor = UIColor.clear;
            if GuangGuAccount.shareInstance.isLogin() {
                _userName.setTitle(GuangGuAccount.shareInstance.user!.userName, for: .normal);
            }
            else {
                _userName.setTitle("尚未登录", for: .normal);
            }
            _userName.setTitleColor(UIColor.white, for: .normal);
            _userName.titleLabel?.font = UIFont.systemFont(ofSize: 14);
            _userName.addTarget(self, action: #selector(LeftViewController.userImageClick(sender:)), for: UIControlEvents.touchUpInside);
            return _userName;
        }
    }
    
    fileprivate var _loginButton: UIButton!
    fileprivate var loginButton: UIButton {
        get {
            guard _loginButton == nil else {
                return _loginButton;
            }
            _loginButton = UIButton.init();
            _loginButton.backgroundColor = UIColor.clear;
            _loginButton.setTitleColor(UIColor.white, for: .normal);
            _loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16);
            _loginButton.addTarget(self, action: #selector(LeftViewController.loginClick(sender:)), for: UIControlEvents.touchUpInside);
            return _loginButton;
        }
    }


    //MARK: - function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let backgroundImage = UIImageView.init(image: UIImage.init(named: "left_backgroundImage"));
//        self.view.addSubview(backgroundImage);
//        backgroundImage.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view);
//        }
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        
        self.view.addSubview(self.loginButton);
        self.loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(25);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-40);
            } else {
                make.bottom.equalTo(self.view).offset(-40);
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if GuangGuAccount.shareInstance.isLogin() && GuangGuAccount.shareInstance.user!.userImage.count > 0{
            self.userImage.sd_setBackgroundImage(with: URL.init(string: GuangGuAccount.shareInstance.user!.userImage), for: .normal, completed: nil);
            self.userName.setTitle(GuangGuAccount.shareInstance.user!.userName, for: .normal);
            self.loginButton.setTitle("退出", for: .normal);
        }
        else {
            self.userImage.setBackgroundImage(UIImage.init(named: "default_head_photo"), for: .normal)
            self.userName.setTitle("尚未登录", for: .normal);
            self.loginButton.setTitle("登录", for: .normal);
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
                cell!.textLabel?.text = "我的主题";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 4:
                cell!.textLabel?.text = "我的回复";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 5:
                cell!.textLabel?.text = "我的收藏";
                cell!.textLabel?.textColor = UIColor.white;
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            default:
                break;
            }
        }
        cell!.backgroundColor = UIColor.clear;
        cell!.selectionStyle = .none;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return;
        }
        if GuangGuAccount.shareInstance.isLogin() {
            appDelegate.drawController?.closeDrawer(animated: false, completion: nil);
            switch indexPath.row {
            case 0:
                break;
            case 1:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    if let delegate = self.vcDelegate {
                        let vc = UserInfoViewController.init(urlString: GUANGGUSITE + userLink);
                        vc.vcDelegate = self.vcDelegate;
                        let msg = NSMutableDictionary.init();
                        msg["MSGTYPE"] = "PushViewController";
                        msg["PARAM1"] = vc;
                        delegate.OnPushVC(msg: msg);
                    }
                }
                break;
            case 2:
                let vc = NotificationViewController.init(urlString: GUANGGUSITE + "notifications");
                vc.vcDelegate = self.vcDelegate;
                if let delegate = self.vcDelegate {
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "PushViewController";
                    msg["PARAM1"] = vc;
                    delegate.OnPushVC(msg: msg);
                }
                break;
            case 3:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    if let delegate = self.vcDelegate {
                        let msg = NSMutableDictionary.init();
                        msg["MSGTYPE"] = "PushViewController";
                        let vc = CenterViewController.init(urlString: GUANGGUSITE + userLink + "/topics");
                        vc.title = GuangGuAccount.shareInstance.user!.userName + "的主题";
                        msg["PARAM1"] = vc;
                        delegate.OnPushVC(msg: msg);
                    }
                }
                break;
            case 4:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    if let delegate = self.vcDelegate {
                        let msg = NSMutableDictionary.init();
                        msg["MSGTYPE"] = "PushViewController";
                        let vc = UserCommentViewController.init(urlString: GUANGGUSITE + userLink + "/replies")
                        vc.title = GuangGuAccount.shareInstance.user!.userName + "的回复";
                        vc.vcDelegate = self.vcDelegate;
                        msg["PARAM1"] = vc;
                        delegate.OnPushVC(msg: msg);
                    }
                }
                break;
            case 5:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    if let delegate = self.vcDelegate {
                        let msg = NSMutableDictionary.init();
                        msg["MSGTYPE"] = "PushViewController";
                        let vc = CenterViewController.init(urlString: GUANGGUSITE + userLink + "/favorites");
                        vc.needRefreshInAppear = true;
                        vc.title = GuangGuAccount.shareInstance.user!.userName + "的收藏";
                        msg["PARAM1"] = vc;
                        delegate.OnPushVC(msg: msg);
                    }
                }
                break;
            default:
                break;
            }
        }
        else
        {
            pushLoginViewController();
        }
    }
    
    //MARK: - event
    @objc func userImageClick(sender:UIButton) -> Void {
        if GuangGuAccount.shareInstance.isLogin() {
            appDelegate.drawController?.closeDrawer(animated: false, completion: nil);
            if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                if userLink[userLink.startIndex] == "/" {
                    userLink.removeFirst();
                }
                if let delegate = self.vcDelegate {
                    let vc = UserInfoViewController.init(urlString: GUANGGUSITE + userLink);
                    vc.vcDelegate = self.vcDelegate;
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "PushViewController";
                    msg["PARAM1"] = vc;
                    delegate.OnPushVC(msg: msg);
                }
            }
        }
        else {
            pushLoginViewController();
        }
    }
    
    @objc func loginClick(sender:UIButton) -> Void {
        if !GuangGuAccount.shareInstance.isLogin() {
            pushLoginViewController();
        }
        else
        {
            Alamofire.request(GUANGGUSITE + "logout").responseString { (response) in
                self.appDelegate.drawController?.closeDrawer(animated: false, completion: nil);
                GuangGuAccount.shareInstance.cookie = "";
                if let delegate = self.vcDelegate {
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "reloadData";
                    delegate.OnPushVC(msg: msg);
                }
            }
        }
    }
    
    func pushLoginViewController() -> Void {
        if !GuangGuAccount.shareInstance.isLogin() {
            appDelegate.drawController?.closeDrawer(animated: false, completion: nil);
            let vc = LoginViewController.init(completion: { [weak self](loginSuccess) in
                if loginSuccess {
                    if let delegate = self?.vcDelegate {
                        let msg = NSMutableDictionary.init();
                        msg["MSGTYPE"] = "reloadData";
                        self?.dismiss(animated: true, completion: nil);
                        delegate.OnPushVC(msg: msg);
                    }
                }
            });
            vc.vcDelegate = self.vcDelegate;
            self.present(vc, animated: true, completion: nil);
        }
    }
}
