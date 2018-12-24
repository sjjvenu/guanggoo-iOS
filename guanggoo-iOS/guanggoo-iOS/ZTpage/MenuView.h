//
//  MenuView.h
//  02-练习
//
//  Created by 武镇涛 on 15/7/19.
//  Copyright (c) 2015年 wuzhentao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    MenuViewStyleDefault,     // 默认
    MenuViewStyleLine,        // 带下划线 (颜色会变化)
    MenuViewStyleFoold,       // 涌入效果 (填充)
    MenuViewStyleFooldHollow, // 涌入效果 (空心的)
    MenuViewStyleFooldBackground            //带背景图片
} MenuViewStyle;

@class ColourInfo;
@class MenuView;

@protocol MenuViewDelegate <NSObject>

@optional

- (void)MenuViewDelegate:(MenuView*)menuciew WithIndex:(int)index;
- (void)ClickSelectedDelegate:(MenuView*)menuciew WithIndex:(int)index;

@end

@interface MenuView : UIView

@property (nonatomic,weak)id<MenuViewDelegate> delegate;

@property (nonatomic,assign)MenuViewStyle style;

@property (nonatomic,strong)UIColor *kNomalColor;//默认时候普通字体颜色
@property (nonatomic,strong)UIColor *kViewBackgroundColor;//视图背景颜色
@property (nonatomic,strong)UIColor *kSelectedColor;//默认时候选中字体颜色
@property (nonatomic,strong)UIColor *kNormalBackgroundColorFlood;//涌入 背景颜色
@property (nonatomic,strong)UIColor *kUnderLineColorFlood;//涌入 下划线颜色
@property (nonatomic,strong)UIColor *middleLineColor;//分隔线颜色
@property (nonatomic,strong)UIColor *underLineBackgroundColor;//下方分隔线颜色
@property (nonatomic,strong)UIImage *selectBackgroundImage;//选中按键背景图片
@property (nonatomic,strong)UIImage *btnBackgroundColorImage;//按键背景图片
@property (nonatomic,strong)UIImage *lastBtnBackgroundColorImage;//最后一个按键背景图片切换

//控制标题自适合属性，默认为false
@property (nonatomic) BOOL bAutoLayout;

@property (nonatomic,assign)NSUInteger selecteIndex;


//位置校正
- (void)SelectedBtnMoveToCenterWithIndex:(int)index WithRate:(CGFloat)rate;
//Button移动
- (void)SelectedBtnMoveToCenterWithIndexMoving:(int)index WithRate:(CGFloat)Pagerate;
//titles为标题字符串数据
- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style AndTitles:(NSArray *)titles hasMiddleLine:(BOOL)bHasMiddleLine;
//items为MenuViewItem的数组
- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style AndItems:(NSArray *)items hasMiddleLine:(BOOL)bHasMiddleLine;
- (void)selectWithIndex:(int)index AndOtherIndex:(int)tag;
- (void)setSelectedIndex:(NSString *)selectTitle animated:(BOOL)animated;
- (void)setSelectedTitle:(NSString *)title;
- (void)setTitle:(NSString *)title Index:(NSUInteger)index;
- (void)UpdateScheme;
@end
