//
//  CommWebViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/22.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class CommWebViewController: UIViewController ,WKNavigationDelegate{
    
    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?
    
    fileprivate var _webView: WKWebView!
    fileprivate var webView: WKWebView {
        get {
            guard _webView == nil else {
                return _webView;
            }
            _webView = WKWebView.init();
            _webView.backgroundColor = UIColor.clear
            _webView.navigationDelegate = self;
            return _webView;
        }
    }
    
    fileprivate var webURL: URL!;
    
    required init(url:URL?)
    {
        super.init(nibName: nil, bundle: nil);
        guard let url = url else {
            return;
        }
        self.webURL = url;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.webView);
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        self.webView.load(URLRequest.init(url: self.webURL));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString {
            if urlString == GUANGGUSITE {
                if let delegate = self.vcDelegate {
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "GotoHomePage";
                    delegate.OnPushVC(msg: msg);
                    decisionHandler(.cancel);
                    return;
                }
            }
            else if urlString == GUANGGUSITE+"login" {
                if let nav = self.navigationController {
                    nav.popToRootViewController(animated: false);
                }
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
        
        decisionHandler(.allow);
    }

}
