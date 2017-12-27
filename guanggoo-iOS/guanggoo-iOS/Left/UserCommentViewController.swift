//
//  UserCommentViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/26.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import MBProgressHUD

class UserCommentViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: - init
    weak var vcDelegate:GuangGuVCDelegate?
    var contentData: UserCommentDataSource?;
    
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
            _tableView.mj_footer.isAutomaticallyHidden = true;
            
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
        self.view.backgroundColor = UIColor.white;
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin);
            } else {
                make.bottom.equalTo(self.view);
            }
        }
        self.tableView.mj_footer.isAutomaticallyHidden = true;
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
                self.contentData = UserCommentDataSource.init(urlString: self.urlString,delegate: self.vcDelegate);
                DispatchQueue.main.async {
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
        let layout = self.contentData?.itemList[indexPath.row].textLayout!
        return layout!.textBoundingRect.size.height + 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "CONTENTPAGECELL";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserCommentTableViewCell;
        if cell == nil {
            cell = UserCommentTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        let item = self.contentData?.itemList[indexPath.row];
        cell?.replyDescriptionLabel.text = "主题:" + item!.replyTime;
        cell?.replyDescriptionLabel.font = UIFont.systemFont(ofSize: 14);
        cell?.itemModel = item;
        cell?.vcDelegate = self.vcDelegate;
        if let layout = item?.textLayout {
            cell?.contentLabel.textLayout = layout
            if layout.attachments != nil {
                for attachment in layout.attachments! {
                    if let image = attachment.content as? GuangGuAttachmentImage{
                        image.delegate = cell!.self
                    }
                }
            }
        }
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //MARK: - Event
    @objc func reloadItemData() -> Void {
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
