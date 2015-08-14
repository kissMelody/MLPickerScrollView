//
//  MLPickerItem.m
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/14.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//

#import "MLPickerItem.h"

@implementation MLPickerItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTapGesture];
    }
    return self;
}

- (void)addTapGesture
{
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap
{
    if (self.PickerItemSelectBlock) {
        self.PickerItemSelectBlock(self.index);
    }
}

// 留给子类调用
- (void)changeSizeOfItem{}
- (void)backSizeOfItem{}


@end
