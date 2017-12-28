//
//  LoginViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/20.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MBProgressHUD

public typealias HandleCompletion = (Bool) -> Void

class LoginViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .grouped);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.white;
            _tableView.allowsSelection = false;
            _tableView.separatorStyle = .none;
            
            return _tableView;
        }
    }
    fileprivate var _userNameTextField: UITextField!;
    fileprivate var userNameTextField: UITextField {
        get {
            guard _userNameTextField == nil else {
                return _userNameTextField;
            }
            _userNameTextField = UITextField.init();
            _userNameTextField.placeholder = "请输入邮箱";
            _userNameTextField.textColor = UIColor.black;
            _userNameTextField.clearButtonMode = .whileEditing;
            _userNameTextField.keyboardType = .emailAddress;
            return _userNameTextField;
        }
    }
    
    fileprivate var _passwordTextField: UITextField!;
    fileprivate var passwordTextField: UITextField {
        get {
            guard _passwordTextField == nil else {
                return _passwordTextField;
            }
            _passwordTextField = UITextField.init();
            _passwordTextField.placeholder = "请输入密码";
            _passwordTextField.textColor = UIColor.black;
            _passwordTextField.isSecureTextEntry = true;
            _passwordTextField.clearButtonMode = .whileEditing;
            return _passwordTextField;
        }
    }
    
    fileprivate var _completion:HandleCompletion?
    //MARK: - function
    required init(completion:HandleCompletion? )
    {
        super.init(nibName: nil, bundle: nil);
        _completion = completion;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let headerView = UIView.init();
        var height = 20 + 44;
        if UIScreen.main.bounds.height == 812 {
            height = 44 + 44;
        }
        self.view.addSubview(headerView);
        headerView.backgroundColor = UIColor.white;
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view);
            make.height.equalTo(height);
        }
        
        let backButton = UIButton.init();
        backButton.setImage(UIImage.init(named: "ic_menu_back"), for: .normal);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
        backButton.addTarget(self, action: #selector(backClick(sender:)), for: UIControlEvents.touchUpInside);
        headerView.addSubview(backButton);
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(20);
            make.bottom.equalTo(headerView);
            make.width.height.equalTo(40);
        }
        
        let titleLabel = UILabel.init();
        titleLabel.textColor = UIColor.black;
        titleLabel.text = "登录";
        titleLabel.textAlignment = .center;
        headerView.addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView);
            make.bottom.equalTo(headerView);
            make.width.equalTo(200);
            make.height.equalTo(40);
        }
        
        let registerButton = UIButton.init();
        registerButton.setTitle("注册", for: .normal);
        registerButton.setTitleColor(UIColor.blue, for: .normal);
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16);
        registerButton.addTarget(self, action: #selector(registerClick(sender:)), for: UIControlEvents.touchUpInside);
        headerView.addSubview(registerButton);
        registerButton.snp.makeConstraints { (make) in
            make.right.equalTo(headerView).offset(-20);
            make.bottom.equalTo(headerView);
            make.width.height.equalTo(40);
        }
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalTo(self.view);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LOGINVIEWCELL" + String(indexPath.row);
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier);
            switch indexPath.row {
            case 0:
                let imageView = UIImageView.init(image: UIImage.init(named: "ic_account_circle"));
                cell!.contentView.addSubview(imageView);
                imageView.snp.makeConstraints({ (make) in
                    make.left.equalTo(20);
                    make.centerY.equalTo(cell!.contentView);
                    make.width.height.equalTo(30);
                })
                cell!.contentView.addSubview(self.userNameTextField);
                self.userNameTextField.snp.makeConstraints({ (make) in
                    make.left.equalTo(imageView.snp.right).offset(10);
                    make.centerY.equalTo(cell!.contentView);
                    make.right.equalTo(cell!.contentView).offset(-20);
                    make.height.equalTo(30);
                })
                let divideLine = UILabel.init();
                divideLine.backgroundColor = UIColor.black;
                cell!.contentView.addSubview(divideLine);
                divideLine.snp.makeConstraints({ (make) in
                    make.left.equalTo(cell!.contentView).offset(20);
                    make.right.equalTo(cell!.contentView).offset(-20);
                    make.top.equalTo(self.userNameTextField.snp.bottom).offset(2);
                    make.height.equalTo(0.5);
                })
                break;
            case 1:
                let imageView = UIImageView.init(image: UIImage.init(named: "ic_lock"));
                cell!.contentView.addSubview(imageView);
                imageView.snp.makeConstraints({ (make) in
                    make.left.equalTo(20);
                    make.centerY.equalTo(cell!.contentView);
                    make.width.height.equalTo(30);
                })
                cell!.contentView.addSubview(self.passwordTextField);
                self.passwordTextField.snp.makeConstraints({ (make) in
                    make.left.equalTo(imageView.snp.right).offset(10);
                    make.centerY.equalTo(cell!.contentView);
                    make.right.equalTo(cell!.contentView).offset(-20);
                    make.height.equalTo(30);
                })
                let divideLine = UILabel.init();
                divideLine.backgroundColor = UIColor.black;
                cell!.contentView.addSubview(divideLine);
                divideLine.snp.makeConstraints({ (make) in
                    make.left.equalTo(cell!.contentView).offset(20);
                    make.right.equalTo(cell!.contentView).offset(-20);
                    make.top.equalTo(self.passwordTextField.snp.bottom).offset(2);
                    make.height.equalTo(0.5);
                })
                break;
            case 2:
                let loginButton = UIButton.init(type: .roundedRect);
                loginButton.backgroundColor = UIColor.lightGray;
                loginButton.setTitleColor(UIColor.black, for: .normal);
                loginButton.setTitle("登  录", for: .normal);
                loginButton.addTarget(self, action: #selector(LoginViewController.loginClick(sender:)), for: UIControlEvents.touchUpInside);
                loginButton.clipsToBounds = true;
                loginButton.layer.cornerRadius = 5;
                cell?.contentView.addSubview(loginButton);
                loginButton.snp.makeConstraints({ (make) in
                    make.left.equalTo(cell!.contentView).offset(20);
                    make.right.equalTo(cell!.contentView).offset(-20);
                    make.bottom.equalTo(cell!.contentView);
                    make.height.equalTo(35);
                })
                break;
            default:
                break;
            }
        }
        return cell!;
    }

    //MARK: - event
    @objc func loginClick(sender: UIButton) -> Void {
        let email = self.userNameTextField.text;
        if !email!.isValidEmail() {
            let alert = UIAlertController.init(title: "提示", message: "请输入正确的email", preferredStyle: UIAlertControllerStyle.alert);
            let actionOK = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil);
            alert.addAction(actionOK);
            self.present(alert, animated: true, completion: nil);
        }
        let password = self.passwordTextField.text
        if password?.count == 0 {
            let alert = UIAlertController.init(title: "提示", message: "请输入密码", preferredStyle: UIAlertControllerStyle.alert);
            let actionOK = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil);
            alert.addAction(actionOK);
            self.present(alert, animated: true, completion: nil);
        }
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "");
        let para = [
            "email": email!,
            "password": password!,
            "_xsrf": uuid
        ]
        
        var dict = [String:String]();
        dict["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
        dict["Content-Type"] = "application/x-www-form-urlencoded"
        dict["Cookie"] = "_xsrf=" + uuid;
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        //登录
        Alamofire.request(GUANGGUSITE+"login", method: .post, parameters: para, headers: dict).responseString { (response) in
            MBProgressHUD.hide(for: self.view, animated: true);
            switch(response.result) {
            case .success( _):
                if let cookies = HTTPCookieStorage.shared.cookies
                {
                    for object in cookies {
                        if object.name == "user" {
                            print("login success");
                            if let completion = self._completion {
                                self.dismiss(animated: true, completion: nil);
                                completion(true);
                            }
                            return;
                        }
                    }
                    print("login failed");
                    if let completion = self._completion {
                        let alert = UIAlertController.init(title: "提示", message: "登录失败，请重试!", preferredStyle: UIAlertControllerStyle.alert);
                        let actionOK = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil);
                        alert.addAction(actionOK);
                        self.present(alert, animated: true, completion: nil);
                        completion(false);
                    }
                }
                break;
            case .failure(let error):
                var message : String = "";
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "Username or password not provided."
                        print(message);
                        break;
                    case 401:
                        message = "Incorrect password for user '\(self.userNameTextField.text!)'."
                        print(message);
                        break;
                    default:
                        print(error);
                    }
                }
                else
                {
                }
                print("login failed");
                if let completion = self._completion {
                    let alert = UIAlertController.init(title: "提示", message: "登录失败，请稍后再试!", preferredStyle: UIAlertControllerStyle.alert);
                    let actionOK = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil);
                    alert.addAction(actionOK);
                    self.present(alert, animated: true, completion: nil);
                    completion(false);
                }
            }
        }
    }
    
    @objc func backClick(sender: UIButton) -> Void {
        if let completion = self._completion {
            completion(false);
        }
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func registerClick(sender: UIButton) -> Void {
        let vc = CommWebViewController.init(url: URL.init(string: "http://www.guanggoo.com/register"));
        vc.title = "注册"
        vc.vcDelegate = self.vcDelegate;
        let msg = NSMutableDictionary.init();
        msg["MSGTYPE"] = "PresentViewController";
        msg["PARAM1"] = vc;
        if let delegate = self.vcDelegate {
            self.dismiss(animated: true, completion: nil);
            delegate.OnPushVC(msg: msg);
        }
    }
}
