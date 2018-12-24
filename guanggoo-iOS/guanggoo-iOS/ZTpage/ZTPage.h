//
//  ZTPage.h
//  ZTPageController
//
//  Created by 武镇涛 on 15/8/1.
//  Copyright (c) 2015年 wuzhentao. All rights reserved.
//

#ifndef ZTPageController_ZTPage_h
#define ZTPageController_ZTPage_h
#import "UIView+Extension.h"
#import "NSString+Extention.h"
#import "UIBarButtonItem+Extention.h"
// 颜色
#define rgb(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1.0]
#define ZTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ZTColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define ZTRandomColor ZTColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


//涌入 字体颜色
#define kSelectedColorFontFlood [UIColor whiteColor]
//涌入效果（空心）
#define kSelectedColorFloodH  [UIColor colorWithRed:225/255.0 green:40/255.0 blue:40/255.0 alpha:1]

#define kNormalSize 14
#define BtnGap 8
#define MenuHeight 40
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define BUTTONHEIGHT 35
#define BUTTONSPACING 15
#define NORMALFONTSIZE 14
#define SELECTEDFONTSIZE 14

#endif

