//
//  GuangGuCommon.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/20.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import Ji
import YYText

let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

//用户代理，使用这个切换是获取 m站点 还是www站数据
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]

let DBFILE = "db.sqlite3"

let TOKENFILE = "token.txt"


//站点地址,客户端只有https,禁用http
let GUANGGUSITE = "http://www.guanggoo.com/"

//黑名单更新时强制刷新
let BLACKLISTTOREFRESH = "BLACKLISTTOREFRESH"

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
    
    var data: Data {
        return Data(utf8)
    }
    //判断是否为email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}


func dispatch_sync_safely_main_queue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}


func preformAttributedString(_ commentAttributedString:NSMutableAttributedString,nodes:[JiNode],_ model:GuangGuComent,handle:@escaping (_ url:String) ->Void) {
    for element in nodes {
        if element.name == "text" , var content = element.content{//普通文本
            content = content.replacingOccurrences(of: "\t", with: "")
            content = content.replacingOccurrences(of: "                            ", with: "")
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
                preformAttributedString(commentAttributedString, nodes: subNodes,model,handle: handle)
            }
            if content.count > 0 {
                let attr = NSMutableAttributedString(string: content ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
                attr.yy_setTextHighlight(NSMakeRange(0, content.count),
                                         color: UIColor.lightGray,
                                         backgroundColor: UIColor(white: 0.95, alpha: 1),
                                         userInfo: ["url":url],
                                         tapAction: { (view, text, range, rect) -> Void in
                                            if let highlight = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(range.location)) ,let url = (highlight as AnyObject).userInfo["url"] as? String  {
                                                handle(url);
                                            }
                                            
                    }, longPressAction: nil)
                commentAttributedString.append(attr)
            }
        }
            
        else if let content = element.content{//其他
            let subElement = element.xPath("a/node()")
            if subElement.first?.name != "text" && subElement.count > 0 {
                //img隐藏在<p><a>下
                preformAttributedString(commentAttributedString, nodes: subElement,model,handle: handle);
            }
            else
            {
                let subImgElement = element.xPath("node()")
                if subImgElement.first?.name != "text" && subImgElement.count > 0 {
                    //img隐藏在<p><a>下
                    preformAttributedString(commentAttributedString, nodes: subImgElement,model,handle: handle);
                }
                else {
                    commentAttributedString.append(NSMutableAttributedString(string: content,attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.black]))
                }
            }
        }
    }
}
