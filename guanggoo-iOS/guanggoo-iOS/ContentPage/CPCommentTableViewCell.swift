//
//  CPCommentTableViewCell.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/20.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import YYText
import MWPhotoBrowser

class CPCommentTableViewCell: UITableViewCell ,GuangGuCommentAttachmentImageTapDelegate,MWPhotoBrowserDelegate{
    
    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?
    var itemModel:GuangGuComent?
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
    //content
    var _contentLabel : YYLabel!;
    var contentLabel :YYLabel {
        get {
            guard _contentLabel == nil else {
                return _contentLabel;
            }
            _contentLabel = YYLabel.init();
            _contentLabel.textColor = UIColor.black;
            _contentLabel.font = UIFont.systemFont(ofSize: 14);
            _contentLabel.numberOfLines = 0;
            _contentLabel.displaysAsynchronously = true
            return _contentLabel;
        }
    }
    
    //reply description
    var _floorLabel : UILabel!;
    var floorLabel :UILabel {
        get {
            guard _floorLabel == nil else {
                return _floorLabel;
            }
            _floorLabel = UILabel.init();
            _floorLabel.textColor = UIColor.black;
            _floorLabel.font = UIFont.systemFont(ofSize: 12);
            _floorLabel.textAlignment = .right;
            return _floorLabel;
        }
    }

    //MARK: - function
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.creatorImageView);
        self.creatorImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(40);
        }
        self.contentView.addSubview(self.creatorNameLabel);
        self.creatorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.creatorImageView.snp.right).offset(10);
            make.top.equalTo(self.contentView).offset(15);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.replyDescriptionLabel);
        self.replyDescriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.creatorImageView.snp.right).offset(10);
            make.top.equalTo(self.creatorNameLabel.snp.bottom);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.floorLabel);
        self.floorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.contentLabel);
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.replyDescriptionLabel.snp.bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            //make.height.equalTo(50);
            make.bottom.equalTo(self).offset(-10);
        }
        
        self.selectionStyle = .none;
        //长按手势
        self.contentView .addGestureRecognizer(
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(CPCommentTableViewCell.longPressHandle(_:))
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - GuangGuCommentAttachmentImageTapDelegate
    func GuangGuCommentAttachmentImageSingleTap(_ imageView: GuangGuAttachmentImage) {
        let broswer = MWPhotoBrowser.init(delegate: self);
        broswer?.setCurrentPhotoIndex(UInt(imageView.index));
        let msg = NSMutableDictionary.init();
        msg["MSGTYPE"] = "PhotoBrowser";
        msg["PARAM1"] = broswer;
        self.vcDelegate?.OnPushVC(msg: msg);
    }
    
    
    //MARK: - MWPhotoBrowserDelegate
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.itemModel!.images.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < UInt(self.itemModel!.images.count) {
            return MWPhoto.init(url: URL.init(string: self.itemModel!.images[Int(index)] as! String))
        }
        return nil;
    }
    
    @objc func longPressHandle(_ longPress:UILongPressGestureRecognizer) -> Void {
        let action = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet);
        let copy = UIAlertAction.init(title: "复制", style: .default) { (action) in
            UIPasteboard.general.string = self.itemModel?.textLayout?.text.string
        }
        let replySomeone = UIAlertAction.init(title: "回复", style: .default) { (action) in
            let msg = NSMutableDictionary.init();
            msg["MSGTYPE"] = "AtSomeone";
            msg["PARAM1"] = self.creatorNameLabel.text;
            self.vcDelegate?.OnPushVC(msg: msg);
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil);
        action.addAction(replySomeone);
        if self.itemModel?.creatorName == GuangGuAccount.shareInstance.user?.userName,let count =  self.itemModel?.replyLink.count,count > 0{
            let editComment = UIAlertAction.init(title: "编辑回复", style: .default) { (action) in
                let msg = NSMutableDictionary.init();
                msg["MSGTYPE"] = "EditComment";
                msg["PARAM1"] = self.itemModel!;
                self.vcDelegate?.OnPushVC(msg: msg);
            }
            action.addAction(editComment);
        }
        let report = UIAlertAction.init(title: "举报", style: .default) { (action) in
            let msg = NSMutableDictionary.init();
            msg["MSGTYPE"] = "ReportComment";
            msg["PARAM1"] = self.floorLabel.text;
            self.vcDelegate?.OnPushVC(msg: msg);
        }
        action.addAction(copy);
        action.addAction(report);
        action.addAction(cancel);
        let msg = NSMutableDictionary.init();
        msg["MSGTYPE"] = "PresentViewController";
        msg["PARAM1"] = action;
        self.vcDelegate?.OnPushVC(msg: msg);
    }
}
