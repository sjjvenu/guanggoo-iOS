//
//  MenuViewBtn.h
//  02-练习
//
//  Created by 武镇涛 on 15/7/20.
//  Copyright (c) 2015年 wuzhentao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColourInfo;
@class MenuViewItem;
@interface MenuViewBtn : UIButton

@property (nonatomic,copy   ) NSString *fontName;
@property (nonatomic,assign ) CGFloat  fontSize;
@property (nonatomic,assign ) CGFloat  NomrmalSize;
@property (nonatomic,assign ) CGFloat  rate;
// normal状态的字体颜色
@property (nonatomic, strong) UIColor  *normalColor;
//selected状态的字体颜色
@property (nonatomic, strong) UIColor  *selectedColor;
@property (nonatomic,strong ) UIColor  *titlecolor;

@property (nonatomic,strong) MenuViewItem *item;

- (instancetype)initWithTitles:(NSArray *)titles AndIndex:(int)index;
- (instancetype)initWithItems:(NSArray *)items AndIndex:(int)index;
- (void)selectedItemWithoutAnimation;
- (void)deselectedItemWithoutAnimation;
- (void)ChangSelectedColorWithRate:(CGFloat)rate;
- (void)ChangSelectedColorAndScalWithRate:(CGFloat)rate;
- (void)showRedPoint:(BOOL)bShow;
@end



@interface MenuViewItem : NSObject


@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger type;

@end
