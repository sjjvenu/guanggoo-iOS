//
//  NotificationViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/25.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import MJRefresh
import MBProgressHUD

class NotificationViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: - init
    weak var vcDelegate:GuangGuVCDelegate?
    var contentData: NotificationDataSource?;
    
    fileprivate var urlString:String!;
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .plain);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.white;
            
            _tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(CenterViewController.reloadItemData));
            _tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(CenterViewController.nextPage));
            _tableView.mj_footer.isHidden = true;
            
            return _tableView;
        }
    }
    
    required init(urlString : String) {
        super.init(nibName: nil, bundle: nil);
        
        self.urlString = urlString;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let yourBackImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.title = "我的消息";
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin);
            } else {
                make.bottom.equalTo(self.view);
            }
        }
        
        self.view.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "Default", name: "BackColor");
        self.navigationController?.navigationBar.barTintColor = GuangGuColor.sharedInstance.getColor(node: "TOPBAR", name: "BackColor");
        self.navigationController?.navigationBar.isTranslucent = false;
        if let color = GuangGuColor.sharedInstance.getColor(node: "TOPBAR", name: "TxtColor") {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color];
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if self.contentData == nil {
            MBProgressHUD.showAdded(to: self.view, animated: true);
            DispatchQueue.global(qos: .background).async {
                self.contentData = NotificationDataSource.init(urlString: self.urlString,delegate: self.vcDelegate);
                DispatchQueue.main.async {
                    self.tableView.mj_footer.isHidden = false;
                    self.tableView.reloadData();
                    if (self.contentData?.pageCount)! >= (self.contentData?.maxCount)! {
                        self.endRefreshingWithNoMoreData()
                    }
                    MBProgressHUD.hide(for: self.view, animated: true);
                }
            }
        }
    }
    
    
    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.contentData != nil else {
            return 0;
        }
        if let count = self.contentData?.itemList.count, count > 0 {
            return count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = self.contentData?.itemList.count,indexPath.row < count {
            let layout = self.contentData?.itemList[indexPath.row].textLayout!
            return layout!.textBoundingRect.size.height + 80;
        }
        return 80;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "CONTENTPAGECELL";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CPCommentTableViewCell;
        if cell == nil {
            cell = CPCommentTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        if let count = self.contentData?.itemList.count,indexPath.row < count {
            let item = self.contentData?.itemList[indexPath.row];
            cell?.creatorImageView.sd_setImage(with: URL.init(string: item!.creatorImg), completed: nil);
            cell?.creatorNameLabel.text = item!.creatorName;
            cell?.replyDescriptionLabel.text = "主题:" + item!.replyTime;
            cell?.replyDescriptionLabel.font = UIFont.systemFont(ofSize: 14);
            cell?.itemModel = item;
            cell?.vcDelegate = self.vcDelegate;
            if let layout = item?.textLayout {
                cell?.contentLabel.textLayout = layout
                if layout.attachments != nil {
                    for attachment in layout.attachments! {
                        if let image = attachment.content as? GuangGuAttachmentImage{
                            image.ggCommentDelegate = cell!.self
                        }
                    }
                }
            }
        }
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.mj_header.state == MJRefreshState.refreshing || tableView.mj_footer.state == MJRefreshState.refreshing {
            self.view.makeToast("请等待刷新完成!", duration: 1.0, position: .center)
            return;
        }
        let item = self.contentData?.itemList[indexPath.row];
        var titleLink = item?.replyLink;
        guard let count = titleLink?.count,count > 0 else {
            return;
        }
        if titleLink![titleLink!.startIndex] == "/" {
            titleLink!.removeFirst();
        }
        let link = titleLink!+"?p=1";
        let vc = ContentPageViewController.init(urlString: GUANGGUSITE+link,model:nil);
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //MARK: - Event
    @objc func reloadItemData() -> Void {
        self.tableView.mj_footer.isHidden = false;
        self.contentData?.reloadData {
            self.tableView.mj_header.endRefreshing();
            self.tableView.reloadData();
            self.tableView.mj_footer.resetNoMoreData();
        };
    }
    
    @objc func nextPage() -> Void {
        if self.contentData?.itemList.count == 0 {
            self.endRefreshingWithNoDataAtAll()
            return;
        }
        if (self.contentData?.pageCount)! >= (self.contentData?.maxCount)! {
            self.endRefreshingWithNoMoreData()
            return;
        }
        self.contentData?.loadOlder {
            self.tableView.mj_footer.endRefreshing();
            self.tableView.reloadData();
        }
    }
    
    /**
     禁用上拉加载更多，并显示一个字符串提醒
     */
    func endRefreshingWithStateString(_ string:String){
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    func endRefreshingWithNoDataAtAll() {
        self.endRefreshingWithStateString("暂无评论")
    }
    
    func endRefreshingWithNoMoreData() {
        self.endRefreshingWithStateString("没有更多评论了")
    }
}
