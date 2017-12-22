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

public typealias LoginCompletion = (Bool) -> Void

class LoginViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
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
    
    fileprivate var _completion:LoginCompletion?
    required init(completion:LoginCompletion? )
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
        self.title = "登录";
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
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
                    make.centerY.equalTo(cell!.contentView);
                    make.height.equalTo(35);
                })
                break;
            default:
                break;
            }
        }
        return cell!;
    }

    
    @objc func loginClick(sender: UIButton) -> Void {
        let para = [
            "email": "3228656859@qq.com",
            "password": "qinken547",
            "_xsrf": "b45fa8c3f6854a3aa4444a5a036b9650"
        ]
        
        var dict = [String:String]();
        //为安全，此处使用https
        //dict["Referer"] = "http://www.guanggoo.com/login"
        dict["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
        dict["Content-Type"] = "application/x-www-form-urlencoded"
        dict["cookie"] = "_xsrf=b45fa8c3f6854a3aa4444a5a036b9650"
        //登录
        Alamofire.request(GUANGGUSITE+"login", method: .post, parameters: para, headers: dict).responseString { (response) in
            switch(response.result) {
            case .success( _):
                if let cookies = HTTPCookieStorage.shared.cookies
                {
                    for object in cookies {
                        if object.name == "user" {
                            print("loginSuccess");
                            break;
                        }
                    }
                }
                break;
            case .failure(let error):
                var message : String = "";
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "Username or password not provided."
                    case 401:
                        message = "Incorrect password for user '\(self.userNameTextField.text!)'."
                    default:
                        print(error);
                    }
                } else {
                }
            }
        }
    }
}
