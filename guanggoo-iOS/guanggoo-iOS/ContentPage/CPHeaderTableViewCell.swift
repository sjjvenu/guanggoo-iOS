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

public typealias CPHeaderWebViewContentHeightChanged = (CGFloat) -> Void

class CPHeaderTableViewCell: UITableViewCell {
    //content
    var contentHeight : CGFloat = 0
    
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
            _contentWebView.sizeToFit();
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
                if weakSelf.contentHeight != size.cgSizeValue.height {
                    weakSelf.contentHeight = size.cgSizeValue.height;
                    weakSelf.contentHeightChanged?(weakSelf.contentHeight)
                }
                else {
                    weakSelf.contentHeight = size.cgSizeValue.height;
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
