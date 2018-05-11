//
//  GuangGooColor.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/5/8.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit
import SwiftSoup

class GuangGuColor: NSObject {
    
    fileprivate static let STYLE_KEY = "styleKey"
    static let sharedInstance = GuangGuColor();
    @objc dynamic var style:String
    var colorSettingsDoc: Document?
    
    fileprivate override init() {
        
        if let style = GuangGuSettings.sharedInstance[GuangGuColor.STYLE_KEY] {
            self.style = style;
        }
        else {
            self.style = "default";
        }
        if let path = Bundle.main.path(forResource: self.style, ofType: "xml") {
            do {
                let xmlString = try String.init(contentsOfFile: path);
                self.colorSettingsDoc = try SwiftSoup.parse(xmlString);
            }
            catch {
                
            }
        }
        super.init();
    }
    
    func getColor(node:String,name:String) -> UIColor? {
        if let doc = self.colorSettingsDoc {
            do {
                let headerClasses = try doc.select(node).select("Node")
                for object in headerClasses {
                    let nodeName = try object.attr("name");
                    if name == nodeName {
                        let red = try object.attr("R");
                        let green = try object.attr("G");
                        let blue = try object.attr("B");
                        var a = try object.attr("A");
                        if a.count == 0 {
                            a = "1";
                        }
                        return UIColor.init(red: CGFloat(Double(red)!/255.0), green: CGFloat(Double(green)!/255.0), blue: CGFloat(Double(blue)!/255.0), alpha: CGFloat(Double(a)!))
                    }
                }
            }
            catch {
                return nil;
            }
        }
        return nil;
    }
}



//MARK: - 主题更改时，自动执行
extension NSObject {
    fileprivate struct AssociatedKeys {
        static var thmemChanged = "thmemChanged"
    }
    
    /// 当前主题更改时、第一次设置时 自动调用的闭包
    public typealias ThemeChangedClosure = @convention(block) (_ style:String) -> Void
    
    /// 自动调用的闭包
    /// 设置时，会设置一个KVO监听，当V2Style.style更改时、第一次赋值时 会自动调用这个闭包
    var themeChangedHandler:ThemeChangedClosure? {
        get {
            let closureObject: AnyObject? = objc_getAssociatedObject(self, &AssociatedKeys.thmemChanged) as AnyObject?
            guard closureObject != nil else{
                return nil
            }
            let closure = unsafeBitCast(closureObject, to: ThemeChangedClosure.self)
            return closure
        }
        set{
            guard let value = newValue else{
                return
            }
            let dealObject: AnyObject = unsafeBitCast(value, to: AnyObject.self)
            objc_setAssociatedObject(self, &AssociatedKeys.thmemChanged,dealObject,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //设置KVO监听
            self.kvoController.observe(GuangGuColor.sharedInstance, keyPath: "style", options: [.initial,.new] , block: {[weak self] (nav, color, change) -> Void in
                self?.themeChangedHandler?(GuangGuColor.sharedInstance.style)
                }
            )
        }
    }
}
