//
//  HomeViewController.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/5/10.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UIScrollViewDelegate ,MenuViewDelegate,GuangGuVCDelegate{
    
    fileprivate var helper:GuangGuHelpDelegate?;
    
    fileprivate var _menuView: MenuView!;
    fileprivate var menuView: MenuView {
        get {
            guard _menuView == nil else {
                return _menuView;
            }
            _menuView = MenuView.init(mneuViewStyle: MenuViewStyleLine, andTitles: ["默认排序","最新话题","精华主题"], hasMiddleLine: false);
            _menuView.bAutoLayout = true;
            _menuView.delegate = self;
            return _menuView;
        }
    }
    
    fileprivate var scrollView: UIScrollView!;
    fileprivate var _pageDefault: CenterViewController!;
    fileprivate var pageDefault: CenterViewController {
        get {
            guard _pageDefault == nil else {
                return _pageDefault;
            }
            _pageDefault = CenterViewController.init(urlString: GUANGGUSITE);
            _pageDefault.vcDelegate = self;
            return _pageDefault;
        }
    }
    
    fileprivate var _pageNew: CenterViewController!;
    fileprivate var pageNew: CenterViewController {
        get {
            guard _pageNew == nil else {
                return _pageNew;
            }
            _pageNew = CenterViewController.init(urlString: GUANGGUSITE + "?tab=latest");
            _pageNew.vcDelegate = self;
            return _pageNew;
        }
    }
    
    fileprivate var _pageExtract: CenterViewController!;
    fileprivate var pageExtract: CenterViewController {
        get {
            guard _pageExtract == nil else {
                return _pageExtract;
            }
            _pageExtract = CenterViewController.init(urlString: GUANGGUSITE + "?tab=elite");
            _pageExtract.vcDelegate = self;
            return _pageExtract;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.helper = GuangGuHelpDelegate();
        self.helper?.currentVC = self;
        self.helper?.vcDelegate = self;
        
        self.title = "光谷社区";
        
        var rect = self.view.frame;
        rect.origin.y = 0;
        
        rect.size.height = rect.size.height - (self.navigationController?.navigationBar.frame.size.height)!;
        var menuViewY = self.navigationController?.navigationBar.frame.size.height;
        if let fversion = Double(UIDevice.current.systemVersion),fversion >= 7.0
        {
            rect.size.height = rect.size.height - 20;
            menuViewY! += 20;
        }
        
        self.menuView.frame = CGRect.init(x: 0, y: 0, width: rect.size.width, height: 40);
        self.view.addSubview(self.menuView);
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.menuView.frame.origin.y+self.menuView.frame.size.height, width: rect.size.width, height: rect.size.height-self.menuView.frame.size.height));
        self.scrollView.backgroundColor = UIColor.clear;
        self.scrollView.isPagingEnabled = true;
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.delegate = self;
        self.scrollView.setContentOffset(CGPoint.zero, animated: true);
        self.scrollView.contentSize = CGSize.init(width: rect.size.width*3, height: rect.size.height-menuView.frame.size.height);
        self.view.addSubview(self.scrollView);
        
        self.pageDefault.view.frame = CGRect.init(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height);
        self.scrollView.addSubview(self.pageDefault.view);
        self.pageNew.view.frame = CGRect.init(x: self.scrollView.frame.size.width, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height);
        //self.scrollView.addSubview(self.pageNew.view);
        self.pageExtract.view.frame = CGRect.init(x: self.scrollView.frame.size.width*2, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height);
        //self.scrollView.addSubview(self.pageExtract.view);
        
        self.view.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "Default", name: "BackColor");
        self.menuView.kViewBackgroundColor = GuangGuColor.sharedInstance.getColor(node: "MenuView", name: "BackColor");
        self.menuView.kSelectedColor = GuangGuColor.sharedInstance.getColor(node: "MenuView", name: "SelectedTxtColor");
        self.menuView.kNomalColor = GuangGuColor.sharedInstance.getColor(node: "MenuView", name: "TxtColor");
        self.menuView.kUnderLineColorFlood = GuangGuColor.sharedInstance.getColor(node: "MenuView", name: "BottomLineColor");
        self.scrollView.backgroundColor = GuangGuColor.sharedInstance.getColor(node: "Default", name: "BackColor");

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let index = self.menuView.selecteIndex;
        if let vc = self.getSelectedViewController(index: NSInteger(index)) {
            vc.viewWillAppear(animated);
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        let index = self.menuView.selecteIndex;
        if let vc = self.getSelectedViewController(index: NSInteger(index)) {
            vc.viewWillDisappear(animated);
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let index = self.menuView.selecteIndex;
        if let vc = self.getSelectedViewController(index: NSInteger(index)) {
            vc.viewDidAppear(animated);
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let index = self.menuView.selecteIndex;
        if let vc = self.getSelectedViewController(index: NSInteger(index)) {
            vc.viewDidDisappear(animated);
        }
    }
    
    func getSelectedViewController(index:NSInteger) -> UIViewController? {
        switch index {
        case 0:
            return self.pageDefault;
        case 1:
            return self.pageNew;
        case 2:
            return self.pageExtract;
        default:
            return nil;
        }
    }
    
    func setSelectedViewController(index:Int) -> Void {
        self.pageDefault.view.removeFromSuperview();
        self.pageNew.view.removeFromSuperview();
        self.pageExtract.view.removeFromSuperview();
        if let vc = self.getSelectedViewController(index: NSInteger(index)) {
            self.scrollView.addSubview(vc.view);
            vc.viewWillAppear(true);
            vc.viewDidAppear(true);
        }
    }

    
    // MARK: - MenuViewDelegate
    func menuViewDelegate(_ menuciew: MenuView!, with index: Int32) {
        self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.bounds.size.width*CGFloat(index), y: self.scrollView.contentOffset.y), animated: true);
        self.setSelectedViewController(index: Int(index));
    }
    
    func clickSelectedDelegate(_ menuciew: MenuView!, with index: Int32) {
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int32(scrollView.contentOffset.x/UIScreen.main.bounds.size.width);
        let rate = scrollView.contentOffset.x/UIScreen.main.bounds.size.width;
        self.menuView.selectedBtnMoveToCenter(with: index, withRate: rate);
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int32(scrollView.contentOffset.x/UIScreen.main.bounds.size.width);
        let rate = scrollView.contentOffset.x/UIScreen.main.bounds.size.width;
        self.menuView.selectedBtnMoveToCenter(with: index, withRate: rate);
        self.setSelectedViewController(index: Int(index));
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width {
            return;
        }
        
        let Page = Int32(scrollView.contentOffset.x/UIScreen.main.bounds.size.width);
        
        if (Page == 0)
        {
            self.menuView.select(with: Page, andOtherIndex: Page+1);
        }
        else if (Page == 3 - 1)
        {
            self.menuView.select(with: Page, andOtherIndex: Page-1);
        }
        else
        {
            self.menuView.select(with: Page, andOtherIndex: Page+1);
            self.menuView.select(with: Page, andOtherIndex: Page-1);
        }
    }
    
    func OnPushVC(msg: NSDictionary) {
        self.helper?.OnPushHelp(msg);
    }
}
