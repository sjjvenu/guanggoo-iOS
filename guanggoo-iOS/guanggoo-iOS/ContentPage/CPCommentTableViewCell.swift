//
//  CPCommentTableViewCell.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/20.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit

class CPCommentTableViewCell: UITableViewCell {
    
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
    var _contentLabel : UILabel!;
    var contentLabel :UILabel {
        get {
            guard _contentLabel == nil else {
                return _contentLabel;
            }
            _contentLabel = UILabel.init();
            _contentLabel.textColor = UIColor.black;
            _contentLabel.font = UIFont.systemFont(ofSize: 12);
            return _contentLabel;
        }
    }

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
            make.width.equalTo(250);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.contentLabel);
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.replyDescriptionLabel.snp.bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(50);
            //make.bottom.equalTo(self).offset(-10);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
