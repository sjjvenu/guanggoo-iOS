//
//  CPHeaderView.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/19.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit

class CPHeaderView: UIView {

    weak var vcDelegate:GuangGuVCDelegate?
    var titleLink = "";
    //creator imageView
    var _creatorImageView : UIImageView!;
    var creatorImageView : UIImageView {
        get {
            guard _creatorImageView == nil else {
                return _creatorImageView;
            }
            _creatorImageView = UIImageView.init();
            _creatorImageView.backgroundColor = UIColor.lightGray;
            return _creatorImageView;
        }
    }
    //creator name
    var _creatorNameLabel : UILabel!;
    var creatorNameLabel :UILabel {
        get {
            guard _creatorNameLabel == nil else {
                return _creatorNameLabel;
            }
            _creatorNameLabel = UILabel.init();
            _creatorNameLabel.textColor = UIColor.black;
            _creatorNameLabel.font = UIFont.systemFont(ofSize: 12);
            return _creatorNameLabel;
        }
    }
    //reply description
    var _replyDescriptionLabel : UILabel!;
    var replyDescriptionLabel :UILabel {
        get {
            guard _replyDescriptionLabel == nil else {
                return _replyDescriptionLabel;
            }
            _replyDescriptionLabel = UILabel.init();
            _replyDescriptionLabel.textColor = UIColor.black;
            _replyDescriptionLabel.font = UIFont.systemFont(ofSize: 12);
            return _replyDescriptionLabel;
        }
    }
    //node name
    var _nodeNameLabel : UILabel!;
    var nodeNameLabel :UILabel {
        get {
            guard _nodeNameLabel == nil else {
                return _nodeNameLabel;
            }
            _nodeNameLabel = UILabel.init();
            _nodeNameLabel.textColor = UIColor.black;
            _nodeNameLabel.font = UIFont.systemFont(ofSize: 12);
            _nodeNameLabel.textAlignment = .right;
            return _nodeNameLabel;
        }
    }
    //title
    var _titleLabel : UILabel!;
    var titleLabel :UILabel {
        get {
            guard _titleLabel == nil else {
                return _titleLabel;
            }
            _titleLabel = UILabel.init();
            _titleLabel.textColor = UIColor.black;
            _titleLabel.font = UIFont.systemFont(ofSize: 16);
            return _titleLabel;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.addSubview(self.creatorImageView);
        self.creatorImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(15);
            make.width.height.equalTo(40);
        }
        self.addSubview(self.creatorNameLabel);
        self.creatorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.creatorImageView.snp.right).offset(10);
            make.top.equalTo(self).offset(15);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }
        self.addSubview(self.replyDescriptionLabel);
        self.replyDescriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.creatorImageView.snp.right).offset(10);
            make.top.equalTo(self.creatorNameLabel.snp.bottom);
            make.width.equalTo(250);
            make.height.equalTo(20);
        }
        self.addSubview(self.nodeNameLabel);
        self.nodeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }
        self.addSubview(self.titleLabel);
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self.replyDescriptionLabel.snp.bottom).offset(10);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(20);
            //make.bottom.equalTo(self).offset(-10);
        }
        
        //长按手势
        self.addGestureRecognizer(
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(CPHeaderView.longPressHandle(_:))
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleContent(_ title: String) -> Void {
        self.titleLabel.text = title;
        let labelWidth = UIScreen.main.bounds.size.width - 30;
        let titleWidth = title.width(withConstraintedHeight: 20, font: UIFont.systemFont(ofSize: 16));
        if (titleWidth > labelWidth)
        {
            let lines = titleWidth/labelWidth + 1;
            self.titleLabel.numberOfLines = Int(lines);
            self.titleLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(20*Int(lines))
            })
        }
    }
    
    @objc func longPressHandle(_ longPress:UILongPressGestureRecognizer) -> Void {
        let action = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet);
        let copy = UIAlertAction.init(title: "复制链接", style: .default) { (action) in
            UIPasteboard.general.string = self.titleLink
        }
        let replySomeone = UIAlertAction.init(title: "回复", style: .default) { (action) in
            let msg = NSMutableDictionary.init();
            msg["MSGTYPE"] = "AtSomeone";
            msg["PARAM1"] = self.creatorNameLabel.text;
            self.vcDelegate?.OnPushVC(msg: msg);
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil);
        action.addAction(replySomeone);
        action.addAction(copy);
        action.addAction(cancel);
        let msg = NSMutableDictionary.init();
        msg["MSGTYPE"] = "PresentViewController";
        msg["PARAM1"] = action;
        self.vcDelegate?.OnPushVC(msg: msg);
    }
}
