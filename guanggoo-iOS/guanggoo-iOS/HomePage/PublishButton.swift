//
//  PublishButton.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/12/7.
//  Copyright © 2018 tdx. All rights reserved.
//

import UIKit
import CYLTabBarController

class PublishButton: CYLPlusButton,CYLPlusButtonSubclassing {
    
    static func plusButton() -> Any! {
        let button = PublishButton()
        button.setImage(UIImage(named: "ic_publish"), for: .normal)
        button.setImage(UIImage(named: "ic_publish_selected"), for: .selected)
        button.titleLabel?.textAlignment = .center
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        
        button.setTitle("发布主题", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        
        button.setTitle("发布主题", for: .selected)
        button.setTitleColor(UIColor.init(red: 0.12, green: 0.5, blue: 0.95, alpha: 1), for: .selected)
        
        button.adjustsImageWhenHighlighted = false
        button.sizeToFit()
        button.addTarget(button, action: #selector(btnPublishClick), for: .touchUpInside);
        return button
    }
    
    static func indexOfPlusButtonInTabBar() -> UInt {
        return 2
    }
    
    static func multiplier(ofTabBarHeight tabBarHeight: CGFloat) -> CGFloat {
        if IPHONE_FULLSCREEN {
            return 0.43
        }
        else {
            return 0.73
        }
    }

    static func constantOfPlusButtonCenterYOffset(forTabBarHeight tabBarHeight: CGFloat) -> CGFloat {
        return -10
    }
    
    @objc func btnPublishClick() -> Void {
        let tabBarController = self.cyl_tabBarController;
        if let topVC = tabBarController?.selectedViewController {
            if GuangGuAccount.shareInstance.isLogin() {
                let vc = InterestViewController();
                vc.title = "请选择主题节点";
                vc.hidesBottomBarWhenPushed = true;
                vc.createTitle = true;
                if let nav = topVC as? UINavigationController {
                    nav.pushViewController(vc, animated: true);
                }
            }
            else {
                let loginVC = LoginViewController.init {(loginSuccess) in
                    if loginSuccess {
                        let homePageData = HomePageDataSource.init(urlString: GUANGGUSITE);
                        homePageData.reloadData(completion: {
                            let vc = InterestViewController();
                            vc.title = "请选择主题节点";
                            vc.hidesBottomBarWhenPushed = true;
                            vc.createTitle = true;
                            if let nav = topVC as? UINavigationController {
                                nav.pushViewController(vc, animated: true);
                            }
                        });
                    }
                }
                topVC.present(loginVC, animated: true, completion: nil);
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // tabbar UI layout setup
        let imageViewEdgeWidth:CGFloat  = 25
        let imageViewEdgeHeight:CGFloat = 25
        
        let centerOfView    = self.bounds.size.width * 0.5
        let labelLineHeight = self.titleLabel!.font.lineHeight
        let verticalMargin = (self.bounds.size.height - labelLineHeight - imageViewEdgeHeight ) * 0.5
        
        let centerOfImageView = verticalMargin + imageViewEdgeHeight * 0.5
        let centerOfTitleLabel = imageViewEdgeHeight + verticalMargin * 2  + labelLineHeight * 0.5 + 10
        
        //imageView position layout
        self.imageView!.bounds = CGRect(x:0, y:0, width:imageViewEdgeWidth, height:imageViewEdgeHeight)
        self.imageView!.center = CGPoint(x:centerOfView, y:centerOfImageView)
        
        //title position layout
        self.titleLabel!.bounds = CGRect(x:0, y:0, width:self.bounds.size.width,height:labelLineHeight)
        self.titleLabel!.center = CGPoint(x:centerOfView, y:centerOfTitleLabel)
    }
}
