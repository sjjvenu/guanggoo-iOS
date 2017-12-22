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

class CommWebViewController: UIViewController {
    
    //MARK: - property
    fileprivate var _webView: WKWebView!
    fileprivate var webView: WKWebView {
        get {
            guard _webView == nil else {
                return _webView;
            }
            _webView = WKWebView.init();
            _webView.backgroundColor = UIColor.clear
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
