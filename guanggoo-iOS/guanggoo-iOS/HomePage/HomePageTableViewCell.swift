//
//  HomePageTableViewCell.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/19.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit

class HomePageTableViewCell: UITableViewCell {
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
    //reply count
    var _replyCountLabel : UILabel!;
    var replyCountLabel :UILabel {
        get {
            guard _replyCountLabel == nil else {
                return _replyCountLabel;
            }
            _replyCountLabel = UILabel.init();
            _replyCountLabel.textColor = UIColor.white;
            _replyCountLabel.backgroundColor = UIColor.lightGray;
            _replyCountLabel.font = UIFont.systemFont(ofSize: 12);
            _replyCountLabel.layer.cornerRadius = 5;
            _replyCountLabel.clipsToBounds = true;
            _replyCountLabel.textAlignment = NSTextAlignment.center;
            return _replyCountLabel;
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
        self.contentView.addSubview(self.replyCountLabel);
        self.replyCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.nodeNameLabel);
        self.nodeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-55);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }
        self.contentView.addSubview(self.titleLabel);
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.replyDescriptionLabel.snp.bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(20);
            //make.bottom.equalTo(self).offset(-10);
        }
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.creatorNameLabel.textColor = GuangGuColor.sharedInstance.getColor(node: "Default", name: "Up");
        }
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
    
    func setCount(_ count:Int ) -> Void {
        self.replyCountLabel.text = String(count);
        var width = 20;
        if (count >= 0 && count < 9)
        {
        }
        else if (count >= 10 && count < 99)
        {
            width = 25;
        }
        else
        {
            width = 30;
        }
        self.replyCountLabel.snp.updateConstraints({ (make) in
            make.width.equalTo(width);
        })
        self.setNeedsUpdateConstraints();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
