# AxcGiftView
![language](https://img.shields.io/badge/Language-Objective--C-8E44AD.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)
![Platform](https://img.shields.io/badge/platform-%20iOS%20-lightgrey.svg)

### 简介：
AxcGiftView是一个简单快捷的礼物列表展示组件，非常适用于直播项目中展示礼物条。<br><br>
使用非常简单，可设置参数很多，可以通过相关回调来详细细化设置。<br><br>
细化颗粒度可以针对单个礼物进行一些处理，如动画，生命周期等。<br><br>
礼物展示视图可以自定义任何UIView。<br><br>
无侵入式，不干涉Model层面。<br><br>
使用起来就如同UITableView一样简单快捷。<br><br>

### AxcGiftView对象说明

AxcGiftView 
主要视图，负责控制、监管、缓存礼物，基于TableView的模式来管理所有礼物栏的状态；<br><br>
AxcGiftOperationCell 
礼物展示操作条，负责控制动画、回调生命周期、展现礼物、计时替换礼物；<br><br>

### ======= 喜欢的给个Star支持一下，O(∩_∩)O谢谢 ======= 

### 框架支持
最低支持：iOS 8.0 
IDE：Xcode 10.0 及以上版本


### <a id="使用方法"></a>使用/安装

* 手动  
* 1.找到包含：</br>
`AxcGiftView.h.m`、</br>
`AxcGiftOperationCell.h.m`、</br>
的`AxcGiftView`文件夹;</br>
* 2.直接把`AxcGiftView`文件夹拖入到您的工程中;
* 3.导入 `"AxcGiftView.h"`


### <a id="功能介绍"></a>功能介绍
- [x] 原生的动画支持
- [x] 自定义动画等
- [x] 无侵入式，不干涉Model层面
- [x] 如同TableView一样的体验
- [x] 设置颗粒度可针对每一条数据
- [x] 支持并不依赖其他三方库
- [x] 轻量级


### 示例代码：
```
#pragma mark - 必实现的回调
// 需要生成一个展示视图
- (UIView *)axc_giftView:(AxcGiftView *)giftView giftViewWithGift:(id)gift identifier:(NSString *)identifier{
    ShowGiftView *gfView = [ShowGiftView loadXibView];
    gfView.model = gift;
    return gfView;
}
// 连击处理
- (id)axc_giftView:(AxcGiftView *)giftView comboCountWithGifts:(NSArray *)gifts{
    ShowGiftModel *cu_gift = (ShowGiftModel *)gifts.firstObject;
    ShowGiftModel *next_gift = (ShowGiftModel *)gifts.lastObject;
    cu_gift.count = next_gift.count + cu_gift.count;
    return cu_gift;
}
// 连击后数据更新
- (void)axc_giftView:(AxcGiftView *)giftView comboWithGift:(nonnull id)gift showView:(nonnull UIView *)showView{
    ShowGiftView *gfView = (ShowGiftView *)showView;
    gfView.model = gift;
}
#pragma mark - 模拟发送礼物
// 点击屏幕发送礼物
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger index = arc4random()%self.giftArray.count;
    NSDictionary *gift_dic = [self.giftArray objectAtIndex:index];
    
    // 生成礼物模型
    ShowGiftModel *sendGift = [ShowGiftModel giftWithName:gift_dic[@"name"]
                                                     user:gift_dic[@"user"]
                                                    count:gift_dic[@"count"]];
    // ID是判定礼物是否会触发连击的唯一标准
    NSString *identifier = [NSString stringWithFormat:@"%@-%@",sendGift.user,sendGift.name];
    // 发送礼物
    [self.giftView insertGift:sendGift identifier:identifier];
}
#pragma mark - 懒加载
- (AxcGiftView *)giftView{
    if (!_giftView) {
        _giftView = [AxcGiftView new];
        _giftView.delegate = self;
        _giftView.dataSource = self;
        
        _giftView.showMaxGiftViewCount = 3;     // 最大展示数
        _giftView.showMaxGiftViewHeight = 70;   // 每个展示礼物的高度
        _giftView.giftShowTime = 5;             // 普遍的展示时间
        // 一旦设置了代理的方法，该参数无效
        _giftView.giftEnterAnimationTime = 0.5;      // 礼物出入场动画时间
        _giftView.giftQuitAnimationTime  = 0.5;      // 礼物出入场动画时间

        _giftView.arrangementType = AxcGiftViewArrangementTypeBottomToTop;  // 优先排列方式，从上到下或从下到上
        _giftView.enterAnimationStyle = AxcGiftOperationAnimationStyleLeft; // 礼物入场位置
        _giftView.quitAnimationStyle = AxcGiftOperationAnimationStyleRight; // 礼物出场位置
        _giftView.is_gradually = YES;   // 开启渐入渐出动画效果
        
        _giftView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_giftView];
    }
    return _giftView;
}
```
## 意见和定制

> 如果您在使用中有好的需求及建议，或者遇到什么bug，欢迎随时issue，我会及时的回复<br>
