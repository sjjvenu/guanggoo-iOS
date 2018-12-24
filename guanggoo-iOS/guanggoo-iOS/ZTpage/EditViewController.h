/**
 * editViewController
 * @description 本文件提供拖动排序编辑界面，点击编辑按钮之后可以进行删除和长按拖动排序
 * @package
 * @author 		yinlinlin
 * @copyright 	Copyright (c) 2012-2020
 * @version 		1.0
 * @description 本文件提供拖动排序编辑界面，点击编辑按钮之后可以进行删除和长按拖动排序
 */

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController
{
    //用来显示已订阅按钮列表的scrollerView
    UIScrollView * m_showItemsView;
    
    //用来显示按钮列表的scrollerView
    UIScrollView * m_hideItemsView;
    
    //拖动按钮的起始位置
    CGPoint _dragFromPoint;
    
    //移动到的位置中心
    CGPoint _dragToPoint;
    
    //移动到的最后的位置
    CGRect _dragToFrame;
    BOOL _isDragTileContainedInOtherTile;
    //navigation右侧编辑按钮
    UIButton * _editBu;
    
    //记录处理之后数组
    NSMutableArray * m_showItemsList;
    
    NSMutableArray * m_hideItemsList;
    
    //被删除按钮位置
    NSInteger _deleteIndex;
}

//从上一界面接收相册相关数据
@property (retain, nonatomic) NSArray * showItemsList;
@property (retain, nonatomic) NSArray * hideItemsList;
//设置最小栏目个数
@property (nonatomic) int retainItemsNum;
@property (copy, nonatomic) void(^sortCompleteCallBack)(NSArray *,NSArray *);

@end
