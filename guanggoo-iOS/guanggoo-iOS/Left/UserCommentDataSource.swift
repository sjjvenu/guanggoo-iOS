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
                        self.preformAttributedString(commentAttributedString, nodes: contentNodes,item)
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
    
    func preformAttributedString(_ commentAttributedString:NSMutableAttributedString,nodes:[JiNode],_ model:GuangGuComent) {
        for element in nodes {
            if element.name == "text" , var content = element.content{//普通文本
                content = content.replacingOccurrences(of: "\t", with: "")
                content = content.replacingOccurrences(of: "                            ", with: "")
                //content = content.replacingOccurrences(of: "\n\n", with: "\n")
                commentAttributedString.append(NSMutableAttributedString(string: content,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14) , NSAttributedStringKey.foregroundColor:UIColor.black]))
                commentAttributedString.yy_lineSpacing = 5
            }
                
                
            else if element.name == "img" ,let imageURL = element["src"]  {//图片
                let image = GuangGuAttachmentImage()
                image.imageURL = imageURL
                let imageAttributedString = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFit , attachmentSize: CGSize(width: 80,height: 80), alignTo: UIFont.systemFont(ofSize: 14), alignment: .bottom)
                
                commentAttributedString.append(imageAttributedString)
                
                image.index = model.images.count
                model.images.add(imageURL)
            }
                
                
            else if element.name == "a" ,let content = element.content,let url = element["href"]{//超链接
                //递归处理所有子节点,主要是处理下 a标签下包含的img标签
                let subNodes = element.xPath("./node()")
                if subNodes.first?.name != "text" && subNodes.count > 0 {
                    self.preformAttributedString(commentAttributedString, nodes: subNodes,model)
                }
                if content.count > 0 {
                    let attr = NSMutableAttributedString(string: content ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
                    attr.yy_setTextHighlight(NSMakeRange(0, content.count),
                                             color: UIColor.lightGray,
                                             backgroundColor: UIColor(white: 0.95, alpha: 1),
                                             userInfo: ["url":url],
                                             tapAction: { [weak self](view, text, range, rect) -> Void in
                                                if let highlight = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(range.location)) ,let url = (highlight as AnyObject).userInfo["url"] as? String  {
                                                    if url.contains("http") {
                                                        let msg = NSMutableDictionary.init();
                                                        msg["MSGTYPE"] = "PushViewController";
                                                        let vc = CommWebViewController.init(url: URL.init(string: url));
                                                        msg["PARAM1"] = vc;
                                                        self?.vcDelegate?.OnPushVC(msg: msg);
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
                                                }
                                                
                        }, longPressAction: nil)
                    commentAttributedString.append(attr)
                }
            }
                
            else if let content = element.content{//其他
                let subElement = element.xPath("a/node()")
                if subElement.first?.name != "text" && subElement.count > 0 {
                    //img隐藏在<p><a>下
                    self.preformAttributedString(commentAttributedString, nodes: subElement,model);
                }
                else
                {
                    let subImgElement = element.xPath("node()")
                    if subImgElement.first?.name != "text" && subImgElement.count > 0 {
                        //img隐藏在<p><a>下
                        self.preformAttributedString(commentAttributedString, nodes: subImgElement,model);
                    }
                    else {
                        commentAttributedString.append(NSMutableAttributedString(string: content,attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.black]))
                    }
                }
            }
        }
    }
}
