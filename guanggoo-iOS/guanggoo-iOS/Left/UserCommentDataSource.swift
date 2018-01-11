//
//  UserCommentDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/26.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup
import Ji
import YYText

class UserCommentDataSource: NSObject {
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
        self.loadData(urlString: self.mURLString, loadNew: true);
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
                let nodes = rootNode?.xPath("//div[@class='reply-item']");
                if nodes!.count > 0
                {
                    for commentNode in nodes!
                    {
                        var item = GuangGuComent();
                        item.replyTime = (commentNode.xPath("div/span/a").first?.content)!;
                        item.replyLink = (commentNode.xPath("div/span/a").first?["href"])!;
                        
                        let commentAttributedString:NSMutableAttributedString = NSMutableAttributedString(string: "")
                        let contentNodes = commentNode.xPath("div[@class='main']/div[@class='content']/node()")
                        preformAttributedString(commentAttributedString, nodes: contentNodes, item, handle: { [weak self](url) in
                            
                            if url.contains("http") {
                                if url.contains(GUANGGUSITE + "t/") && !url.contains("/edit/"){
                                    var userLink = url;
                                    if userLink[userLink.startIndex] == "/" {
                                        userLink.removeFirst();
                                    }
                                    let msg = NSMutableDictionary.init();
                                    msg["MSGTYPE"] = "ContentPageViewController";
                                    msg["PARAM1"] = userLink;
                                    self?.vcDelegate?.OnPushVC(msg: msg);
                                }
                                else {
                                    let msg = NSMutableDictionary.init();
                                    msg["MSGTYPE"] = "PushViewController";
                                    let vc = CommWebViewController.init(url: URL.init(string: url));
                                    msg["PARAM1"] = vc;
                                    self?.vcDelegate?.OnPushVC(msg: msg);
                                }
                            }
                            else if url.contains("/u/") {
                                var userLink = url;
                                if userLink[userLink.startIndex] == "/" {
                                    userLink.removeFirst();
                                }
                                let msg = NSMutableDictionary.init();
                                msg["MSGTYPE"] = "UserInfoViewController";
                                msg["PARAM1"] = userLink;
                                self?.vcDelegate?.OnPushVC(msg: msg);
                            }
                            
                        });
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
    
    func reloadData(completion: @escaping () -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            self.loadData(urlString: self.mURLString, loadNew: true);
            DispatchQueue.main.async {
                completion();
            }
        }
    }
    
    func loadOlder(completion: @escaping () -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            self.pageCount += 1;
            self.loadData(urlString: self.mURLString + "?p=" + String(self.pageCount), loadNew: false);
            DispatchQueue.main.async {
                completion();
            }
        }
    }
}
