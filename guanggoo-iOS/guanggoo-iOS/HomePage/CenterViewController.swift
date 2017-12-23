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
import MJRefresh

class CenterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,GuangGuVCDelegate{
    //MARK: - init
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    fileprivate let homePageData = HomePageDataSource.init(urlString: GUANGGUSITE);
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
            
            _tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(CenterViewController.reloadItemData));
            _tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(CenterViewController.nextPage));
            
            return _tableView;
        }
    }
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "全部";
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
    //首页消失时去除右滑打开左边页面手势，出现时恢复手势操作
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.drawController?.openDrawerGestureModeMask = .panningCenterView
    }
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.drawController?.openDrawerGestureModeMask = []
    }
    
    func setNavBarItem() -> Void {
        let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        leftButton.setImage(UIImage.init(named: "ic_menu_36pt"), for: .normal);
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton);
        leftButton.addTarget(self, action: #selector(CenterViewController.leftClick(sender:)), for: .touchUpInside);
        
        let rightButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        rightButton.setImage(UIImage.init(named: "ic_more_horiz_36pt"), for: .normal);
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton);
        rightButton.addTarget(self, action: #selector(CenterViewController.rightClick(sender:)), for: .touchUpInside);
    }
    
    //MARK: - UITableView Delegate DataSource
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if GuangGuAccount.shareInstance.isLogin() {
            let item = self.homePageData.itemList[indexPath.row];
            var titleLink = item.titleLink;
            guard titleLink.count > 0 else {
                return;
            }
            if titleLink[titleLink.startIndex] == "/" {
                titleLink.removeFirst();
            }
            let index = titleLink.index(of: "#");
            let link = titleLink[titleLink.startIndex..<index!];
            let vc = ContentPageViewController.init(urlString: GUANGGUSITE+link,model:item);
            self.navigationController?.pushViewController(vc, animated: true);
        }
        else {
            let vc = LoginViewController.init(completion: { [weak self] (loginSuccess) in
                if let weakSelf = self, loginSuccess {
                    let item = weakSelf.homePageData.itemList[indexPath.row];
                    var titleLink = item.titleLink;
                    guard titleLink.count > 0 else {
                        return;
                    }
                    if titleLink[titleLink.startIndex] == "/" {
                        titleLink.removeFirst();
                    }
                    let index = titleLink.index(of: "#");
                    let link = titleLink[titleLink.startIndex..<index!];
                    let vc = ContentPageViewController.init(urlString: GUANGGUSITE+link,model:item);
                    weakSelf.navigationController?.pushViewController(vc, animated: true);
                    weakSelf.homePageData.reloadData(completion: {weakSelf.tableView.reloadData()});
                }
            })
            vc.vcDelegate = self;
            //self.navigationController?.pushViewController(vc, animated: true);
            self.present(vc, animated: true, completion: nil);
        }
        
    }
    
    //MARK: - Event
    @objc func leftClick(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawController?.toggleLeftDrawerSide(animated: true, completion: nil);
    }
    
    @objc func rightClick(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawController?.toggleRightDrawerSide(animated: true, completion: nil);
    }
    
    @objc func reloadItemData() -> Void {
        self.homePageData.reloadData {
            self.tableView.mj_header.endRefreshing();
            self.tableView.reloadData();
        };
    }
    
    @objc func nextPage() -> Void {
        self.homePageData.loadOlder {
            self.tableView.mj_footer.endRefreshing();
            self.tableView.reloadData();
        }
    }
    
    func OnPushVC(msg: NSDictionary) {
        if let msgtype = msg["MSGTYPE"] as? String {
            if msgtype == "LoginViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "PresentViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "reloadData" {
                self.homePageData.reloadData(completion: {self.tableView.reloadData()});
            }
            else if msgtype == "GotoHomePage" {
                self.navigationController?.popToRootViewController(animated: true);
                self.homePageData.reloadData(completion: {self.tableView.reloadData()});
            }
        }
    }
}
