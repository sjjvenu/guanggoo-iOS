//
//  ContentDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/19.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup

struct GuangGuComent {
    var creatorImg = "";                            //创建者头像
    var creatorName = "";                           //创建者名称
    var creatorLink = "";                           //创建者链接
    var replyTime = "";                             //回复时间
    var contentHtml = "";                           //html内容
}

class ContentDataSource: NSObject {
    fileprivate var contentPageString = "";
    fileprivate var _headerModel: GuangGuStruct!
    //read only property
    var headerModel :GuangGuStruct {
        guard _headerModel == nil else {
            return _headerModel;
        }
        _headerModel = GuangGuStruct();
        return _headerModel;
    }
    var itemList = [GuangGuComent]();
    fileprivate var pageCount:Int = 0;
    
    required init(urlString: String,model:GuangGuStruct) {
        super.init();
        guard urlString.count > 0 else {
            return;
        }
        self.contentPageString = urlString;
        self.pageCount = 1;
        self._headerModel = model;
        reloadData {};
    }
    
    func loadData(urlString:String,loadNew:Bool) -> Void {
        guard let myURL = URL(string: urlString) else {
            print("Error: \(urlString) doesn't seem to be a valid URL");
            return
        }
        if (loadNew)
        {
            self.itemList.removeAll();
            self.pageCount = 1;
        }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            
            do{
                let doc: Document = try SwiftSoup.parse(myHTMLString)
                let headerClasses = try doc.getElementsByClass("topic-detail container-box");
                for object in headerClasses
                {
                    let contentElements = try object.getElementsByClass("ui-content");
                    let contentHtml = try contentElements.html();
                    self._headerModel.contentHtml = contentHtml;
                    
                    let createTimeElements = try object.getElementsByClass("created-time");
                    let createTime = try createTimeElements.text();
                    self._headerModel.creatTime = createTime;
                    break;
                }
                
                let classes = try doc.getElementsByClass("reply-item");
                for object in classes
                {
                    let topicItemElement = try object.select("img");
                    let topicItemImageSrc: String = try topicItemElement.attr("src")
                    
                    let contentElements = try object.getElementsByClass("content");
                    let contentHtml = try contentElements.html();
                    
                    let userNameElements = try object.getElementsByClass("reply-username");
                    let userNameText = try userNameElements.text();
                    let userNameElement = try userNameElements.select("a");
                    let userNameHref: String = try userNameElement.attr("href")
                    
                    let replyTimeElements = try object.getElementsByClass("time");
                    let replyTimeText = try replyTimeElements.text();
                    
                    var item = GuangGuComent();
                    item.creatorImg = topicItemImageSrc;
                    item.creatorName = userNameText;
                    item.creatorLink = userNameHref;
                    item.replyTime = replyTimeText;
                    item.contentHtml = contentHtml;
                    self.itemList.append(item);
                }
            }catch Exception.Error(let type, let message)
            {
                print("Type:\(type) Error:\(message)");
            }catch{
                print("error");
            }
            
        } catch let error {
            print("Error: \(error)");
        }
    }
    
    func reloadData(completion: () -> Void) -> Void {
        loadData(urlString: self.contentPageString, loadNew: true);
        completion();
    }
    
    func loadOlder(completion: () -> Void) -> Void {
        self.pageCount += 1;
        loadData(urlString: self.contentPageString + "?p=" + String(self.pageCount), loadNew: false);
        completion();
    }
}
