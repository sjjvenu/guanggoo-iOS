//
//  CPHeaderTableViewCell.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/19.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import KVOController
import MWPhotoBrowser

public typealias CPHeaderWebViewContentHeightChanged = (CGFloat) -> Void

class CPHeaderTableViewCell: UITableViewCell ,WKNavigationDelegate,MWPhotoBrowserDelegate{
    weak var vcDelegate:GuangGuVCDelegate?
    //content
    var contentHeight : CGFloat = 0
    
    var itemModel:GuangGuStruct?
    
    var contentHeightChanged : CPHeaderWebViewContentHeightChanged?
    
    var _contentWebView : WKWebView!;
    var contentWebView :WKWebView {
        get {
            guard _contentWebView == nil else {
                return _contentWebView;
            }
            _contentWebView = WKWebView.init();
            _contentWebView.isOpaque = false
            _contentWebView.backgroundColor = UIColor.clear
            _contentWebView.scrollView.isScrollEnabled = false
            _contentWebView.navigationDelegate = self;
            return _contentWebView;
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.contentWebView);
        self.contentWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView);
        }
        
        self.kvoController.observe(self.contentWebView.scrollView, keyPath: "contentSize", options: [.new]) {
            [weak self] (observe, observer, change) -> Void in
            if let weakSelf = self {
                let size = change["new"] as! NSValue
                if weakSelf.contentHeight == size.cgSizeValue.height && weakSelf.contentHeight > 0 {
                    return;
                }
                weakSelf.contentHeight = size.cgSizeValue.height;
                weakSelf.contentHeightChanged?(weakSelf.contentHeight)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request;
        if self.itemModel!.images.count > 0 {
            let index = self.itemModel?.images.index(of: request.url?.absoluteString ?? "")
            if  index! >= 0 && index! < self.itemModel!.images.count {
                let broswer = MWPhotoBrowser.init(delegate: self);
                broswer?.setCurrentPhotoIndex(UInt(index!));
                let msg = NSMutableDictionary.init();
                msg["MSGTYPE"] = "PhotoBrowser";
                msg["PARAM1"] = broswer;
                self.vcDelegate?.OnPushVC(msg: msg);
            }
            else {
                if let urlString = request.url?.absoluteString,urlString.contains("http"),urlString.contains("www.guanggoo.com") == false {
                    let vc = CommWebViewController.init(url: request.url);
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "PushViewController";
                    msg["PARAM1"] = vc;
                    self.vcDelegate?.OnPushVC(msg: msg);
                }
            }
        }
        else {
            if let urlString = request.url?.absoluteString,urlString.contains("http"),urlString.contains("www.guanggoo.com") == false {
                let vc = CommWebViewController.init(url: request.url);
                let msg = NSMutableDictionary.init();
                msg["MSGTYPE"] = "PushViewController";
                msg["PARAM1"] = vc;
                self.vcDelegate?.OnPushVC(msg: msg);
            }
        }
        decisionHandler(.allow);
    }
    
    //MARK: -MWPhotoBrowserDelegate
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.itemModel!.images.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < UInt(self.itemModel!.images.count) {
            return MWPhoto.init(url: URL.init(string: self.itemModel!.images[Int(index)] as! String))
        }
        return nil;
    }
}
