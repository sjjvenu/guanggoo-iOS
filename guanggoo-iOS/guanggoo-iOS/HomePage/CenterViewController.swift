//
//  CenterViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/11.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class CenterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    fileprivate let homePageData = HomePageDataSource.init(urlString: "http://www.guanggoo.com/");

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarItem();
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        appDelegate.drawController?.openDrawerGestureModeMask = .panningCenterView
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        appDelegate.drawController?.openDrawerGestureModeMask = []
//    }
    
    func setNavBarItem() -> Void {
        let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        leftButton.setImage(UIImage.init(named: "ic_menu_36pt"), for: .normal);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton);
        leftButton.addTarget(self, action: #selector(CenterViewController.leftClick(sender:)), for: .touchUpInside);
    }

    @objc func leftClick(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawController?.toggleLeftDrawerSide(animated: true, completion: nil);
    }
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init();
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.white;
            
            return _tableView;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homePageData.itemList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.homePageData.itemList[indexPath.row];
        let titleWidth = item.title.width(withConstraintedHeight: 20, font: UIFont.systemFont(ofSize: 16));
        let labelWidth = UIScreen.main.bounds.size.width - 30;
        let lines = (Int)(titleWidth/labelWidth) + 1;
        return CGFloat(85+20*lines);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HOMEPAGECELL";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomePageTableViewCell;
        if cell == nil {
            cell = HomePageTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        let item = self.homePageData.itemList[indexPath.row];
        cell?.creatorNameLabel.text = item.creatorName;
        cell?.replyDescriptionLabel.text = item.replyDescription + "  " + item.lastReplyName;
        cell?.setCount(item.replyCount);
        cell?.nodeNameLabel.text = item.node;
        cell?.setTitleContent(item.title);
        cell?.creatorImageView.sd_setImage(with: URL.init(string: item.creatorImg), completed: nil);
        return cell!;
    }
}
