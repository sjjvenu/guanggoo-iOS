//
//  InterestViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/12/5.
//  Copyright © 2018 tdx. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class InterestViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,GuangGuVCDelegate {
    
    fileprivate let btnHeight = 26;
    fileprivate let sectionProduce = 1000;
    fileprivate var helper:GuangGuHelpDelegate?;
    
    fileprivate var nodesList = [[GuangGuNode]]();

    func getNodeData() -> [[GuangGuNode]] {
        let nodes = NodesDataSource.init(urlString: GUANGGUSITE + "nodes", bInsertAll: false);
        guard nodes.itemList.count != 0 else {
            return [[GuangGuNode]]();
        }
        var dic = [String:[GuangGuNode]]();
        for node in nodes.itemList {
            if dic.keys.contains(node.category) == false {
                dic[node.category] = [GuangGuNode]();
            }
            dic[node.category]?.append(node);
        }
        var list = [[GuangGuNode]]();
        for element in dic.values {
            list.append(element);
        }
        return list.reversed();
    }
    
    fileprivate var _tableView: UITableView!;
    fileprivate var tableView:UITableView {
        get {
            guard _tableView == nil else {
                return _tableView;
            }
            
            _tableView = UITableView.init();
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.separatorStyle = .none;
            
            _tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(InterestViewController.reloadData));
            
            return _tableView;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if self.nodesList.count == 0 {
            MBProgressHUD.showAdded(to: self.view, animated: true);
            DispatchQueue.global(qos: .background).async {
                self.nodesList = self.getNodeData();
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                    MBProgressHUD.hide(for: self.view, animated: true);
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let yourBackImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.title = " 兴趣节点";
        self.helper = GuangGuHelpDelegate();
        self.helper?.currentVC = self;
        self.helper?.vcDelegate = self;
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        
        self.view.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "Default", name: "BackColor");
        self.navigationController?.navigationBar.barTintColor = GuangGuColor.sharedInstance.getColor(node: "TOPBAR", name: "BackColor");
        self.navigationController?.navigationBar.isTranslucent = false;
        if let color = GuangGuColor.sharedInstance.getColor(node: "TOPBAR", name: "TxtColor") {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color];
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nodesList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init();
        let list = self.nodesList[section];
        let titleLabel = UILabel.init();
        titleLabel.textColor = GuangGuColor.sharedInstance.getColor(node: "Interest", name: "HeadTxtColor");
        titleLabel.text = list[0].category;
        titleLabel.font = UIFont.systemFont(ofSize: 15);
        view.addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(16);
            make.bottom.right.equalTo(view);
            make.height.equalTo(20);
        }
        return view;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let list = self.nodesList[indexPath.section];
        return CGFloat((Int((list.count-1)/4)+1)*(10+btnHeight));
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "INTERESTVIECELL";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier);
        }
        for view in (cell?.contentView.subviews)! {
            view.removeFromSuperview();
        }
        let list = self.nodesList[indexPath.section];
        let btnWidth = (SCREEN_WIDTH-16*2-12*3)/4;
        for i in 0..<list.count {
            let button = UIButton.init(frame: CGRect.init(x: Int(16+(12+btnWidth)*CGFloat(i%4)), y: 10+Int(i/4)*(10+btnHeight), width: Int(btnWidth), height: btnHeight));
            button.setTitle(list[i].name, for: .normal);
            button.setTitleColor(GuangGuColor.sharedInstance.getColor(node: "Interest", name: "CtrlTxtColor"), for: .normal);
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12);
            button.layer.borderColor = GuangGuColor.sharedInstance.getColor(node: "Interest", name: "BorderColor")?.cgColor;
            button.layer.borderWidth = 1;
            button.tag = self.sectionProduce*indexPath.section + i;
            button.addTarget(self, action: #selector(InterestViewController.buttonClick(sender:)), for: .touchUpInside);
            cell?.contentView.addSubview(button);
        }
        return cell!;
    }
    
    // MARK: - Refresh
    
    @objc func reloadData() -> Void {
        DispatchQueue.global(qos: .background).async {
            self.nodesList = self.getNodeData();
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing();
                self.tableView.reloadData();
            }
        }
    }
    
    @objc func buttonClick(sender:UIButton) -> Void {
        let section = sender.tag/self.sectionProduce;
        let index = sender.tag - self.sectionProduce*section;
        let list = self.nodesList[section];
        let item = list[index]
        var nodeString = item.link;
        //self.createTitleButton?.isHidden = true;
        //除去全部节点
        if nodeString.count > 0 {
            if nodeString[nodeString.startIndex] == "/" {
                nodeString.removeFirst();
            }
        }
        if GuangGuAccount.shareInstance.isLogin() {
            let vc = CenterViewController.init(urlString: GUANGGUSITE + nodeString);
            vc.title = item.name;
            vc.vcDelegate = self;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        else
        {
            let vc = LoginViewController.init(completion: { [weak self] (loginSuccess) in
                if let weakSelf = self, loginSuccess {
                    let vc = CenterViewController.init(urlString: GUANGGUSITE + nodeString);
                    vc.title = item.name;
                    vc.vcDelegate = weakSelf;
                    weakSelf.navigationController?.pushViewController(vc, animated: true);
                }
                else {
                }
            })
            //vc.vcDelegate = self;
            self.present(vc, animated: true, completion: nil);
        }
    }

    
    func OnPushVC(msg: NSDictionary) {
        self.helper?.OnPushHelp(msg);
    }
}
