//
//  LeftViewTableViewCell.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/22.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit

class LeftViewTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews();
        
        var frame = self.textLabel?.frame;
        frame = CGRect.init(x: 30, y: frame!.origin.y, width: frame!.size.width, height: frame!.size.height);
        self.textLabel?.frame = frame!;
    }
}
