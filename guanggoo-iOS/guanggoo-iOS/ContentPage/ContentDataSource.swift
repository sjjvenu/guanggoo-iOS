//
//  ContentDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/19.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup
import Ji
import YYText
import Kingfisher

struct GuangGuComent {
    var creatorImg = "";                            //创建者头像
    var creatorName = "";                           //创建者名称
    var creatorLink = "";                           //创建者链接
    var replyTime = "";                             //回复时间
    var replyLink = "";                             //回复链接
    var contentHtml = "";                           //html内容
    var textLayout:YYTextLayout?
    var textAttributedString:NSMutableAttributedString?;
    var images:NSMutableArray = NSMutableArray();
}


protocol GuangGuCommentAttachmentImageTapDelegate : class {
    func GuangGuCommentAttachmentImageSingleTap(_ imageView:GuangGuAttachmentImage)
}

class ContentDataSource: NSObject {
    fileprivate var contentPageString = "";
    weak var vcDelegate:GuangGuVCDelegate?
    //read only property
    var headerModel :GuangGuStruct?
    var itemList = [GuangGuComent]();
    var nameList = Set<String>();
    fileprivate var pageCount:Int = 0;
    
    required init(urlString: String,model:GuangGuStruct?,delegate:GuangGuVCDelegate?) {
        super.init();
        guard urlString.count > 0 else {
            return;
        }
        self.contentPageString = urlString;
        self.pageCount = 1;
        self.headerModel = model;
        self.vcDelegate = delegate;
        self.loadData(urlString: self.contentPageString, loadNew: true);
    }
    
    deinit {
        self.vcDelegate = nil;
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
            self.nameList.removeAll();
        }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            
            do{
                let doc: Document = try SwiftSoup.parse(myHTMLString)
                //parse header
                let headerClasses = try doc.getElementsByClass("topic-detail");
                for object in headerClasses
                {
                    if self.headerModel == nil {
                        self.headerModel = GuangGuStruct();
                    }
                    let uiHeaderElements = try object.getElementsByClass("ui-header");
                    self.headerModel?.creatorLink = try uiHeaderElements.select("a").attr("href");
                    self.headerModel?.creatorImg = try uiHeaderElements.select("a").select("img").attr("src");
                    
                    let titleElements = try object.getElementsByClass("title");
                    self.headerModel?.title = try titleElements.text();
                    
                    let nodeElements = try object.getElementsByClass("node");
                    self.headerModel?.node = try nodeElements.text();
                    
                    let usernameElements = try object.getElementsByClass("username");
                    self.headerModel?.creatorName = try usernameElements.text();
                    
                    if let name = self.headerModel?.creatorName {
                        self.nameList.insert(name);
                    }
                    
                    let contentElements = try object.getElementsByClass("ui-content");
                    let contentHtml = try contentElements.html();
                    self.headerModel?.contentHtml = contentHtml;
                    
                    let imgElements = try contentElements.select("img");
                    for imgElement in imgElements {
                        let imgSrc: String = try imgElement.attr("src")
                        self.headerModel?.images.add(imgSrc);
                    }
                    
                    let createTimeElements = try object.getElementsByClass("created-time");
                    let createTime = try createTimeElements.text();
                    self.headerModel?.creatTime = createTime;
                    
                    let favoriteTimeElements = try object.getElementsByClass("J_topicFavorite");
                    let dataType = try favoriteTimeElements.attr("data-type");
                    let favoriteURL = try favoriteTimeElements.attr("href");
                    self.headerModel?.favoriteURL = favoriteURL;
                    if dataType == "favorite" {
                        self.headerModel?.isFavorite = false;
                    }
                    else {
                        self.headerModel?.isFavorite = true;
                    }
                    break;
                }
                let jiDoc = Ji(htmlString: myHTMLString);
                let rootNode = jiDoc?.rootNode;
                let nodes = rootNode?.xPath("//div[@class='reply-item']");
                if nodes!.count > 0
                {
                    for commentNode in nodes!
                    {
                        var item = GuangGuComent();
                        item.creatorImg = (commentNode.xPath("a/img").first?["src"])!;
                        item.creatorName = (commentNode.xPath("div[@class='main']/div/a/span").first?.content)!;
                        item.creatorLink = (commentNode.xPath("div[@class='main']/div/a").first?["href"])!;
                        item.replyTime = (commentNode.xPath("div[@class='main']/div/span").first?.content)!;
                        item.contentHtml = (commentNode.xPath("div[@class='main']/span").first?.content)!;
                        
                        let commentAttributedString:NSMutableAttributedString = NSMutableAttributedString(string: "")
                        let contentNodes = commentNode.xPath("div[@class='main']/span[@class='content']/node()")
                        self.preformAttributedString(commentAttributedString, nodes: contentNodes,item)
                        item.textAttributedString = commentAttributedString;
                        let textContainer = YYTextContainer(size: CGSize(width: SCREEN_WIDTH - 30, height: 9999))
                        item.textLayout = YYTextLayout(container: textContainer, text: commentAttributedString)
                        self.itemList.append(item);
                        self.nameList.insert(item.creatorName);
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
            self.loadData(urlString: self.contentPageString, loadNew: true);
            DispatchQueue.main.async {
                completion();
            }
        }
    }
    
    func loadOlder(completion: @escaping () -> Void) -> Void {
        DispatchQueue.global(qos: .background).async {
            var urlString = self.contentPageString;
            urlString = urlString.replacingOccurrences(of: "?p="+String(self.pageCount), with: "?p="+String(self.pageCount+1))
            self.pageCount += 1;
            self.loadData(urlString: urlString, loadNew: false);
            DispatchQueue.main.async {
                completion();
            }
        }
    }
    
    func preformAttributedString(_ commentAttributedString:NSMutableAttributedString,nodes:[JiNode],_ model:GuangGuComent) {
        for element in nodes {
            if element.name == "text" , var content = element.content{//普通文本
                content = content.replacingOccurrences(of: "\t", with: "")
                //content = content.replacingOccurrences(of: "\n\n", with: "\n")
                commentAttributedString.append(NSMutableAttributedString(string: content,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14) , NSAttributedStringKey.foregroundColor:UIColor.black]))
                commentAttributedString.yy_lineSpacing = 5
            }
                
                
            else if element.name == "img" ,var imageURL = element["src"]  {//图片
                let image = GuangGuAttachmentImage()
                if imageURL.contains("http") {
                }
                else {
                    if imageURL[imageURL.startIndex] == "/" {
                        imageURL.removeFirst();
                    }
                    imageURL = GUANGGUSITE + imageURL;
                }
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

/// 评论中的图片
class GuangGuAttachmentImage:AnimatedImageView {
    /// 父容器中第几张图片
    var index:Int = 0
    
    /// 图片地址
    var imageURL:String?
    
    weak var ggCommentDelegate : GuangGuCommentAttachmentImageTapDelegate?
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80));
        self.autoPlayAnimatedImage = false;
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if self.image != nil {
            return
        }
        if  let imageURL = self.imageURL , let URL = URL(string: imageURL) {
            self.kf.setImage(with: URL, placeholder: nil, options: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                if let image = image {
                    if image.size.width < 80 && image.size.height < 80 {
                        self.contentMode = .bottomLeft
                    }
                }
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let tapCount = touch?.tapCount
        if let tapCount = tapCount {
            if tapCount == 1 {
                self.handleSingleTap(touch!)
            }
        }
        //取消后续的事件响应
        self.next?.touchesCancelled(touches, with: event)
    }
    func handleSingleTap(_ touch:UITouch){
        self.ggCommentDelegate?.GuangGuCommentAttachmentImageSingleTap(self)
    }
}
