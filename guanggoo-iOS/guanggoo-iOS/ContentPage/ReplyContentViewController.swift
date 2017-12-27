//
//  ReplyContentViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/27.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import YYText
import Toast_Swift
import MBProgressHUD
import Alamofire

class ReplyContentViewController: UIViewController ,YYTextViewDelegate{
    
    fileprivate var initString:String = "";
    fileprivate var commentURLString:String = "";
    fileprivate var commentID = "";
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
            _textView.resignFirstResponder();
            
            let str = NSMutableAttributedString(string: self.initString)
            str.yy_font = _textView.font
            str.yy_color = _textView.textColor
            
            _textView.attributedText = str
            
            _textView.selectedRange = NSMakeRange(self.initString.count, 0);
            
            return _textView;
        }
    }
    
    fileprivate var _completion:HandleCompletion?
    required init(string:String,urlString:String,completion:HandleCompletion?)
    {
        super.init(nibName: nil, bundle: nil);
        self.initString = string;
        
        var commentLink = urlString;
        let result1 = commentLink.range(of: "/t/",
                                        options: NSString.CompareOptions.literal,
                                        range: commentLink.startIndex..<commentLink.endIndex,
                                        locale: nil)
        if let rang = result1 {
            let start = rang.upperBound;
            commentLink = String(commentLink[start..<commentLink.endIndex]);
        }
        let result2 = commentLink.range(of: "?p",
                                        options: NSString.CompareOptions.literal,
                                        range: commentLink.startIndex..<commentLink.endIndex,
                                        locale: nil)
        if let rang = result2 {
            let end = rang.lowerBound;
            commentLink = String(commentLink[commentLink.startIndex..<end]);
        }
        self.commentID = commentLink;
        
        let result3 = urlString.range(of: "?p",
                                        options: NSString.CompareOptions.literal,
                                        range: urlString.startIndex..<urlString.endIndex,
                                        locale: nil)
        if let rang = result3 {
            let end = rang.lowerBound;
            self.commentURLString = String(urlString[urlString.startIndex..<end]);
        }
        else {
            self.commentURLString = urlString;
        }
        
        self._completion = completion;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        self.view.addSubview(self.textView);
        self.textView.snp.makeConstraints { (make) in
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

    func textViewDidChange(_ textView: YYTextView) {
//        if textView.text.count == 0{
//            textView.textColor = UIColor.lightGray;
//        }
    }
    
    @objc func leftClick(sender: UIButton) -> Void {
        let text = self.textView.text;
        if text != self.initString {
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
        if self.textView.text == nil || self.textView.text.count <= 0 {
            self.view.makeToast("请输入回复内容")
            return;
        }
        
        
        let uuid = GuangGuAccount.shareInstance.cookie;
        let para = [
            "tid": self.commentID,
            "content": self.textView.text!,
            "_xsrf": uuid
        ]
        
        var dict = [String:String]();
        dict["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
        dict["Accept-Encoding"] = "gzip, deflate"
        dict["Content-Type"] = "application/x-www-form-urlencoded"
//        dict["Cookie"] = "_xsrf=" + uuid;
//        dict["Referer"] = self.commentURLString;
//        dict["Host"] = "www.guanggoo.com";
//        dict["Origin"] = GUANGGUSITE;
//        dict["User-Agent"] =  USER_AGENT;
//        dict["Connection"] = "keep-alive";
//        dict["Cache-Control"] = "max-age=0";
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        //登录
        Alamofire.request(self.commentURLString, method: .post, parameters: para, headers: dict).responseString { (response) in
            MBProgressHUD.hide(for: self.view, animated: true);
            switch(response.result) {
            case .success( _):
                if let completion = self._completion {
                    completion(true);
                }
                self.navigationController?.popViewController(animated: true);
                break;
            case .failure(_):
                self.view.makeToast("回复失败！")
                if let completion = self._completion {
                    completion(false);
                }
                break;
            }
        }
        
    }
}


class GGMentionedBindingParser: NSObject ,YYTextParser{
    var regex:NSRegularExpression
    override init() {
        self.regex = try! NSRegularExpression(pattern: "@(\\S+)\\s", options: [.caseInsensitive])
        super.init()
    }
    
    func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        guard let text = text else {
            return false;
        }
        self.regex.enumerateMatches(in: text.string, options: [.withoutAnchoringBounds], range: text.yy_rangeOfAll()) { (result, flags, stop) -> Void in
            if let result = result {
                let range = result.range
                if range.location == NSNotFound || range.length < 1 {
                    return ;
                }
                
                if  text.attribute(NSAttributedStringKey(rawValue: YYTextBindingAttributeName), at: range.location, effectiveRange: nil) != nil  {
                    return ;
                }
                
                let bindlingRange = NSMakeRange(range.location, range.length-1)
                let binding = YYTextBinding()
                binding.deleteConfirm = true ;
                text.yy_setTextBinding(binding, range: bindlingRange)
                text.yy_setColor(UIColor.init(red: 0, green: 132.0/255.0, blue: 1, alpha: 1), range: bindlingRange)
            }
        }
        return false;
    }
    
    
}
