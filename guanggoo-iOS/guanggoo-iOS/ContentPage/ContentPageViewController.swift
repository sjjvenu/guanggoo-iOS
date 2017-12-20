//
//  ContentPageViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/19.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import MJRefresh

let HTMLSTYLE = "<style>h1 {\n    font-weight: 500;\n    line-height: 140%;\n    margin: 5px 0px 15px 0px;\n    padding: 0px;\n}\n\nh2 {\n    font-weight: 500;\n    line-height: 100%;\n    margin: 20px 0px 20px 0px;\n    padding: 0px 0px 8px 0px;\n    border-bottom: 1px solid #e2e2e2;\n}\n\nh3 {\n    font-weight: 500;\n    line-height: 100%;\n    margin: 5px 0px 20px 0px;\n    padding: 0px;\n}\n\nhr {\n    border: none;\n    height: 1px;\n    margin-bottom: 1em;\n}\n\npre {\n    letter-spacing: 0.015em;\n    line-height: 120%;\n    padding: 0.5em;\n    margin: 0px;\n    white-space: pre;\n    overflow-x: auto;\n    overflow-y: auto;\n}\n\npre a {\n    color: inherit;\n    text-decoration: underline;\n}\n\ncode {\n    padding: 1px 2px 1px 2px;\n    border-radius: 2px;\n}\n\n\nul {\n    list-style: square;\n    margin: 1em 0px 1em 1em;\n    padding: 0px;\n}\n\nul li, ol li {\n    padding: 0px;\n    margin: 0px;\n}\n\nol {\n    margin: 1em 0px 0em 2em;\n    padding: 0px;\n}\n\na:link, a:visited, a:active {\n    text-decoration: none;\n    word-break: break-all;\n}\n\nimg {\n    max-width: 100%;\n}\n.imgly {\n    max-width: 100%;\n}\n/* *******************************    ******************************* */\nbody {\n    font-family: \'Helvetica\', monospace;\n    -webkit-text-size-adjust: none;\n    line-height: 1.75;\n    word-wrap: break-word;\n    max-height: 20em;\n    padding: 5px;\n}\n.subtle {\n    padding: 5px;\n}\n/* font-size */\nh1 {\n    font-size: 18.0px; /* Default 18 */\n}\n\nh2 {\n    font-size: 18.0px; /* Default 18 */\n}\n\nh3 {\n    font-size: 16.0px; /* Default 16 */\n}\n\npre {\n    font-size: 13.0px; /* Default 13 */\n}\n\nbody {\n    font-size: 14.0px; /* Default 14 */\n}\n.subtle {\n    font-size : 12.0px; /* Default 12 */\n}\n.subtle .fade {\n    font-size : 10.0px; /* Default 10 */\n}/* color */\n\na:link, a:visited, a:active {\n    color: #778087;\n}\nbody {\n    color: #000;\n    background-color:#FFF;\n}\n.subtle {\n/*    background-color: #F1F2F4;*/\n}\n.subtle .fade {\n    color:#ADADAD;\n}</style></head>"
let HTMLHEADER  = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">"


class ContentPageViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: - init
    var contentData: ContentDataSource?;
    fileprivate var webViewContentCell:CPHeaderTableViewCell? = nil;
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView: UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init(frame: CGRect.zero, style: .grouped);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor = UIColor.white;
            
            _tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(CenterViewController.reloadItemData));
            _tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(CenterViewController.nextPage));
            
            return _tableView;
        }
    }
    
    required init(urlString : String,model:GuangGuStruct) {
        super.init(nibName: nil, bundle: nil);
        self.contentData = ContentDataSource.init(urlString: urlString,model: model);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1;
        case 1:
            return (self.contentData?.itemList.count)!;
        default:
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            let item = self.contentData?.headerModel
            let titleWidth = item?.title.width(withConstraintedHeight: 20, font: UIFont.systemFont(ofSize: 16));
            let labelWidth = UIScreen.main.bounds.size.width - 30;
            let lines = (Int)(titleWidth!/labelWidth) + 1;
            return CGFloat(85+20*lines);
        case 1:
            return 0;
        default:
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headeView = CPHeaderView.init();
            let item = self.contentData?.headerModel;
            headeView.creatorNameLabel.text = item?.creatorName;
            headeView.replyDescriptionLabel.text = (item?.creatTime)!;
            headeView.nodeNameLabel.text = item?.node;
            headeView.setTitleContent((item?.title)!);
            headeView.creatorImageView.sd_setImage(with: URL.init(string: (item?.creatorImg)!), completed: nil);
            return headeView;
        case 1:
            return nil;
        default:
            return nil;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if self.webViewContentCell != nil {
                return (self.webViewContentCell?.contentHeight)!;
            }
            return 1;
        case 1:
            return 100;
        default:
            return 50;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if self.webViewContentCell == nil {
                self.webViewContentCell = CPHeaderTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "WEBVIEWCELL");
            }
            let item = self.contentData?.headerModel;
            self.webViewContentCell?.contentWebView.loadHTMLString(HTMLHEADER + HTMLSTYLE  + (item?.contentHtml)! + "</html>", baseURL: nil);
            //webview加载的时候刷新cell的height显示内容
            if self.webViewContentCell?.contentHeightChanged == nil {
                self.webViewContentCell?.contentHeightChanged = { [weak self] (height:CGFloat) -> Void  in
                    if let weakSelf = self {
                        if weakSelf.tableView.visibleCells.contains((weakSelf.webViewContentCell!)) {
                            weakSelf.tableView.beginUpdates();
                            weakSelf.tableView.reloadRows(at: [indexPath], with: .none);
                            weakSelf.tableView.endUpdates();
                        }
                    }
                }
            }
            return self.webViewContentCell!;
        case 1:
            let identifier = "CONTENTPAGECELL";
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CPCommentTableViewCell;
            if cell == nil {
                cell = CPCommentTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
            }
            let item = self.contentData?.itemList[indexPath.row];
            cell?.creatorImageView.sd_setImage(with: URL.init(string: item!.creatorImg), completed: nil);
            cell?.creatorNameLabel.text = item!.creatorName;
            cell?.replyDescriptionLabel.text = item!.replyTime;
            return cell!;
        default:
            return UITableViewCell.init();
        }
        
    }
    
    //MARK: - Event
    @objc func reloadItemData() -> Void {
        self.contentData?.reloadData {
            self.tableView.mj_header.endRefreshing();
            self.tableView.reloadData();
        };
    }
    
    @objc func nextPage() -> Void {
        if self.contentData?.itemList.count == 0 {
            self.endRefreshingWithNoDataAtAll()
            return;
        }
        if (self.contentData?.itemList.count)! >= (self.contentData?.headerModel.replyCount)! {
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
