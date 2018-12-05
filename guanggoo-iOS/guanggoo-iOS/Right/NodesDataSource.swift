//
//  NodesDataSource.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/23.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup

struct GuangGuNode {
    var name = "";                  //节点名称
    var link = "";                  //节点链接
    var category = "";              //节点分类
}

class NodesDataSource: NSObject {
    fileprivate var homePageString = "";
    var itemList = [GuangGuNode]();
    
    required init(urlString: String,bInsertAll:Bool) {
        super.init();
        guard urlString.count > 0 else {
            return;
        }
        self.homePageString = urlString;
        loadData(urlString: self.homePageString, loadNew: true,bInsertAll: bInsertAll);
    }
    
    func loadData(urlString:String,loadNew:Bool,bInsertAll:Bool) -> Void {
        guard let myURL = URL(string: urlString) else {
            print("Error: \(urlString) doesn't seem to be a valid URL");
            return
        }
        if (loadNew)
        {
            self.itemList.removeAll();
        }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            
            do{
                let doc: Document = try SwiftSoup.parse(myHTMLString);
                let classes = try doc.getElementsByClass("nodes-cloud");
                for object in classes
                {
                    let liItemElements = try object.select("li");
                    for liElement in liItemElements {
                        let labelElement = try liElement.select("label");
                        let labelText = try labelElement.text();
                        
                        let nodeElements = try liElement.getElementsByClass("nodes").select("a");
                        for nodeElement in nodeElements {
                            let linkText = try nodeElement.attr("href");
                            let nameText = try nodeElement.text();
                            
                            var item = GuangGuNode();
                            item.category = labelText;
                            item.name = nameText;
                            item.link = linkText;
                            itemList.append(item);
                        }
                    }
                }
                if bInsertAll {
                    var item = GuangGuNode();
                    item.category = "全部";
                    item.name = "全部";
                    item.link = "";
                    itemList.insert(item, at: 0);
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
}
