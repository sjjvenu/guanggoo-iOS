//
//  MenuViewBtn.m
//  02-练习
//
//  Created by 武镇涛 on 15/7/20.
//  Copyright (c) 2015年 wuzhentao. All rights reserved.
//

#import "MenuViewBtn.h"
#import "ZTPage.h"
#import "NSObject+FBKVOController.h"

#define Defaultrate 1.15
@interface MenuViewBtn (){
    CGFloat rgba[4];
    CGFloat rgbaGAP[4];
    FBKVOController *_KVOController;
    UIView *m_redPoint;
}
@end

@implementation MenuViewBtn

@synthesize item;

- (UIColor *)normalColor
{
    if (_normalColor == nil) {
        _normalColor = [UIColor blackColor];
    }
    return _normalColor;
}
- (UIColor *)selectedColor
{
    if (_selectedColor == nil) {
        _selectedColor = [UIColor blueColor];
    }
    return _selectedColor;
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self setTitleColor:self.selectedColor forState:UIControlStateSelected];
    }
    else
    {
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
    if (self.item.count > 0)
    {
        [self showRedPoint:YES];
    }
}

- (UIColor *)titlecolor
{
    if (_titlecolor == nil) {
        _titlecolor = self.normalColor;
    }
    return _titlecolor;
}
- (void)setFontSize:(CGFloat)fontSize{
    if (self.fontName) {
        self.titleLabel.font = [UIFont fontWithName:self.fontName size:fontSize];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    _fontSize = fontSize;
    
}
- (void)setFontName:(NSString *)fontName{
    _fontName = fontName;
    self.fontSize = self.NomrmalSize;
    
}
-(CGFloat)NomrmalSize
{
    if (_NomrmalSize == 0) {
        _NomrmalSize = kNormalSize;
    }
    return _NomrmalSize;
}
- (CGFloat)rate
{
    if (_rate == 0) {
        _rate = Defaultrate;
    }
    return _rate;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:kNormalSize]];
        
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
    return self;
}
- (instancetype)initWithTitles:(NSArray *)titles AndIndex:(int)index
{
    self = [super init];
    if (self) {
        NSString *title =  titles[index];
        
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items AndIndex:(int)index
{
    self = [super init];
    if (self)
    {
        MenuViewItem *itemData = [items objectAtIndex:index];
        [self setTitle:itemData.title forState:UIControlStateNormal];
        item = itemData;
        
        m_redPoint = [[UIView alloc] init];
        m_redPoint.backgroundColor = [UIColor redColor];
        m_redPoint.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:m_redPoint];
        // align m_redPoint from the right
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[m_redPoint]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(m_redPoint)]];
        
        // align m_redPoint from the top
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[m_redPoint]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(m_redPoint)]];
        
        // width constraint
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[m_redPoint(==6)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(m_redPoint)]];
        
        // height constraint
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[m_redPoint(==6)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(m_redPoint)]];
        [m_redPoint setHidden:YES];
        m_redPoint.layer.cornerRadius = 3;
        
        // create KVO controller instance
        _KVOController = [FBKVOController controllerWithObserver:self];
        
        __weak typeof(self) weakSelf = self;
        // handle clock change, including initial value
        [_KVOController observe:item keyPath:@"count" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(MenuViewBtn *updateView, MenuViewItem *itemData, NSDictionary *change) {
            
            // update observer with new value
            int count = [[change objectForKey:@"new"] intValue];
            if (count > 0)
                [weakSelf showRedPoint:YES];
            else
                [weakSelf showRedPoint:NO];
        }];

    }
    return self;
}

- (void)selectedItemWithoutAnimation
{
    self.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(self.rate, self.rate);
    }];
}
- (void)deselectedItemWithoutAnimation
{
    self.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)setRGB
{
    int numNormal = (int)CGColorGetNumberOfComponents(self.normalColor.CGColor);
    int numSelected = (int)CGColorGetNumberOfComponents(self.selectedColor.CGColor);
    if (numNormal == 4&&numSelected == 4) {
        // UIDeviceRGBColorSpace
        const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
        const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
        rgba[0] = norComponents[0];
        rgbaGAP[0] = selComponents[0]-rgba[0];
        rgba[1] = norComponents[1];
        rgbaGAP[1] = selComponents[1]-rgba[1];
        rgba[2] = norComponents[2];
        rgbaGAP[2] = selComponents[2]-rgba[2];
        rgba[3] = norComponents[3];
        rgbaGAP[3] =  selComponents[3]-rgba[3];
    }else{
        if (numNormal == 2) {
            const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
            self.normalColor = [UIColor colorWithRed:norComponents[0] green:norComponents[0] blue:norComponents[0] alpha:norComponents[1]];
        }
        if (numSelected == 2) {
            const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
            self.selectedColor = [UIColor colorWithRed:selComponents[0] green:selComponents[0] blue:selComponents[0] alpha:selComponents[1]];
        }
    }

}
- (void)ChangSelectedColorWithRate:(CGFloat)rate
{
    [self setRGB];
    CGFloat r = rgba[0] + rgbaGAP[0]*(1-rate);
    CGFloat g = rgba[1] + rgbaGAP[1]*(1-rate);
    CGFloat b = rgba[2] + rgbaGAP[2]*(1-rate);
    CGFloat a = rgba[3] + rgbaGAP[3]*(1-rate);
    self.titlecolor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    [self setTitleColor:self.titlecolor forState:UIControlStateNormal];
    
}

- (void)ChangSelectedColorAndScalWithRate:(CGFloat)rate
{
    [self ChangSelectedColorWithRate:rate];
    CGFloat scalrate = self.rate - rate * (self.rate - 1);
    self.transform = CGAffineTransformMakeScale(scalrate, scalrate);

}

- (void)showRedPoint:(BOOL)bShow
{
    if (bShow && m_redPoint && self.item.count > 0)
    {
        [m_redPoint setHidden:NO];
    }
    else
    {
        [m_redPoint setHidden:YES];
    }
}
@end


@implementation MenuViewItem
@end
