//
//  ViewController.m
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/11.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//
/**
 *  Demo 模拟实现横向滚动选择折扣
 */
#define kItemW 30
#define kItemH 68
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kRGB236 MLColor(236, 73, 73, 1.0)

#import "ViewController.h"
#import "MLPickerScrollView.h"
#import "MLDemoItem.h"
#import "MLDemoModel.h"

@interface ViewController ()<MLPickerScrollViewDataSource,MLPickerScrollViewDelegate,UIAlertViewDelegate>
{
    MLPickerScrollView *_pickerScollView;
    NSMutableArray *data;
    UIButton *sureButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self setUpSureButton];
}

#pragma mark - UI
- (void)setUpUI
{
    // 1.数据源
    data = [NSMutableArray array];
    NSArray *titleArray = @[@"不打折",@"9折",@"8折",@"7折",@"6折",@"5折",@"4折",@"3折",@"2折",@"1折"];
    for (int i = 0; i < titleArray.count; i++) {
        MLDemoModel *model = [[MLDemoModel alloc] init];
        model.dicountTitle = [titleArray objectAtIndex:i];
        [data addObject:model];
    }
    
    // 2.初始化
    _pickerScollView = [[MLPickerScrollView alloc] initWithFrame:CGRectMake(kItemW, SCREEN_HEIGHT - 350, SCREEN_WIDTH - kItemH, kItemH)];
    _pickerScollView.backgroundColor = [UIColor whiteColor];
    _pickerScollView.itemWidth = _pickerScollView.frame.size.width / 5;
    _pickerScollView.itemHeight = kItemH;
    _pickerScollView.firstItemX = (_pickerScollView.frame.size.width - _pickerScollView.itemWidth) * 0.5;
    _pickerScollView.dataSource = self;
    _pickerScollView.delegate = self;
    [self.view addSubview:_pickerScollView];
    
    // 3.刷新数据
    [_pickerScollView reloadData];
    
    // 4.滚动到对应折扣
    self.discount = (NSInteger)arc4random()%10;
    if (self.discount) {
        NSInteger number;
        for (int i = 0; i < data.count; i++) {
            MLDemoModel *model = [data objectAtIndex:i];
            if (model.dicountIndex == self.discount) {
                number = i;
            }
        }
         _pickerScollView.seletedIndex = number;
        [_pickerScollView scollToSelectdIndex:number];
    }
}

- (void)setUpSureButton
{
    sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(15, SCREEN_HEIGHT - 200, SCREEN_WIDTH - 30, 44);
    sureButton.backgroundColor = kRGB236;
    sureButton.layer.cornerRadius = 22;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

#pragma mark - Action
- (void)clickSure
{
     NSLog(@"确定--选择折扣Index为%ld",(long)_pickerScollView.seletedIndex);
    
    NSString *title;
    for (int i = 0; i < data.count; i++) {
        MLDemoModel *model = [data objectAtIndex:i];
        if (model.dicountIndex == _pickerScollView.seletedIndex) {
            title = model.dicountTitle;
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

#pragma mark - dataSource
- (NSInteger)numberOfItemAtPickerScrollView:(MLPickerScrollView *)pickerScrollView
{
    return data.count;
}

- (MLPickerItem *)pickerScrollView:(MLPickerScrollView *)pickerScrollView itemAtIndex:(NSInteger)index
{
    // creat
    MLDemoItem *item = [[MLDemoItem alloc] initWithFrame:CGRectMake(0, 0, pickerScrollView.itemWidth, pickerScrollView.itemHeight)];
    
    // assignment
    MLDemoModel *model = [data objectAtIndex:index];
    model.dicountIndex = index;
    item.title = model.dicountTitle;
    [item setGrayTitle];
    
    // tap
    item.PickerItemSelectBlock = ^(NSInteger d){
        [_pickerScollView scollToSelectdIndex:d];
    };
    
    return item;
}

#pragma mark - delegate
- (void)itemForIndexChange:(MLPickerItem *)item
{
    [item changeSizeOfItem];
}

- (void)itemForIndexBack:(MLPickerItem *)item
{
    [item backSizeOfItem];
}



@end
