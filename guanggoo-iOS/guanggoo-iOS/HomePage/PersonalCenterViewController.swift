//
//  PersonalCenterViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/12/6.
//  Copyright © 2018 tdx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import Alamofire

class PersonalCenterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,GuangGuVCDelegate{
    //MARK: - property
    fileprivate var helper:GuangGuHelpDelegate?;
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .grouped);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "BackColor");
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
            _userName.titleLabel?.font = UIFont.systemFont(ofSize: 16);
            _userName.addTarget(self, action: #selector(LeftViewController.userImageClick(sender:)), for: UIControlEvents.touchUpInside);
            _userName.contentHorizontalAlignment = .left;
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
            _loginButton.setTitleColor(GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "CtrlTxtColor"), for: .normal);
            _loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16);
            _loginButton.addTarget(self, action: #selector(LeftViewController.loginClick(sender:)), for: UIControlEvents.touchUpInside);
            return _loginButton;
        }
    }
    
    fileprivate var _backGroundImage: UIImageView!
    fileprivate var backGroundImage: UIImageView {
        get {
            guard _backGroundImage == nil else {
                return _backGroundImage;
            }
            _backGroundImage = UIImageView.init();
            _backGroundImage.image = UIImage.init(named: "userbackgroudImage");
            return _backGroundImage;
        }
    }
    
    fileprivate var _userBackView: UIView!
    fileprivate var userBackView: UIView {
        get {
            guard _userBackView == nil else {
                return _userBackView;
            }
            _userBackView = UIView.init();
            _userBackView.addSubview(self.backGroundImage);
            self.backGroundImage.snp.makeConstraints { (make) in
                make.left.top.right.equalTo(_userBackView);
                make.height.equalTo(166);
            }
            _userBackView.addSubview(self.userImage);
            self.userImage.snp.makeConstraints { (make) in
                make.left.equalTo(_userBackView).offset(16);
                make.width.equalTo(40);
                make.height.equalTo(40);
                make.bottom.equalTo(self.backGroundImage.snp.bottom).offset(10);
            }
            _userBackView.addSubview(self.userName);
            self.userName.snp.makeConstraints { (make) in
                make.left.equalTo(self.userImage.snp.right).offset(5);
                make.top.equalTo(self.userImage);
                make.bottom.equalTo(self.backGroundImage);
                make.right.equalTo(_userBackView);
            }
            return _userBackView;
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
        
        self.helper = GuangGuHelpDelegate();
        self.helper?.currentVC = self;
        self.helper?.vcDelegate = self;
        
        self.view.addSubview(self.userBackView);
        self.userBackView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(186);
        })
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.userBackView.snp.bottom);
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
        
        self.view.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "BackColor");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.refreshLoginStatus();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init();
        view.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "DivideColor");
        return view;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LEFTVIEWCELL" + String(indexPath.row);
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = LeftViewTableViewCell.init(style: .default, reuseIdentifier: identifier);
            switch indexPath.row {
            case 0:
                cell!.textLabel?.text = "个人中心";
                cell!.textLabel?.textColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "TxtColor");
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 1:
                cell!.textLabel?.text = "我的消息";
                cell!.textLabel?.textColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "TxtColor");
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 2:
                cell!.textLabel?.text = "我的主题";
                cell!.textLabel?.textColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "TxtColor");
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 3:
                cell!.textLabel?.text = "我的回复";
                cell!.textLabel?.textColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "TxtColor");
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16);
                cell!.accessoryType = .disclosureIndicator;
                break;
            case 4:
                cell!.textLabel?.text = "我的收藏";
                cell!.textLabel?.textColor = GuangGuColor.sharedInstance.getColor(node: "PersonalCenter", name: "TxtColor");
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
        if GuangGuAccount.shareInstance.isLogin() {
            switch indexPath.row {
            case 0:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    let vc = UserInfoViewController.init(urlString: GUANGGUSITE + userLink);
                    vc.vcDelegate = self;
                    vc.hidesBottomBarWhenPushed = true;
                    self.navigationController?.pushViewController(vc, animated: true);
                }
                break;
            case 1:
                let vc = NotificationViewController.init(urlString: GUANGGUSITE + "notifications");
                vc.vcDelegate = self;
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
                break;
            case 2:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    
                    let vc = CenterViewController.init(urlString: GUANGGUSITE + userLink + "/topics");
                    vc.title = GuangGuAccount.shareInstance.user!.userName + "的主题";
                    vc.hidesBottomBarWhenPushed = true;
                    vc.vcDelegate = self;
                    self.navigationController?.pushViewController(vc, animated: true);
                }
                break;
            case 3:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    
                    let vc = UserCommentViewController.init(urlString: GUANGGUSITE + userLink + "/replies")
                    vc.title = GuangGuAccount.shareInstance.user!.userName + "的回复";
                    vc.vcDelegate = self;
                    vc.hidesBottomBarWhenPushed = true;
                    self.navigationController?.pushViewController(vc, animated: true);
                }
                break;
            case 4:
                if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                    if userLink[userLink.startIndex] == "/" {
                        userLink.removeFirst();
                    }
                    
                    let vc = CenterViewController.init(urlString: GUANGGUSITE + userLink + "/favorites");
                    vc.needRefreshInAppear = true;
                    vc.title = GuangGuAccount.shareInstance.user!.userName + "的收藏";
                    vc.vcDelegate = self;
                    vc.hidesBottomBarWhenPushed = true;
                    self.navigationController?.pushViewController(vc, animated: true);
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
            if var userLink = GuangGuAccount.shareInstance.user?.userLink {
                if userLink[userLink.startIndex] == "/" {
                    userLink.removeFirst();
                }
                
                let vc = UserInfoViewController.init(urlString: GUANGGUSITE + userLink);
                vc.vcDelegate = self;
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true);
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
            Alamofire.request(GUANGGUSITE + "logout").responseString { [weak self](response) in
                self?.clearUserData();
                self?.refreshLoginStatus();
            }
        }
    }
    
    func pushLoginViewController() -> Void {
        if !GuangGuAccount.shareInstance.isLogin() {
            let vc = LoginViewController.init(completion: { [weak self](loginSuccess) in
                if loginSuccess {
                    self?.dismiss(animated: true, completion: nil);
                    let homePageData = HomePageDataSource.init(urlString: GUANGGUSITE);
                    homePageData.reloadData(completion: {self?.refreshLoginStatus()});
                }
            });
            vc.vcDelegate = self;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    func clearUserData() -> Void {
        GuangGuAccount.shareInstance.cookie = "";
        GuangGuAccount.shareInstance.user?.userImage = "";
        GuangGuAccount.shareInstance.user?.userLink = "";
        GuangGuAccount.shareInstance.user?.userName = "";
        GuangGuAccount.shareInstance.notificationText = "";
        BlackDataSource.shareInstance.itemList.removeAll();
        BlackDataSource.shareInstance.deleteTokenFile();
    }
    
    func refreshLoginStatus() -> Void {
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
    
    func OnPushVC(msg: NSDictionary) {
        self.helper?.OnPushHelp(msg);
    }
}
