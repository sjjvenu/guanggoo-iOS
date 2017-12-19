//
//  HomePageDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/18.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup


struct GuangGuStruct {
    var title = "";                                 //回复内容
    var titleLink = "";                             //内容链接
    var creatorImg = "";                            //创建者头像
    var creatorName = "";                           //创建者名称
    var creatTime = "";                             //创建时间
    var creatorLink = "";                           //创建者链接
    var lastReplyName = "";                         //最后回复者名称
    var lastReplyLink = "";                         //最后回复者链接
    var replyDescription = "";                      //回复时间
    var node = "";                                  //所属节点
    var replyCount:Int = 0;                         //回复数
    var contentHtml = "";                           //html内容
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

class HomePageDataSource: NSObject {
    
    fileprivate var homePageString = "";
    var itemList = [GuangGuStruct]();
    fileprivate var pageCount:Int = 0;
    
    required init(urlString: String) {
        super.init();
        guard urlString.count > 0 else {
            return;
        }
        self.homePageString = urlString;
        self.pageCount = 1;
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
                let classes = try doc.getElementsByClass("topic-item");
                for object in classes
                {
                    let topicItemElement = try object.select("img");
                    let topicItemImageSrc: String = try topicItemElement.attr("src")
                    
                    let titleElements = try object.getElementsByClass("title");
                    let titleText = try titleElements.text();
                    let titleElement = try titleElements.select("a");
                    let titleHref: String = try titleElement.attr("href")
                    
                    let metaElements = try object.getElementsByClass("node");
                    let nodeText = try metaElements.text();
                    
                    let userNameElements = try object.getElementsByClass("username");
                    let userNameText = try userNameElements.text();
                    let userNameElement = try userNameElements.select("a");
                    let userNameHref: String = try userNameElement.attr("href")
                    
                    let lastTouchedElements = try object.getElementsByClass("last-touched");
                    let lastTouchedText = try lastTouchedElements.text();
                    
                    let lastReplyElements = try object.getElementsByClass("last-reply-username");
                    let lastReplyText = try lastReplyElements.text();
                    let lastReplyElement = try lastReplyElements.select("a");
                    let lastReplyHref: String = try lastReplyElement.attr("href")
                    
                    let countElements = try object.getElementsByClass("count");
                    let countText = try countElements.text();
                    
                    var item = GuangGuStruct();
                    item.title = titleText;
                    item.titleLink = titleHref;
                    item.node = nodeText;
                    item.creatorImg = topicItemImageSrc;
                    item.creatorName = userNameText;
                    item.creatorLink = userNameHref;
                    item.lastReplyName = lastReplyText;
                    item.lastReplyLink = lastReplyHref;
                    item.replyCount = (countText as NSString).integerValue;
                    item.replyDescription = lastTouchedText;
                    itemList.append(item);
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
        loadData(urlString: self.homePageString, loadNew: true);
        completion();
    }
    
    func loadOlder(completion: () -> Void) -> Void {
        self.pageCount += 1;
        loadData(urlString: self.homePageString + "?p=" + String(self.pageCount), loadNew: false);
        completion();
    }
}
