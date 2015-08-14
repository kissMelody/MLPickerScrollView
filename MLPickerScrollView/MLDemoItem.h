//
//  MLDemoItem.h
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/14.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//
/**
 *  Demo  自定义 折扣 Item
 */
#import "MLPickerItem.h"

@interface MLDemoItem : MLPickerItem

@property (nonatomic, strong)UIButton *discount;
@property (nonatomic, copy)NSString *title;

- (void)setRedTitle;
- (void)setGrayTitle;

@end
