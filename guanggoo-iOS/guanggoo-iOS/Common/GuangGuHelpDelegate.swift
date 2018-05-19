//
//  GuangGuHelpDelegate.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/5/19.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit

class GuangGuHelpDelegate: NSObject ,GuangGuVCDelegate{
    //MARK: - property
    var currentVC:UIViewController?;
    weak var vcDelegate:GuangGuVCDelegate?
    
    func OnPushHelp(_ msg:NSDictionary) -> Void {
        if let msgtype = msg["MSGTYPE"] as? String {
            if msgtype == "pushViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "PhotoBrowser" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "LoginViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    currentVC?.present(vc, animated: true, completion: nil);
                }
            }
            else if msgtype == "PresentViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "UserInfoViewController" {
                if case let urlString as String = msg["PARAM1"] {
                    let vc = UserInfoViewController.init(urlString: GUANGGUSITE + urlString);
                    vc.vcDelegate = self;
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "ContentPageViewController" {
                if case var urlString as String = msg["PARAM1"] {
                    if let index = urlString.index(of: "#") {
                        urlString = String(urlString[urlString.startIndex..<index])
                    }
                    let vc = ContentPageViewController.init(urlString: urlString,model:nil);
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "PushViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "CenterViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    currentVC?.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "GotoHomePage" {
                currentVC?.navigationController?.popToRootViewController(animated: true);
                //self.homePageData?.reloadData(completion: {self.tableView.reloadData()});
            }
        }
    }
    
    func OnPushVC(msg: NSDictionary) {
        
    }
}
