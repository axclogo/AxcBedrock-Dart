//
//  ViewController.m
//  GiftView
//
//  Created by 众诚云金 on 2020/9/8.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import "ViewController.h"
#import "AxcGiftView.h"

#import "ShowGiftView.h"

@interface ViewController ()<AxcGiftViewDelegate,AxcGiftViewDataSource>

@property(nonatomic,strong)NSArray *giftArray;

@property(nonatomic,strong)AxcGiftView *giftView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加视图
    self.giftView.frame = CGRectMake(0, 100, self.view.frame.size.width - 100, 200);
    [self.giftView reloadHeight];
}
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


#pragma mark - 以下是非必须实现的回调
/// 礼物即将出现
/// 出现前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillAppearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier{
    ShowGiftModel *gift_ = (ShowGiftModel *)gift;
    NSLog(@"%@赠送的%@即将出现",gift_.user,gift_.name);
}
/// 礼物正在展示
/// 出现前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDidAppearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier{
    ShowGiftModel *gift_ = (ShowGiftModel *)gift;
    NSLog(@"%@赠送的%@正在展示",gift_.user,gift_.name);
    ShowGiftView *gfView = (ShowGiftView *)showView;
    [gfView.countLabel startAnimWithDuration:0.3];  // 展现过程中跳动一下
}
/// 礼物即将消失
/// 消失前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDisappearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier{
    ShowGiftModel *gift_ = (ShowGiftModel *)gift;
    NSLog(@"%@赠送的%@即将消失",gift_.user,gift_.name);
}
/// 礼物已经消失
/// 可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDidDisappearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier{
    ShowGiftModel *gift_ = (ShowGiftModel *)gift;
    NSLog(@"%@赠送的%@已经消失",gift_.user,gift_.name);
}
// 设置出入场的动画时间
- (CGFloat )axc_giftView:(AxcGiftView *)giftView giftAnimationTimeWithState:(AxcGiftOperationAnimationState)state
                    gift:(id )gift identifier:(NSString *)identifier{
    return state == AxcGiftOperationAnimationStateEnter ? 1 : 0.5;
}
// 点击事件
- (void)axc_giftView:(AxcGiftView *)giftView clickWithShowView:(UIView *)showView gift:(id)gift identifier:(NSString *)identifier{
    ShowGiftModel *gift_ = (ShowGiftModel *)gift;
    NSLog(@"点击了-----%@赠送的%@",gift_.user,gift_.name);
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
// 模拟数据源
- (NSArray *)giftArray{
    if (!_giftArray) {
        _giftArray = @[[self user:@"小杰" name:@"鲜花" count:1],
                       [self user:@"寅子" name:@"汽车" count:1],
                       [self user:@"AxcLogo" name:@"跑车" count:10],
                       [self user:@"哲哲" name:@"啤酒" count:1],
                       [self user:@"双双" name:@"十里桃花" count:1],
                       [self user:@"房管" name:@"超级火箭" count:1],
                       [self user:@"僵尸" name:@"VIP办卡" count:1],
                       [self user:@"杨树" name:@"星鱼丸" count:1],
                       [self user:@"机器" name:@"飞机" count:2],
                       [self user:@"蚂蚁" name:@"十里桃花" count:5],
                       [self user:@"代理" name:@"超级火箭" count:3],
                       [self user:@"测试" name:@"VIP办卡" count:1],
                       [self user:@"用户" name:@"星鱼丸" count:4],
                       [self user:@"冰火" name:@"飞机" count:1],
                       [self user:@"盒子" name:@"开通伯爵" count:9]];
    }
    return _giftArray;
}

- (NSDictionary *)user:(NSString *)user name:(NSString *)name count:(NSInteger )count{
    return @{@"user":user,@"name":name,@"count":@(count)};
}



@end
