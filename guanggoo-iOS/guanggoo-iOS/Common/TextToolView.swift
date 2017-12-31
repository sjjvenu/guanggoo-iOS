//
//  TextToolView.swift
//  guanggoo-iOS
//
//  Created by 覃恳 on 31/12/2017.
//  Copyright © 2017 tdx. All rights reserved.
//

import UIKit
import SnapKit

class TextToolView: UIView {
    
    fileprivate var atSomeOneButton:UIButton!;

    init() {
        super.init(frame: CGRect.zero);
        
        let stackView = UIStackView.init();
        stackView.axis         = .horizontal
        stackView.alignment    = .center
        stackView.distribution = .equalSpacing
        self.addSubview(stackView);
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.bottom.equalTo(self);
        }
        
        self.atSomeOneButton = UIButton.init();
        self.atSomeOneButton.setBackgroundImage(UIImage.init(named: "ic_atsomeone"), for: .normal);
        self.atSomeOneButton.addTarget(self, action: #selector(TextToolView.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(atSomeOneButton);
        stackView.addArrangedSubview(self.atSomeOneButton);
        self.atSomeOneButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(self.atSomeOneButton.snp.height);
        }
        
        let audioButton = UIButton.init();
        audioButton.setBackgroundImage(UIImage.init(named: "ic_audio"), for: .normal);
        audioButton.addTarget(self, action: #selector(TextToolView.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(audioButton);
        stackView.addArrangedSubview(audioButton);
        audioButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(audioButton.snp.height);
        }
        
        let takePhotoButton = UIButton.init();
        takePhotoButton.setBackgroundImage(UIImage.init(named: "ic_takePhoto"), for: .normal);
        takePhotoButton.addTarget(self, action: #selector(TextToolView.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(takePhotoButton);
        stackView.addArrangedSubview(takePhotoButton);
        takePhotoButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(takePhotoButton.snp.height);
        }
        
        let photoButton = UIButton.init();
        photoButton.setBackgroundImage(UIImage.init(named: "ic_image"), for: .normal);
        photoButton.addTarget(self, action: #selector(TextToolView.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(photoButton);
        stackView.addArrangedSubview(photoButton);
        photoButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(photoButton.snp.height);
        }
        
        let commitButton = UIButton.init();
        commitButton.setBackgroundImage(UIImage.init(named: "ic_submit"), for: .normal);
        commitButton.addTarget(self, action: #selector(TextToolView.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(commitButton);
        stackView.addArrangedSubview(commitButton);
        commitButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(commitButton.snp.height);
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func AtSomeoneClick(sender: UIButton) {
        
    }
}
