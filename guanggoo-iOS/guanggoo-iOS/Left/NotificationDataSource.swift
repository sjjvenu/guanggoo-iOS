//
//  NotificationDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/25.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup
import Ji
import YYText

class NotificationDataSource: NSObject {
    weak var vcDelegate:GuangGuVCDelegate?
    fileprivate var mURLString = "";
    var itemList = [GuangGuComent]();
    var pageCount:Int = 0;
    var maxCount:Int = 1;
    
    required init(urlString: String,delegate:GuangGuVCDelegate?) {
        super.init();
        guard urlString.count > 0 else {
            return;
        }
        self.mURLString = urlString;
        self.pageCount = 1;
        self.vcDelegate = delegate;
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
            self.maxCount = 1;
        }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            
            do{
                let jiDoc = Ji(htmlString: myHTMLString);
                let rootNode = jiDoc?.rootNode;
                let nodes = rootNode?.xPath("//div[@class='notification-item']");
                if nodes!.count > 0
                {
                    for commentNode in nodes!
                    {
                        var item = GuangGuComent();
                        item.creatorImg = (commentNode.xPath("a/img").first?["src"])!;
                        item.creatorName = (commentNode.xPath("div/span/a").first?.content)!;
                        item.creatorLink = (commentNode.xPath("a").first?["href"])!;
                        item.replyTime = (commentNode.xPath("div/span/a[2]").first?.content)!;
                        item.replyLink = (commentNode.xPath("div/span/a[2]").first?["href"])!;
                        
                        let commentAttributedString:NSMutableAttributedString = NSMutableAttributedString(string: "")
                        let contentNodes = commentNode.xPath("div[@class='main']/div[@class='content']/node()")
                        ContentDataSource.preformAttributedString(commentAttributedString, nodes: contentNodes,item,delegate:self.vcDelegate)
                        item.textAttributedString = commentAttributedString;
                        let textContainer = YYTextContainer(size: CGSize(width: SCREEN_WIDTH - 30, height: 9999))
                        item.textLayout = YYTextLayout(container: textContainer, text: commentAttributedString)
                        self.itemList.append(item);
                    }
                }
                
                let doc: Document = try SwiftSoup.parse(myHTMLString);
                //页数
                let pageElements = try doc.getElementsByClass("pagination");
                for object in pageElements {
                    let elements = try object.select("li");
                    if elements.array().count > 1 {
                        let maxPageElement = elements.array()[elements.array().count-2];
                        let maxPageText = try maxPageElement.select("a").text();
                        if let count = Int(maxPageText),count > 0 {
                            self.maxCount = count;
                        }
                    }
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
        loadData(urlString: self.mURLString, loadNew: true);
        completion();
    }
    
    func loadOlder(completion: () -> Void) -> Void {
        self.pageCount += 1;
        loadData(urlString: self.mURLString + "?p=" + String(self.pageCount), loadNew: false);
        completion();
    }
}
