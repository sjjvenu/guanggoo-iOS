//
//  UserCommentTableViewCell.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/26.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import YYText
import MWPhotoBrowser

class UserCommentTableViewCell: UITableViewCell ,GuangGuCommentAttachmentImageTapDelegate,MWPhotoBrowserDelegate{
    
    //MARK: - property
    weak var vcDelegate:GuangGuVCDelegate?
    //reply description
    var _replyDescriptionLabel : UILabel!;
    var replyDescriptionLabel :UILabel {
        get {
            guard _replyDescriptionLabel == nil else {
                return _replyDescriptionLabel;
            }
            _replyDescriptionLabel = UILabel.init();
            _replyDescriptionLabel.textColor = UIColor.lightGray;
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
    
    var itemModel:GuangGuComent?
    
    //MARK: - function
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.replyDescriptionLabel);
        self.replyDescriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.contentLabel);
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.replyDescriptionLabel.snp.bottom).offset(5);
            make.right.equalTo(self.contentView).offset(-15);
            //make.height.equalTo(50);
            make.bottom.equalTo(self).offset(-10);
        }
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
}
