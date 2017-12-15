//
//  CenterViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/11.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SnapKit

class CenterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

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
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        return cell;
    }
}
