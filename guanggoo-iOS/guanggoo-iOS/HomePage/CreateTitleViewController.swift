//
//  CreateTitleViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/28.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import YYText
import Toast_Swift
import MBProgressHUD
import Alamofire

class CreateTitleViewController: UIViewController ,YYTextViewDelegate{
    
    fileprivate var commitURLString:String = "";
    fileprivate var _textView:YYTextView!
    fileprivate var textView:YYTextView {
        get {
            guard _textView == nil else {
                return _textView;
            }
            _textView = YYTextView()
            _textView.scrollsToTop = false
            _textView.backgroundColor = UIColor.white;
            _textView.font = UIFont.systemFont(ofSize: 18);
            _textView.delegate = self
            _textView.textColor = UIColor.black;
            _textView.placeholderText = "请输入回复内容";
            _textView.textParser = GGMentionedBindingParser()
            _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
            _textView.keyboardDismissMode = .interactive
            _textView.layer.borderColor = UIColor.lightGray.cgColor;
            _textView.layer.cornerRadius = 5;
            _textView.layer.borderWidth = 0.5;
            //_textView.resignFirstResponder();
            
            return _textView;
        }
    }
    
    fileprivate var _titleTextField:UITextField!
    fileprivate var titleTextField:UITextField {
        get {
            guard _titleTextField == nil else {
                return _titleTextField;
            }
            _titleTextField = UITextField.init();
            _titleTextField.backgroundColor = UIColor.white;
            _titleTextField.placeholder = "请输入标题";
            _titleTextField.textColor = UIColor.black;
            _titleTextField.layer.borderColor = UIColor.lightGray.cgColor;
            _titleTextField.layer.cornerRadius = 5;
            _titleTextField.layer.borderWidth = 0.5;
            
            return _titleTextField;
        }
    }
    
    fileprivate var _completion:HandleCompletion?
    required init(title:String,content:String,urlString:String,completion:HandleCompletion?)
    {
        super.init(nibName: nil, bundle: nil);
        
        self.commitURLString = urlString;
        if title.count > 0 {
            self.titleTextField.text = title;
        }
        if content.count > 0 {
            self.textView.text = content;
        }
        
        self._completion = completion;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        
        let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        leftButton.setTitle("取消", for: .normal);
        leftButton.setTitleColor(UIColor.init(red: 75.0/255.0, green: 145.0/255.0, blue: 214.0/255.0, alpha: 1), for: .normal);
        leftButton.addTarget(self, action: #selector(CenterViewController.leftClick(sender:)), for: .touchUpInside);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton);
        
        let rightButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        rightButton.setTitle("提交", for: .normal);
        rightButton.setTitleColor(UIColor.init(red: 75.0/255.0, green: 145.0/255.0, blue: 214.0/255.0, alpha: 1), for: .normal);
        rightButton.addTarget(self, action: #selector(CenterViewController.rightClick(sender:)), for: .touchUpInside);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton);
        
        self.view.addSubview(self.titleTextField);
        self.titleTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10);
            make.height.equalTo(30);
        }
        
        self.view.addSubview(self.textView);
        self.textView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.top.equalTo(self.titleTextField.snp.bottom).offset(10);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-10);
            } else {
                make.bottom.equalTo(self.view).offset(-10);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: YYTextView) {
        //        if textView.text.count == 0{
        //            textView.textColor = UIColor.lightGray;
        //        }
    }
    
    @objc func leftClick(sender: UIButton) -> Void {
        let titleText = self.titleTextField.text;
        let text = self.textView.text;
        if let count = text?.count ,count > 0 ,let titleCount = titleText?.count,titleCount > 0{
            let alert = UIAlertController.init(title: "提示", message: "确定放弃修改并返回？", preferredStyle: .alert);
            let ok = UIAlertAction.init(title: "确定", style: .default, handler: { (alert) in
                self.navigationController?.popViewController(animated: true);
            })
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil);
            alert.addAction(ok);
            alert.addAction(cancel);
            self.present(alert, animated: true, completion: nil);
        } else {
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    @objc func rightClick(sender: UIButton) -> Void {
        if self.titleTextField.text == nil || self.titleTextField.text!.count <= 0 {
            self.view.makeToast("请输入标题", duration: 1.0, position: .center)
            return;
        }
        if self.textView.text == nil || self.textView.text.count <= 0 {
            self.view.makeToast("请输入内容", duration: 1.0, position: .center)
            return;
        }
        
        var dict = [String:String]();
        dict["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
        dict["Accept-Encoding"] = "gzip, deflate"
        dict["Content-Type"] = "application/x-www-form-urlencoded"
        
        
        let uuid = GuangGuAccount.shareInstance.cookie;
        let para = [
            "title": self.titleTextField.text!,
            "content": self.textView.text!,
            "_xsrf": uuid
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        Alamofire.request(self.commitURLString, method: HTTPMethod.post, parameters: para, headers: dict).responseString
            { (response) in
            MBProgressHUD.hide(for: self.view, animated: true);
            switch(response.result) {
            case .success( _):
                print(response);
                if let completion = self._completion {
                    completion(true);
                }
                self.navigationController?.popViewController(animated: true);
                break;
            case .failure(_):
                self.view.makeToast("发布失败！")
                if let completion = self._completion {
                    completion(false);
                }
                break;
            }
        }
    }
}
