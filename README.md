# MLPickerScrollView
## Introduction:
* The easiest way to use PickerScrollView
* 这是一个对横向滚动选择器的自定义UI控件，只要几行代码就可以集成类似横向滚动中间放大的效果并且选中的功能。
 
## Presentation:
#### 模拟场景<选择折扣>有滚动选中中间Item和点击效果Item等效果
![(MLPickerScrollView gif)](http://github.com/kissMelody/MLPickerScrollView/MLPickerScrollView.gif)

## Usage:
#### 代码例子:选择场景为 选择折扣

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
## Requirement:
* iOS7.0以上
* Xcode 6
