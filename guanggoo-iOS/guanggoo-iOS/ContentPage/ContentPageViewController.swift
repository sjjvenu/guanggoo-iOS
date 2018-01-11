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
import MBProgressHUD
import Alamofire
import Toast_Swift

let HTMLSTYLE = "<style>h1 {\n    font-weight: 500;\n    line-height: 140%;\n    margin: 5px 0px 15px 0px;\n    padding: 0px;\n}\n\nh2 {\n    font-weight: 500;\n    line-height: 100%;\n    margin: 20px 0px 20px 0px;\n    padding: 0px 0px 8px 0px;\n    border-bottom: 1px solid #e2e2e2;\n}\n\nh3 {\n    font-weight: 500;\n    line-height: 100%;\n    margin: 5px 0px 20px 0px;\n    padding: 0px;\n}\n\nhr {\n    border: none;\n    height: 1px;\n    margin-bottom: 1em;\n}\n\npre {\n    letter-spacing: 0.015em;\n    line-height: 120%;\n    padding: 0.5em;\n    margin: 0px;\n    white-space: pre;\n    overflow-x: auto;\n    overflow-y: auto;\n}\n\npre a {\n    color: inherit;\n    text-decoration: underline;\n}\n\ncode {\n    padding: 1px 2px 1px 2px;\n    border-radius: 2px;\n}\n\n\nul {\n    list-style: square;\n    margin: 1em 0px 1em 1em;\n    padding: 0px;\n}\n\nul li, ol li {\n    padding: 0px;\n    margin: 0px;\n}\n\nol {\n    margin: 1em 0px 0em 2em;\n    padding: 0px;\n}\n\na:link, a:visited, a:active {\n    text-decoration: none;\n    word-break: break-all;\n}\n\nimg {\n    max-width: 100%;\n}\n.imgly {\n    max-width: 100%;\n}\n/* *******************************    ******************************* */\nbody {\n    font-family: \'Helvetica\', monospace;\n    -webkit-text-size-adjust: none;\n    line-height: 1.75;\n    word-wrap: break-word;\n    max-height: 20em;\n    padding: 5px;\n}\n.subtle {\n    padding: 5px;\n}\n/* font-size */\nh1 {\n    font-size: 18.0px; /* Default 18 */\n}\n\nh2 {\n    font-size: 18.0px; /* Default 18 */\n}\n\nh3 {\n    font-size: 16.0px; /* Default 16 */\n}\n\npre {\n    font-size: 13.0px; /* Default 13 */\n}\n\nbody {\n    font-size: 14.0px; /* Default 14 */\n}\n.subtle {\n    font-size : 12.0px; /* Default 12 */\n}\n.subtle .fade {\n    font-size : 10.0px; /* Default 10 */\n}/* color */\n\na:link, a:visited, a:active {\n    color: #778087;\n}\nbody {\n    color: #000;\n    background-color:#FFF;\n}\n.subtle {\n/*    background-color: #F1F2F4;*/\n}\n.subtle .fade {\n    color:#ADADAD;\n}</style></head>"
let HTMLHEADER  = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">"


protocol GuangGuVCDelegate :class {
    func OnPushVC(msg:NSDictionary);
}

class ContentPageViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,GuangGuVCDelegate{
    
    //MARK: - init
    var contentData: ContentDataSource?;
    
    fileprivate var urlString:String!;
    fileprivate var itemModel:GuangGuStruct!
    fileprivate var webViewContentCell:CPHeaderTableViewCell? = nil;
    
    fileprivate var _rightButton:UIButton!
    fileprivate var rightButton:UIButton {
        get {
            guard _rightButton == nil else {
                return _rightButton;
            }
            _rightButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
            _rightButton.setImage(UIImage.init(named: "ic_unfavorite"), for: .normal);
            _rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 5, 0);
            _rightButton.addTarget(self, action: #selector(CenterViewController.rightClick(sender:)), for: .touchUpInside);
            return _rightButton;
        }
    }
    
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
            _tableView.mj_footer.isHidden = true;
            
            return _tableView;
        }
    }
    
    fileprivate var footLeftButton = UIButton.init();
    fileprivate var footRightButton = UIButton.init();
    fileprivate var _footView : UIView!
    fileprivate var footView : UIView {
        get {
            guard _footView == nil else {
                return _footView;
            }
            _footView = UIView.init();
            _footView.backgroundColor = UIColor.white;
            
            return _footView;
        }
    }
    
    fileprivate var atSomeoneView:DropdownView?
    fileprivate var atSomeoneViewHeight = 30;
    fileprivate var showAtSomeoneView = false;
    
    required init(urlString : String,model:GuangGuStruct?) {
        super.init(nibName: nil, bundle: nil);
        
        self.urlString = urlString;
        self.itemModel = model;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "主题详情";
        let footViewHeight = 50;
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-footViewHeight);
            } else {
                make.bottom.equalTo(self.view).offset(-footViewHeight);
            }
        }
        
        self.view.addSubview(self.footView);
        self.footView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.tableView.snp.bottom);
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin);
            } else {
                make.bottom.equalTo(self.view);
            }
        }
        self.footLeftButton.setTitle("@", for: .normal);
        self.footLeftButton.setTitleColor(UIColor.init(red: 75.0/255.0, green: 145.0/255.0, blue: 214.0/255.0, alpha: 1), for: .normal);
        self.footLeftButton.titleLabel?.font = UIFont.systemFont(ofSize: 30);
        self.footLeftButton.contentHorizontalAlignment = .left;
        self.footLeftButton.addTarget(self, action: #selector(ContentPageViewController.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.footView.addSubview(self.footLeftButton);
        self.footLeftButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.footView).offset(15);
            make.top.bottom.equalTo(self.footView);
            make.width.equalTo(self.footLeftButton.snp.height);
        }
        
        self.footView.addSubview(self.footRightButton);
        self.footRightButton.addTarget(self, action: #selector(ContentPageViewController.ReplyClick(sender:)), for: UIControlEvents.touchUpInside)
        self.footRightButton.setBackgroundImage(UIImage.init(named: "ic_reply"), for: .normal);
        //self.footRightButton.setImage(UIImage.init(named: "ic_reply"), for: .normal);
        //self.footRightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 5, 0);
        self.footRightButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.footView).offset(-15);
            make.centerY.equalTo(self.footView);
            make.width.height.equalTo(30);
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightButton);
        //解决mj下拉刷新出切出去，再切回来上拉头部没有回弹回去的问题
        self.navigationController?.navigationBar.isTranslucent = false;
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
                self.contentData = ContentDataSource.init(urlString: self.urlString,model: self.itemModel,delegate: self);
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                    if (self.contentData?.itemList.count)! >= (self.contentData?.headerModel?.replyCount)! {
                        self.endRefreshingWithNoMoreData()
                    }
                    if (self.contentData?.headerModel?.isFavorite)! {
                        self.rightButton.setImage(UIImage.init(named: "ic_favorite"), for: .normal);
                    }
                    self.tableView.mj_footer.isHidden = false;
                    self.reloadAtSomeoneView();
                    MBProgressHUD.hide(for: self.view, animated: true);
                }
            }
        }
    }
    

    //MARK: - UITableView Delegate DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.contentData != nil else {
            return 0;
        }
        switch section {
        case 0:
            return 1;
        case 1:
            if let count = self.contentData?.itemList.count, count > 0 {
                return count;
            }
            return 0;
        default:
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if let item = self.contentData?.headerModel {
                let titleWidth = item.title.width(withConstraintedHeight: 20, font: UIFont.systemFont(ofSize: 16));
                let labelWidth = UIScreen.main.bounds.size.width - 30;
                let lines = (Int)(titleWidth/labelWidth) + 1;
                return CGFloat(85+20*lines);
            }
            else
            {
                return 85+20;
            }
        case 1:
            return 0;
        default:
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if let item = self.contentData?.headerModel {
                let headerView = CPHeaderView.init();
                headerView.creatorNameLabel.text = item.creatorName;
                headerView.replyDescriptionLabel.text = item.creatTime;
                headerView.nodeNameLabel.text = item.node;
                headerView.setTitleContent(item.title);
                headerView.creatorImageView.sd_setImage(with: URL.init(string: item.creatorImg), completed: nil);
                headerView.creatorImageView.isUserInteractionEnabled = true;
                let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(ContentPageViewController.headUserNameClick(ges:)));
                headerView.creatorImageView.addGestureRecognizer(singleTap);
                headerView.titleLink = "http://www.guanggoo.com" + item.titleLink;
                headerView.vcDelegate = self;
                return headerView;
            }
            else {
                return nil;
            }
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
            if let count = self.contentData?.itemList.count,indexPath.row < count {
                let item = self.contentData?.itemList[indexPath.row];
                if BlackDataSource.shareInstance.itemList.contains(item!.creatorName) {
                    return 0;
                }
                else {
                    let layout = self.contentData?.itemList[indexPath.row].textLayout!
                    return layout!.textBoundingRect.size.height + 60;
                }
            }
            else {
                return 60;
            }
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
            if let item = self.contentData?.headerModel {
                self.webViewContentCell?.itemModel = item;
                self.webViewContentCell?.vcDelegate = self;
                self.webViewContentCell?.contentWebView.loadHTMLString(HTMLHEADER + HTMLSTYLE  + item.contentHtml + "</html>", baseURL: nil);
                //webview加载的时候刷新cell的height显示内容
                if self.webViewContentCell?.contentHeightChanged == nil {
                    self.webViewContentCell?.contentHeightChanged = { [weak self] (height:CGFloat) -> Void  in
                        if let weakSelf = self {
                            if let cell = weakSelf.webViewContentCell, weakSelf.tableView.visibleCells.contains(cell) {
                                if let height = weakSelf.webViewContentCell?.contentHeight, height > 1.5 * SCREEN_HEIGHT{
                                    UIView.animate(withDuration: 0, animations: { () -> Void in
                                        weakSelf.tableView.beginUpdates()
                                        weakSelf.tableView.endUpdates()
                                    })
                                }
                                else {
                                    weakSelf.tableView.beginUpdates()
                                    weakSelf.tableView.endUpdates()
                                }
                            }
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
            if let count = self.contentData?.itemList.count,indexPath.row < count {
                let item = self.contentData?.itemList[indexPath.row];
                cell?.creatorImageView.sd_setImage(with: URL.init(string: item!.creatorImg), completed: nil);
                cell?.creatorImageView.isUserInteractionEnabled = true;
                let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(ContentPageViewController.commentUserNameClick(ges:)));
                cell?.creatorImageView.addGestureRecognizer(singleTap);
                cell?.creatorImageView.tag = indexPath.row;
                cell?.creatorNameLabel.text = item!.creatorName;
                cell?.replyDescriptionLabel.text = item!.replyTime;
                cell?.floorLabel.text = String(indexPath.row+1)+"楼";
                cell?.itemModel = item;
                cell?.vcDelegate = self;
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
                if BlackDataSource.shareInstance.itemList.contains(item!.creatorName) {
                    cell?.isHidden = true;
                }
                else {
                    cell?.isHidden = false;
                }
            }
            
            return cell!;
        default:
            return UITableViewCell.init();
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //wkwebview过长时防止页面显示不全（特别是多图），强制刷新
        if let cell = self.webViewContentCell, self.tableView.visibleCells.contains(cell) {
            self.webViewContentCell?.contentWebView.setNeedsLayout()
        }
    }
    
    //MARK: - Event
    @objc func reloadItemData() -> Void {
        self.tableView.mj_footer.isHidden = false;
        self.contentData?.reloadData {
            self.tableView.mj_header.endRefreshing();
            self.tableView.mj_footer.resetNoMoreData();
            self.tableView.reloadData();
            self.reloadAtSomeoneView();
        };
    }
    
    @objc func nextPage() -> Void {
        if self.contentData?.itemList.count == 0 {
            self.endRefreshingWithNoDataAtAll()
            return;
        }
        if (self.contentData?.itemList.count)! >= (self.contentData?.headerModel?.replyCount)! {
            self.endRefreshingWithNoMoreData()
            return;
        }
        self.contentData?.loadOlder {
            self.tableView.mj_footer.endRefreshing();
            self.tableView.reloadData();
            self.reloadAtSomeoneView();
        }
    }
    
    @objc func headUserNameClick(ges:UIGestureRecognizer) -> Void {
        var userLink = self.contentData?.headerModel!.creatorLink;
        if userLink![userLink!.startIndex] == "/" {
            userLink?.removeFirst();
        }
        let vc = UserInfoViewController.init(urlString: GUANGGUSITE + userLink!);
        vc.vcDelegate = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @objc func commentUserNameClick(ges:UITapGestureRecognizer) -> Void {
        if let tag = ges.view?.tag,tag >= 0 && tag < self.contentData!.itemList.count {
            let item = self.contentData?.itemList[tag];
            var userLink = item?.creatorLink;
            if userLink![userLink!.startIndex] == "/" {
                userLink?.removeFirst();
            }
            let vc = UserInfoViewController.init(urlString: GUANGGUSITE + userLink!);
            vc.vcDelegate = self;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @objc func rightClick(sender: UIButton) {
        if let model = self.contentData?.headerModel {
            var requestURL = model.favoriteURL;
            if requestURL[requestURL.startIndex] == "/" {
                requestURL.removeFirst();
            }
            Alamofire.request(GUANGGUSITE + requestURL).responseJSON { [weak self](response) in
                switch(response.result) {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    let responseDic = JSON as! NSDictionary
                    if let success = responseDic["success"] as? Bool{
                        if success {
                            if model.isFavorite {
                                self?.view.makeToast("取消收藏成功!")
                                self?.contentData?.headerModel?.isFavorite = false;
                                self?.contentData?.headerModel?.favoriteURL = model.favoriteURL.replacingOccurrences(of: "unfavorite", with: "favorite");
                                self?.rightButton.setImage(UIImage.init(named: "ic_unfavorite"), for: .normal);
                            }
                            else {
                                self?.view.makeToast("收藏成功!")
                                self?.contentData?.headerModel?.isFavorite = true;
                                self?.contentData?.headerModel?.favoriteURL = model.favoriteURL.replacingOccurrences(of: "favorite", with: "unfavorite");
                                self?.rightButton.setImage(UIImage.init(named: "ic_favorite"), for: .normal);
                            }
                        }
                        else {
                            if let error = responseDic["message"] as? String{
                                self?.view.makeToast(error)
                            }
                        }
                    }
                    break;
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    break;
                }
            }
        }
    }
    
    @objc func AtSomeoneClick(sender: UIButton) {
        if self.showAtSomeoneView {
            self.atSomeoneView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0);
            })
        }
        else {
            self.atSomeoneView?.snp.updateConstraints({ (make) in
                make.height.equalTo(self.atSomeoneViewHeight);
            })
        }
        self.showAtSomeoneView = !self.showAtSomeoneView;
        self.view.setNeedsLayout();
    }
    
    @objc func ReplyClick(sender: UIButton) {
        let vc = ReplyContentViewController.init(string: "", urlString: self.urlString,nameArray:Array(self.contentData!.nameList)) { [weak self](bSuccess) in
            if bSuccess {
                self?.tableView.mj_header.beginRefreshing();
            }
        };
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func reloadAtSomeoneView() -> Void {
        self.atSomeoneView?.removeFromSuperview();
        self.atSomeoneView = nil;
        let nameArray = Array(self.contentData!.nameList)
        if nameArray.count > 0 {
            self.atSomeoneView = DropdownView.init(array: nameArray, handle: { [weak self](tableView, indexPath) in
                let name = nameArray[indexPath.row];
                self?.showAtSomeoneView = false;
                self?.atSomeoneView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(0);
                })
                let vc = ReplyContentViewController.init(string: "@"+name+" ", urlString:(self?.urlString)!,nameArray:nameArray){ [weak self](bSuccess) in
                    if bSuccess {
                        self?.tableView.mj_header.beginRefreshing();
                    }
                };
                self?.navigationController?.pushViewController(vc, animated: true);
            })
            if nameArray.count > 7 {
                self.atSomeoneViewHeight = 200;
            }
            else {
                self.atSomeoneViewHeight = 30 * nameArray.count;
            }
            self.showAtSomeoneView = false;
            self.view.addSubview(self.atSomeoneView!);
            self.atSomeoneView!.snp.makeConstraints({ (make) in
                make.left.equalTo(self.view);
                make.bottom.equalTo(self.footView.snp.top);
                make.width.equalTo(100);
                make.height.equalTo(0);
            })
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
    
    func OnPushVC(msg: NSDictionary) {
        if let msgtype = msg["MSGTYPE"] as? String {
            if msgtype == "PhotoBrowser" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "UserInfoViewController" {
                if case let urlString as String = msg["PARAM1"] {
                    let vc = UserInfoViewController.init(urlString: GUANGGUSITE + urlString);
                    vc.vcDelegate = self;
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "CenterViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "PushViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "PresentViewController" {
                if let vc = msg["PARAM1"] as? UIViewController{
                    self.navigationController?.present(vc, animated: true, completion: nil);
                }
            }
            else if msgtype == "AtSomeone" {
                if let name = msg["PARAM1"] as? String ,name.count > 0{
                    let vc = ReplyContentViewController.init(string: "@"+name+" ", urlString:(self.urlString)!,nameArray:Array(self.contentData!.nameList)){ [weak self](bSuccess) in
                        if bSuccess {
                            self?.tableView.mj_header.beginRefreshing();
                        }
                    };
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "EditComment" {
                if let item = msg["PARAM1"] as? GuangGuComent {
                    var replyLink = item.replyLink;
                    if replyLink[replyLink.startIndex] == "/" {
                        replyLink.removeFirst();
                    }
                    if let dic = self.contentData?.getContentDataByURL(urlString: GUANGGUSITE + replyLink,isComment: true) as NSDictionary?{
                        if let content = dic["Content"] as? String {
                            let vc = ReplyContentViewController.init(string: content, urlString: GUANGGUSITE + replyLink, nameArray: Array(self.contentData!.nameList), completion: { [weak self](bSuccess) in
                                if bSuccess {
                                    self?.tableView.mj_header.beginRefreshing();
                                }
                            })
                            self.navigationController?.pushViewController(vc, animated: true);
                        }
                    }
                }
            }
            else if msgtype == "EditTitle" {
                if let url = msg["PARAM1"] as? String {
                    if let dic = self.contentData?.getContentDataByURL(urlString: url,isComment: false) as NSDictionary?{
                        if let content = dic["Content"] as? String ,let title = dic["Title"] as? String{
                            let vc = CreateTitleViewController.init(title: title, content: content, urlString: url, completion: { [weak self](bSuccess) in
                                if bSuccess {
                                    self?.tableView.mj_header.beginRefreshing();
                                }
                            })
                            self.navigationController?.pushViewController(vc, animated: true);
                        }
                    }
                }
            }
            else if msgtype == "ReportComment" {
                if let floor = msg["PARAM1"] as? String ,floor.count > 0 ,var titleLink = self.contentData?.headerModel?.titleLink,titleLink.count > 0{
                    if titleLink.first == "/" {
                        titleLink.remove(at: titleLink.startIndex);
                    }
                    titleLink = GUANGGUSITE + titleLink;
                    let content = "@Caixin919 ,在主题[" + titleLink + "](" + titleLink + ")的" + floor+"有违规内容"
                    let vc = ReplyContentViewController.init(string: content, urlString:(self.urlString)!,nameArray:Array(self.contentData!.nameList)){ [weak self](bSuccess) in
                        if bSuccess {
                            self?.tableView.mj_header.beginRefreshing();
                        }
                    };
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "ReportTitle" {
                if var titleLink = self.contentData?.headerModel?.titleLink,titleLink.count > 0{
                    if titleLink.first == "/" {
                        titleLink.remove(at: titleLink.startIndex);
                    }
                    titleLink = GUANGGUSITE + titleLink;
                    let content = "@Caixin919 ,主题[" + titleLink + "](" + titleLink + ")有违规内容";
                    let vc = ReplyContentViewController.init(string: content, urlString:(self.urlString)!,nameArray:Array(self.contentData!.nameList)){ [weak self](bSuccess) in
                        if bSuccess {
                            self?.tableView.mj_header.beginRefreshing();
                        }
                    };
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
            else if msgtype == "ReloadData" {
                if let userName = msg["PARAM1"] as? String ,userName.count > 0 ,userName == self.contentData?.headerModel?.creatorName {
                    //如果屏蔽的是主题创建者，则退出详情页面
                    self.navigationController?.popViewController(animated: true);
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLACKLISTTOREFRESH), object: nil);
                }
                else {
                    self.tableView.mj_header.beginRefreshing();
                }
            }
            else if msgtype == "ReloadHomePage" {
                self.navigationController?.popViewController(animated: true);
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLACKLISTTOREFRESH), object: nil);
            }
            else if msgtype == "ContentPageViewController" {
                if case var urlString as String = msg["PARAM1"] {
                    if let index = urlString.index(of: "#") {
                        urlString = String(urlString[urlString.startIndex..<index])
                    }
                    let vc = ContentPageViewController.init(urlString: urlString,model:nil);
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
        }
    }
}
