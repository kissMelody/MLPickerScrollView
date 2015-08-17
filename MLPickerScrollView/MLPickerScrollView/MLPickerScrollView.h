//
//  MLPickerScrollView.h
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/14.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//  Github 地址：https://github.com/kissMelody/MLPickerScrollView

#import <UIKit/UIKit.h>

@class MLPickerItem,MLPickerScrollView;

@protocol MLPickerScrollViewDelegate <NSObject>

/**
 
 *  选中（代理方法-可选）
 *
 *  @param menuScollView MLPickerScrollView
 *  @param index         下标
 */
@optional
- (void)pickerScrollView:(MLPickerScrollView *)menuScrollView
didSelecteItemAtIndex:(NSInteger)index;

/**
 *  改变中心位置的Item样式
 *
 *  @param item MLPickerItem
 */
- (void)itemForIndexChange:(MLPickerItem *)item;

/**
 *  改变-非-中心位置的Item样式
 *
 *  @param item MLPickerItem
 */
- (void)itemForIndexBack:(MLPickerItem *)item;

@end

@protocol MLPickerScrollViewDataSource <NSObject>

/**
 *  个数
 *
 *  @param menuScollView MLPickerScrollView
 *
 *  @return 需要展示的item个数
 */
- (NSInteger)numberOfItemAtPickerScrollView:(MLPickerScrollView *)pickerScrollView;

/**
 *  用来创建MLPickerItem
 *
 *  @param menuScollView MLPickerScrollView
 *  @param index         位置下标
 *
 *  @return MLPickerItem
 */
- (MLPickerItem *)pickerScrollView:(MLPickerScrollView *)pickerScrollView
                  itemAtIndex:(NSInteger)index;

@end

@interface MLPickerScrollView : UIView

/** 选中下标 */
@property (nonatomic, assign)NSInteger seletedIndex;
/** menu宽 */
@property (nonatomic, assign)CGFloat itemWidth;
/** menu高 */
@property (nonatomic, assign)CGFloat itemHeight;
/** 第一个item X值 */
@property (nonatomic, assign)CGFloat firstItemX;

@property (nonatomic, weak)id<MLPickerScrollViewDelegate> delegate;
@property (nonatomic, weak)id<MLPickerScrollViewDataSource> dataSource;

- (void)reloadData;
- (void)scollToSelectdIndex:(NSInteger)index;

@end