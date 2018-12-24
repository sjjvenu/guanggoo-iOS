//
//  MenuView.m
//  02-练习
//
//  Created by 武镇涛 on 15/7/19.
//  Copyright (c) 2015年 wuzhentao. All rights reserved.
//

#import "MenuView.h"
#import "MenuViewBtn.h"
#import "FloodView.h"
#import "ZTPage.h"

@interface MenuView ()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *MenuScrollView;
@property (nonatomic,weak)MenuViewBtn *selectedBtn;
@property (nonatomic,weak)UIView  *line;
@property (nonatomic,assign)CGFloat sumWidth;
@property (nonatomic,assign)CGFloat calcWidth;
@property (nonatomic,strong)FloodView *floodView;
@property (nonatomic,strong)UIView *underLine;
@property (nonatomic,assign)NSInteger itemCount;
//是否支持中间分隔线
@property (nonatomic) BOOL bHasMiddleLine;

@end

@implementation MenuView

@synthesize kNomalColor,kViewBackgroundColor,kSelectedColor,kUnderLineColorFlood,kNormalBackgroundColorFlood,middleLineColor,calcWidth,underLineBackgroundColor;
@synthesize selectBackgroundImage,btnBackgroundColorImage,lastBtnBackgroundColorImage,itemCount;

- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style AndTitles:(NSArray *)titles hasMiddleLine:(BOOL)bHasMiddleLine
{
    if (self = [super init]) {
        kNomalColor = [UIColor blackColor];
        kViewBackgroundColor = [UIColor whiteColor];
        kSelectedColor  = [UIColor blueColor];
        kNormalBackgroundColorFlood = [UIColor blueColor];
        kUnderLineColorFlood = [UIColor blueColor];
        middleLineColor = [UIColor blueColor];
        underLineBackgroundColor = [UIColor whiteColor];
        selectBackgroundImage = nil;
        btnBackgroundColorImage = nil;
        lastBtnBackgroundColorImage = nil;
        _bAutoLayout = false;
        _bHasMiddleLine = bHasMiddleLine;
        switch (style) {
            case MenuViewStyleLine:
                self.style = MenuViewStyleLine;
                break;
            case MenuViewStyleFoold:
                self.style = MenuViewStyleFoold;
                break;
            case MenuViewStyleFooldHollow:
                self.style = MenuViewStyleFooldHollow;
                break;
            case MenuViewStyleFooldBackground:
                self.style = MenuViewStyleFooldBackground;
                break;
            default:
                self.style = MenuViewStyleDefault;
                break;
        }

        itemCount = titles.count;
        [self loadWithScollviewAndBtnWithTitles:titles];
    }
    return self;
}

- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style AndItems:(NSArray *)items hasMiddleLine:(BOOL)bHasMiddleLine
{
    if (self = [super init]) {
        kNomalColor = [UIColor blackColor];
        kViewBackgroundColor = [UIColor whiteColor];
        kSelectedColor  = [UIColor blueColor];
        kNormalBackgroundColorFlood = [UIColor blueColor];
        kUnderLineColorFlood = [UIColor blueColor];
        middleLineColor = [UIColor blueColor];
        underLineBackgroundColor = [UIColor whiteColor];
        selectBackgroundImage = nil;
        btnBackgroundColorImage = nil;
        lastBtnBackgroundColorImage = nil;
        _bAutoLayout = false;
        _bHasMiddleLine = bHasMiddleLine;
        switch (style) {
            case MenuViewStyleLine:
                self.style = MenuViewStyleLine;
                break;
            case MenuViewStyleFoold:
                self.style = MenuViewStyleFoold;
                break;
            case MenuViewStyleFooldHollow:
                self.style = MenuViewStyleFooldHollow;
                break;
            case MenuViewStyleFooldBackground:
                self.style = MenuViewStyleFooldBackground;
                break;
            default:
                self.style = MenuViewStyleDefault;
                break;
        }
        
        itemCount = items.count;
        [self loadWithScollviewAndBtnWithItems:items];
    }
    return self;
}

- (void)loadWithScollviewAndBtnWithTitles:(NSArray *)titles
{
    UIScrollView *MenuScrollView = [[UIScrollView alloc]init];
    MenuScrollView.showsVerticalScrollIndicator = NO;
    MenuScrollView.showsHorizontalScrollIndicator = NO;
    MenuScrollView.backgroundColor = kViewBackgroundColor;
    MenuScrollView.delegate = self;
    self.MenuScrollView= MenuScrollView;
    [self addSubview:self.MenuScrollView];
//btn创建
    
    for (int i = 0; i < titles.count; i++) {
        MenuViewBtn *btn = [[MenuViewBtn alloc ]initWithTitles:titles AndIndex:i];
        btn.tag = i;
        if (self.style == MenuViewStyleFoold || self.style == MenuViewStyleFooldHollow) {
            //btn.fontName = @"BodoniSvtyTwoOSITCTT-Bold";
            btn.fontSize = NORMALFONTSIZE;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColor;
            if (self.style == MenuViewStyleFooldHollow) {
                btn.selectedColor = kSelectedColor;
            }
        }else{
            //这里为引入第三方定义字体，只需导入你想要的otf/ttf的字体源文件，修改一下plist中的font设置，再将字体家族和字体名称打印出来。具体详细过程请问百度。
            btn.fontSize = NORMALFONTSIZE;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColor;
        }
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:kSelectedColorFontFlood forState:UIControlStateSelected];
        if (self.style == MenuViewStyleFooldBackground)
            [btn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
        [self.MenuScrollView addSubview:btn];
        
        if (i < titles.count-1 && _bHasMiddleLine)
        {
            UILabel *middleLine = [[UILabel alloc] init];
            middleLine.backgroundColor = middleLineColor;
            middleLine.translatesAutoresizingMaskIntoConstraints = false;
            middleLine.tag = i*100;
            [btn addSubview:middleLine];
            
            // align middleLine from the right
            [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[middleLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleLine)]];
            
            // align middleLine from the top and bottom
            [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[middleLine]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleLine)]];
            
            // width constraint
            [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[middleLine(==1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleLine)]];
        }
        
    }
    //加分割线
    self.underLine = [[UIView alloc]init];
    self.underLine.backgroundColor = underLineBackgroundColor;
    [self addSubview:self.underLine];
    calcWidth = [self getCalcWidth:titles];
}

- (void)loadWithScollviewAndBtnWithItems:(NSArray *)items
{
    UIScrollView *MenuScrollView = [[UIScrollView alloc]init];
    MenuScrollView.showsVerticalScrollIndicator = NO;
    MenuScrollView.showsHorizontalScrollIndicator = NO;
    MenuScrollView.backgroundColor = kViewBackgroundColor;
    MenuScrollView.delegate = self;
    self.MenuScrollView= MenuScrollView;
    [self addSubview:self.MenuScrollView];
    //btn创建
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++) {
        MenuViewBtn *btn = [[MenuViewBtn alloc ] initWithItems:items AndIndex:i];
        MenuViewItem *item = [items objectAtIndex:i];
        [titles addObject:item.title];
        btn.tag = i;
        if (self.style == MenuViewStyleFoold || self.style == MenuViewStyleFooldHollow) {
            //btn.fontName = @"BodoniSvtyTwoOSITCTT-Bold";
            btn.fontSize = NORMALFONTSIZE;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColor;
            if (self.style == MenuViewStyleFooldHollow) {
                btn.selectedColor = kSelectedColor;
            }
        }else{
            //这里为引入第三方定义字体，只需导入你想要的otf/ttf的字体源文件，修改一下plist中的font设置，再将字体家族和字体名称打印出来。具体详细过程请问百度。
            btn.fontSize = NORMALFONTSIZE;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColor;
        }
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:kSelectedColorFontFlood forState:UIControlStateSelected];
        if (self.style == MenuViewStyleFooldBackground)
            [btn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
        [self.MenuScrollView addSubview:btn];
        
        if (i < items.count-1 && _bHasMiddleLine)
        {
            UILabel *middleLine = [[UILabel alloc] init];
            middleLine.backgroundColor = middleLineColor;
            middleLine.translatesAutoresizingMaskIntoConstraints = false;
            middleLine.tag = i*100;
            [btn addSubview:middleLine];
            
            // align middleLine from the right
            [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[middleLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleLine)]];
            
            // align middleLine from the top and bottom
            [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[middleLine]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleLine)]];
            
            // width constraint
            [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[middleLine(==1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleLine)]];
        }
        
    }
    //加分割线
    self.underLine = [[UIView alloc]init];
    self.underLine.backgroundColor = underLineBackgroundColor;
    [self addSubview:self.underLine];
    calcWidth = [self getCalcWidth:titles];
}

- (CGFloat)getCalcWidth:(NSArray *)titles
{
    CGFloat sumWidth = 0;
    if (self.MenuScrollView.subviews.count > 0)
    {
        MenuViewBtn *btn= self.MenuScrollView.subviews[0];
        UIFont *titleFont = btn.titleLabel.font;
        for (int i = 0; i < titles.count; i++ )
        {
            CGFloat width = 0;
            CGSize titleS = [titles[i] sizeWithfont:titleFont];
            if (_bHasMiddleLine)
            {
                width = titleS.width + 3 *BtnGap;
            }
            else
            {
                width = titleS.width + 2 *BtnGap;
            }
            sumWidth += width;

        }
    }
    return sumWidth;
}

- (void)UpdateScheme
{
    self.backgroundColor = kViewBackgroundColor;
    self.MenuScrollView.backgroundColor = kViewBackgroundColor;
    self.underLine.backgroundColor = underLineBackgroundColor;
    for (int i = 0; i < self.MenuScrollView.subviews.count; i++){
        MenuViewBtn *btn = nil;
        btn= self.MenuScrollView.subviews[i];
        
        if ([btn isKindOfClass:[FloodView class]])
        {
            FloodView *floView = (FloodView *)btn;
            if (floView)
            {
                floView.color = kSelectedColor;
                if (self.style == MenuViewStyleFooldHollow || self.style == MenuViewStyleFoold){
                    floView.FillColor = kNormalBackgroundColorFlood.CGColor;
                    
                    if (self.style == MenuViewStyleFooldHollow) {
                        floView.color = kNormalBackgroundColorFlood;
                    }
                }else{
                    floView.color = kUnderLineColorFlood;
                    floView.backgroundColor = kUnderLineColorFlood;
                    floView.FillColor = kUnderLineColorFlood.CGColor;
                }
                [floView setNeedsLayout];
            }
            continue;
        }
        btn.normalColor = kNomalColor;
        btn.selectedColor = kSelectedColor;
        
        [btn setTitleColor:kNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:kSelectedColorFontFlood forState:UIControlStateSelected];
        
        if (btn.isSelected)
        {
            self.selectedBtn = btn;
            self.selectedBtn.fontSize = SELECTEDFONTSIZE;
            if (self.style == MenuViewStyleFooldBackground)
                [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
            [self.selectedBtn setSelected:YES];
        }
        
        if (btn.subviews.count > 1)
        {
            UILabel *middleLine = (UILabel *)[btn viewWithTag:btn.tag*100];
            if ([middleLine isKindOfClass:[UILabel class]])
            {
                middleLine.backgroundColor = middleLineColor;
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self initSubViewFrame];
}

- (void)initSubViewFrame
{
    self.backgroundColor = kViewBackgroundColor;
    self.MenuScrollView.backgroundColor = kViewBackgroundColor;
    CGFloat sumWidth = 0;
    MenuViewBtn *btnSelected = self.selectedBtn;
    MenuViewBtn *btn1 = nil;
    for (int i = 0; i < self.MenuScrollView.subviews.count; i++){
        MenuViewBtn *btn = nil;
        btn= self.MenuScrollView.subviews[i];
        
        if ([btn isKindOfClass:[FloodView class]])
        {
            continue;
        }
        
        if (self.style == MenuViewStyleFoold || self.style == MenuViewStyleFooldHollow) {
            //btn.fontName = @"BodoniSvtyTwoOSITCTT-Bold";
            btn.fontSize = NORMALFONTSIZE;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColor;
            if (self.style == MenuViewStyleFooldHollow) {
                btn.selectedColor = kSelectedColor;
            }
        }else{
            //这里为引入第三方定义字体，只需导入你想要的otf/ttf的字体源文件，修改一下plist中的font设置，再将字体家族和字体名称打印出来。具体详细过程请问百度。
            btn.fontSize = NORMALFONTSIZE;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColor;
        }
        
        [btn setTitleColor:kNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:kSelectedColorFontFlood forState:UIControlStateSelected];
        
        
        if (btn.subviews.count > 1)
        {
            UILabel *middleLine = (UILabel *)[btn viewWithTag:btn.tag*100];
            if ([middleLine isKindOfClass:[UILabel class]])
            {
                middleLine.backgroundColor = middleLineColor;
            }
        }
        
        //        if (i>=1) {
        //            btn1 = self.MenuScrollView.subviews[i-1];
        //        }
        
        UIFont *titleFont = btn.titleLabel.font;
        CGSize titleS = [btn.titleLabel.text sizeWithfont:titleFont];
        if (_bHasMiddleLine)
        {
            btn.width = titleS.width + 3 *BtnGap;
            //if (btn1)
            btn.x = btn1.x + btn1.width ;
        }
        else
        {
            btn.width = titleS.width + 2 *BtnGap;
            //if (btn1)
            btn.x = btn1.x + btn1.width + BtnGap;
        }
        //        if ( i == 0)
        //            btn.x = btn.x + BtnGap;
        btn.y = 0;
        btn.height = self.height - 2;
        sumWidth += btn.width;
        if (btn == [self.MenuScrollView.subviews lastObject]) {
            CGFloat width = self.bounds.size.width;
            CGFloat height = self.bounds.size.height;
            self.MenuScrollView.size = CGSizeMake(width, height);
            self.MenuScrollView.contentSize = CGSizeMake(btn.x + btn.width+ BtnGap, 0);
            self.MenuScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            self.selectedBtn.fontSize = SELECTEDFONTSIZE;
            if (self.style == MenuViewStyleFooldBackground)
                [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
        }
        
        if (self.style == MenuViewStyleFooldBackground)
        {
            CGFloat width = self.bounds.size.width/self.MenuScrollView.subviews.count;
            if (i == 0)
                btn.x = 0;
            btn.width = width;
            if (btn1)
                btn.x = btn1.x + btn1.width;
        }
        else
        {
            if (calcWidth < self.width) {
                if (_bAutoLayout)
                {
                    CGFloat margin = (self.bounds.size.width - self.calcWidth)/(itemCount + 1);
                    if (_bHasMiddleLine)
                    {
                        btn.width = btn.width + margin;
                        //if (btn1)
                        btn.x = btn1.x + btn1.width;
                    }
                    else
                    {
                        if (btn1)
                            btn.x = btn1.x + btn1.width + margin;
                        else
                            btn.x = margin;
                    }
                    
                }
            }
        }
        btn1 = btn;
    }
    
    self.sumWidth = sumWidth;
    
    self.underLine.frame = CGRectMake(0, self.height-1, self.width, 1);
    self.underLine.backgroundColor = underLineBackgroundColor;
    
    if (self.selectedBtn != btnSelected && self.selectedBtn!=nil && btnSelected!=nil)
    {
        //old
        self.selectedBtn.selected = NO;
        self.selectedBtn.fontSize = NORMALFONTSIZE;
        if (self.style == MenuViewStyleFooldBackground)
            [self.selectedBtn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
        //new
        btnSelected.selected = YES;
        self.selectedBtn = btnSelected;
        self.selectedBtn.fontSize = SELECTEDFONTSIZE;
        if (self.style == MenuViewStyleFooldBackground)
            [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
        if (_floodView)
            _floodView.width = btnSelected.width;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.style == MenuViewStyleDefault || self.style == MenuViewStyleFooldBackground) {
        MenuViewBtn *btn = [self.MenuScrollView.subviews firstObject];
        if (btn == self.selectedBtn)
            [btn ChangSelectedColorAndScalWithRate:0.1];
    }else{
        [self addProgressView];
    }
}

- (void)addProgressView
{
    if (_floodView == nil)
    {
        _floodView = [[FloodView alloc]init];
        
        MenuViewBtn *btn = [self.MenuScrollView.subviews firstObject];
        _floodView.x = btn.x ;
        _floodView.width = btn.width;
        _floodView.backgroundColor = [UIColor clearColor];
        _floodView.color = kSelectedColor;
        self.line = _floodView;
        
        if (self.style == MenuViewStyleFooldHollow || self.style == MenuViewStyleFoold){
            _floodView.FillColor = kNormalBackgroundColorFlood.CGColor;
            _floodView.height = self.height/2 + 2;
            _floodView.y = (self.height - _floodView.height)/2;
            
            if (self.style == MenuViewStyleFooldHollow) {
                _floodView.isStroke = YES;
                _floodView.color = kNormalBackgroundColorFlood;
            }
        }else{
            _floodView.isLine = YES;
            _floodView.height = 2;
            _floodView.y = self.height - _floodView.height - 5;
            _floodView.FillColor = kUnderLineColorFlood.CGColor;
        }
        [self.MenuScrollView addSubview:_floodView];
    }
}

- (void)click:(MenuViewBtn *)btn
{
    if (self.selectedBtn == btn)
    {
        if (btn == [self.MenuScrollView.subviews lastObject] && self.style == MenuViewStyleFooldBackground)
        {
            if (btn.currentBackgroundImage == lastBtnBackgroundColorImage)
            {
                [btn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
            }
            else
                [btn setBackgroundImage:lastBtnBackgroundColorImage forState:UIControlStateNormal];
        }
        if ([self.delegate respondsToSelector:@selector(ClickSelectedDelegate:WithIndex:)]) {
            [self.delegate ClickSelectedDelegate:self WithIndex:(int)btn.tag];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(MenuViewDelegate:WithIndex:)]) {
        [self.delegate MenuViewDelegate:self WithIndex:(int)btn.tag];
    }
    self.selectedBtn.selected = NO;
    self.selectedBtn.fontSize = NORMALFONTSIZE;
    if (self.style == MenuViewStyleFooldBackground)
        [self.selectedBtn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
    btn.selected = YES;
    [self MoveCodeWithIndex:(int)btn.tag animated:YES];
    
    if (self.style == MenuViewStyleDefault) {

        [btn selectedItemWithoutAnimation];
        [self.selectedBtn deselectedItemWithoutAnimation];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.line.x = btn.x;
            self.line.width = btn.width;
        }];
    }
    self.selectedBtn = btn;
    self.selectedBtn.fontSize = SELECTEDFONTSIZE;
    if (self.style == MenuViewStyleFooldBackground)
        [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
}

- (void)setSelectedIndex:(NSString *)selectTitle animated:(BOOL)animated
{
    for (int i = 0; i < self.MenuScrollView.subviews.count; i++){
        MenuViewBtn* btn= self.MenuScrollView.subviews[i];
        if ([btn isKindOfClass:[FloodView class]])
        {
            continue;
        }
        NSString *btnTitle = btn.titleLabel.text;
        if ([selectTitle isEqualToString:btnTitle])
        {
            if (self.selectedBtn == btn)
            {
                if ([self.delegate respondsToSelector:@selector(ClickSelectedDelegate:WithIndex:)]) {
                    [self.delegate ClickSelectedDelegate:self WithIndex:(int)btn.tag];
                }
                return;
            }
            if ([self.delegate respondsToSelector:@selector(MenuViewDelegate:WithIndex:)]) {
                [self.delegate MenuViewDelegate:self WithIndex:(int)btn.tag];
            }
            self.selectedBtn.selected = NO;
            self.selectedBtn.fontSize = NORMALFONTSIZE;
            if (self.style == MenuViewStyleFooldBackground)
                [self.selectedBtn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
            btn.selected = YES;
            [self MoveCodeWithIndex:(int)btn.tag animated:animated];
            
            if (self.style == MenuViewStyleDefault) {
                
                [btn selectedItemWithoutAnimation];
                [self.selectedBtn deselectedItemWithoutAnimation];
            }else{
                if (animated)
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.line.x = btn.x;
                        self.line.width = btn.width;
                    }];
                }
                else
                {
                    self.line.x = btn.x;
                    self.line.width = btn.width;
                }
            }
            self.selectedBtn = btn;
            self.selectedBtn.fontSize = SELECTEDFONTSIZE;
            if (self.style == MenuViewStyleFooldBackground)
                [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
        }
    }
}



- (void)SelectedBtnMoveToCenterWithIndexMoving:(int)index WithRate:(CGFloat)Pagerate
{
    //接收通知
    NSString *name = [NSString stringWithFormat:@"scrollViewDidFinished%@",self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(move:) name:name object:nil];
    
    int page  = (int)(Pagerate +0.5);
    MenuViewBtn* btn= self.MenuScrollView.subviews[page];
    if ([btn isKindOfClass:[FloodView class]])
    {
        return;
    }
    CGFloat rate = Pagerate - index;
    int count = (int)self.MenuScrollView.subviews.count;
    
    if (Pagerate < 0) return;
    if (index == count-1 || index >= count -1) return;
    if ( rate <= 0 || rate > 1)    return;
    
    self.selectedBtn.selected = NO;
    self.selectedBtn.fontSize = NORMALFONTSIZE;
    if (self.style == MenuViewStyleFooldBackground)
        [self.selectedBtn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
    MenuViewBtn *currentbtn = self.MenuScrollView.subviews[index];
    MenuViewBtn *nextBtn = self.MenuScrollView.subviews[index + 1];
    
    if (self.style == MenuViewStyleDefault) {
        
        [currentbtn ChangSelectedColorAndScalWithRate:rate];
        [nextBtn ChangSelectedColorAndScalWithRate:1-rate];
    }else {
        CGFloat margin = 0;
        if (Pagerate < count-2){
            if (self.MenuScrollView.contentSize.width < self.width){
                margin = (self.bounds.size.width - self.sumWidth)/(self.MenuScrollView.subviews.count + 1);
                if (self.style == MenuViewStyleLine && self.MenuScrollView.subviews.count > 0)
                    margin = (self.bounds.size.width - self.sumWidth)/(self.MenuScrollView.subviews.count);
                if (_bAutoLayout)
                    self.line.x =  currentbtn.x + (currentbtn.width + BtnGap+ margin)* rate;
                else
                    self.line.x =  currentbtn.x + (currentbtn.width + BtnGap)* rate;
            }else{
                margin = BtnGap;
                self.line.x =  currentbtn.x + (currentbtn.width + margin)* rate;
            }
            
            self.line.width =  currentbtn.width + (nextBtn.width - currentbtn.width)*rate;
            [currentbtn ChangSelectedColorWithRate:rate];
            [nextBtn ChangSelectedColorWithRate:1-rate];
        }
    }
    self.selectedBtn = self.MenuScrollView.subviews[page];
    self.selectedBtn.selected = YES;
    self.selectedBtn.fontSize = SELECTEDFONTSIZE;
}

- (void)SelectedBtnMoveToCenterWithIndex:(int)index WithRate:(CGFloat)Pagerate
{
    //接收通知
    NSString *name = [NSString stringWithFormat:@"scrollViewDidFinished%@",self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(move:) name:name object:nil];
    
    int page  = (int)(Pagerate +0.5);
    MenuViewBtn* btn= self.MenuScrollView.subviews[page];
    if ([btn isKindOfClass:[FloodView class]])
    {
        return;
    }
    self.selectedBtn.selected = NO;
    self.selectedBtn.fontSize = NORMALFONTSIZE;
    btn.selected = YES;
    
    if (self.style == MenuViewStyleDefault) {
        
        [btn selectedItemWithoutAnimation];
        [self.selectedBtn deselectedItemWithoutAnimation];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.line.x = btn.x;
            self.line.width = btn.width;
        }];
    }
    self.selectedBtn = self.MenuScrollView.subviews[page];
    self.selectedBtn.selected = YES;
    self.selectedBtn.fontSize = SELECTEDFONTSIZE;
    if (self.style == MenuViewStyleFooldBackground)
        [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];

}

- (void)move:(NSNotification *)info
{
    NSNumber *index =  info.userInfo[@"index"];
    int tag = [index intValue];
    [self MoveCodeWithIndex:tag animated:YES];

}
/**
 *  使选中的按钮位移到scollview的中间
 */
- (void)MoveCodeWithIndex:(int )index  animated:(BOOL)animated
{
    MenuViewBtn *btn = self.MenuScrollView.subviews[index];
    CGRect newframe = [btn convertRect:self.bounds toView:nil];
    CGFloat distance = newframe.origin.x  - self.centerX;
    CGFloat contenoffsetX = self.MenuScrollView.contentOffset.x;
    int count = (int)self.MenuScrollView.subviews.count;
    if (index > count-1) return;

    if ( self.MenuScrollView.contentOffset.x + btn.x   > self.centerX ) {
        [self.MenuScrollView setContentOffset:CGPointMake(contenoffsetX + distance + btn.width, 0) animated:YES];
    }else{
        [self.MenuScrollView setContentOffset:CGPointMake(0 , 0) animated:animated];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        
        [scrollView setContentOffset:CGPointMake(0 , 0)];
    }else if(scrollView.contentOffset.x + self.width >= scrollView.contentSize.width){
        
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - self.width, 0)];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)selectWithIndex:(int)index AndOtherIndex:(int)tag
{
    self.selectedBtn = self.MenuScrollView.subviews[index];
    MenuViewBtn *otherbtn = self.MenuScrollView.subviews[tag];

   
//    self.line.x = otherbtn.x;
//    self.line.width = otherbtn.width;

    self.selectedBtn.selected = YES;

    otherbtn.selected = NO;
 
    [self MoveCodeWithIndex:(int)self.selectedBtn.tag animated:YES];

}

- (NSUInteger)selecteIndex
{
    return self.selectedBtn.tag;
}

- (void)setSelecteIndex:(NSUInteger)currentIndex
{
    if (currentIndex > self.MenuScrollView.subviews.count-1 || self.MenuScrollView.subviews.count == 0)
        return;
    MenuViewBtn* btn= self.MenuScrollView.subviews[currentIndex];
    if ([btn isKindOfClass:[FloodView class]])
    {
        return;
    }
    if (self.selectedBtn.tag == currentIndex)
    {
        if ([self.delegate respondsToSelector:@selector(ClickSelectedDelegate:WithIndex:)]) {
            [self.delegate ClickSelectedDelegate:self WithIndex:(int)btn.tag];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(MenuViewDelegate:WithIndex:)]) {
        [self.delegate MenuViewDelegate:self WithIndex:(int)btn.tag];
    }
    self.selectedBtn.selected = NO;
    self.selectedBtn.fontSize = NORMALFONTSIZE;
    if (self.style == MenuViewStyleFooldBackground)
        [self.selectedBtn setBackgroundImage:btnBackgroundColorImage forState:UIControlStateNormal];
    btn.selected = YES;
    [self MoveCodeWithIndex:(int)btn.tag animated:YES];
    
    if (self.style == MenuViewStyleDefault) {
        
        [btn selectedItemWithoutAnimation];
        [self.selectedBtn deselectedItemWithoutAnimation];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.line.x = btn.x;
            self.line.width = btn.width;
        }];
    }
    self.selectedBtn = btn;
    self.selectedBtn.fontSize = SELECTEDFONTSIZE;
    if (self.style == MenuViewStyleFooldBackground)
        [self.selectedBtn setBackgroundImage:selectBackgroundImage forState:UIControlStateNormal];
}


- (void)setSelectedTitle:(NSString *)title
{
    if (self.selectedBtn == nil)
        return;
    [self.selectedBtn setTitle:title forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title Index:(NSUInteger)index
{
    NSUInteger step=0;
    
    for (int i = 0; i < self.MenuScrollView.subviews.count; i++)
    {
        MenuViewBtn* btn= self.MenuScrollView.subviews[i];
        if ([btn isKindOfClass:[FloodView class]])
        {
            continue;
        }
        
        if(step == index)
        {
            [btn setTitle:title forState:UIControlStateNormal];
        }
        
        step++;
    }
    [self setNeedsLayout];
}

@end
