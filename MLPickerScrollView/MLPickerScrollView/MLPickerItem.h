//
//  MLPickerItem.h
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/14.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//  Github 地址：https://github.com/kissMelody/MLPickerScrollView
/**
 *  BaseItem
 */
#import <UIKit/UIKit.h>

@interface MLPickerItem : UIView

@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)CGSize originalSize;
@property (nonatomic, assign)BOOL selected;
/**
 *  选中回调
 */
@property (nonatomic, copy) void(^PickerItemSelectBlock)(NSInteger index);

/**
 *  子类重写实现
 */
- (void)changeSizeOfItem;
- (void)backSizeOfItem;

@end
