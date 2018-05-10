//
//  GuangGooColor.swift
//  guanggoo-iOS
//
//  Created by tdx on 2018/5/8.
//  Copyright © 2018年 tdx. All rights reserved.
//

import UIKit

class GuangGuColor: NSObject {
    
    fileprivate static let STYLE_KEY = "styleKey"
    static let sharedInstance = GuangGuColor();
    @objc dynamic var style:String
    
    fileprivate override init() {
        
        if let style = GuangGuSettings.sharedInstance[GuangGuColor.STYLE_KEY] {
            self.style = style;
        }
        else {
            self.style = "default";
        }
        super.init();
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
