//
//  MLPickerScrollView.m
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/14.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//

#define kAnimationTime .2

#import "MLPickerScrollView.h"
#import "MLPickerItem.h"

@interface MLPickerScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *items;

@end

@implementation MLPickerScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - UI
- (void)setUp
{
    self.items = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:
                       CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.decelerationRate = 0.5;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.firstItemX = 0;
    [self addSubview:self.scrollView];
}

#pragma mark - layout Items
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.items) {
        return;
    }
    
    [self layoutItems];
}

- (void)layoutItems
{
    // layout
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    // item起始X值
    CGFloat startX = self.firstItemX;
    for (int i = 0; i < self.items.count; i++) {
        MLPickerItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(startX, CGRectGetHeight(self.bounds)-self.itemHeight, self.itemWidth, self.itemHeight);
        startX += self.itemWidth;
    }
    
    self.scrollView.contentSize = CGSizeMake(MAX(startX+CGRectGetWidth(self.bounds)-self.firstItemX-self.itemWidth *.5, startX), CGRectGetHeight(self.bounds));
    
    [self setItemAtContentOffset:self.scrollView.contentOffset];
}

#pragma mark - public Method（GetData）
- (void)reloadData
{
    // remove
    for (MLPickerItem *item in self.items) {
        [item removeFromSuperview];
    }
    [self.items removeAllObjects];
    
    // create
    NSInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemAtPickerScrollView:)]) {
        count = [self.dataSource numberOfItemAtPickerScrollView:self];
    }
    
    for (NSInteger i = 0; i < count; i++) {
        MLPickerItem *item = nil;
        if ([self.dataSource respondsToSelector:@selector(pickerScrollView:itemAtIndex:)]) {
            item = [self.dataSource pickerScrollView:self itemAtIndex:i];
        }
        NSAssert(item, @"[self.dataSource pickerScrollView: itemAtIndex:index] can not nil");
        item.originalSize = CGSizeMake(self.itemWidth, self.itemHeight);
        [self.items addObject:item];
        [self.scrollView addSubview:item];
        item.index = i;
    }
    
    // layout
    [self layoutItems];
}

- (void)scollToSelectdIndex:(NSInteger)index
{
    [self selectItemAtIndex:index];
}

#pragma mark - Helper
/** 根据scrollView的contentoffset来 是哪个item处于中心点区域， 然后传出去通知外面 */
- (void)setItemAtContentOffset:(CGPoint)offset
{
    NSInteger centerIndex = roundf(offset.x / self.itemWidth);
    
    for (int i = 0; i < self.items.count; i++) {
        MLPickerItem * item = [self.items objectAtIndex:i];
        [self itemInCenterBack:item];
        if (centerIndex == i) {
            [self itemInCenterChange:item];
            _seletedIndex = centerIndex;
        }
    }
}

- (void)scollToItemViewAtIndex:(NSInteger)index animated:(BOOL)animated
{
    CGPoint point = CGPointMake(index * _itemWidth,self.scrollView.contentOffset.y);
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.scrollView setContentOffset:point];
    } completion:^(BOOL finished) {
        [self setItemAtContentOffset:point];
    }];
}

- (void)setCenterContentOffset:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX < 0) {
        offsetX = self.itemWidth * 0.5;
    }else if (offsetX > (self.items.count - 1) * self.itemWidth) {
        offsetX = (self.items.count - 1) * self.itemWidth;
    }
    
    NSInteger value = roundf(offsetX / self.itemWidth);
    [UIView animateWithDuration:kAnimationTime animations:^{
        [scrollView setContentOffset:CGPointMake(self.itemWidth * value, scrollView.contentOffset.y)];
    } completion:^(BOOL finished) {
        [self setItemAtContentOffset:scrollView.contentOffset];
    }];
}

#pragma mark - delegate
- (void)selectItemAtIndex:(NSInteger)index
{
    _seletedIndex = index;
    [self scollToItemViewAtIndex:_seletedIndex animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerScrollView:didSelecteItemAtIndex:)]) {
        [self.delegate pickerScrollView:self didSelecteItemAtIndex:_seletedIndex];
    }
}

- (void)itemInCenterChange:(MLPickerItem*)item
{
    if ([self.delegate respondsToSelector:@selector(itemForIndexChange:)]) {
        [self.delegate itemForIndexChange:item];
    }
}

- (void)itemInCenterBack:(MLPickerItem*)item
{
    if ([self.delegate respondsToSelector:@selector(itemForIndexBack:)]) {
        [self.delegate itemForIndexBack:item];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i = 0; i < self.items.count; i++) {
        MLPickerItem * item = [self.items objectAtIndex:i];
        [self itemInCenterBack:item];
    }
}

/** 手指离开屏幕后ScrollView还会继续滚动一段时间直到停止 时执行
 *  如果需要scrollview在停止滑动后一定要执行某段代码的话应该搭配scrollViewDidEndDragging函数使用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setCenterContentOffset:scrollView];
}

/** UIScrollView真正停止滑动，应该怎么判断: 当decelerate = true时，才会调UIScrollView的delegate */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self setCenterContentOffset:scrollView];
    }
}

@end