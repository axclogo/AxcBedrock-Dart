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
    // Do any additional setup after loading the view.
    self.giftView.frame = CGRectMake(0, 100, self.view.frame.size.width - 100, 200);
    [self.giftView reloadHeight];
}

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
// 连击
- (void)axc_giftView:(AxcGiftView *)giftView comboWithGift:(nonnull id)gift showView:(nonnull UIView *)showView{
    ShowGiftView *gfView = (ShowGiftView *)showView;
    gfView.model = gift;
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger index = arc4random()%self.giftArray.count;
    NSDictionary *gift_dic = [self.giftArray objectAtIndex:index];
    
    // 生成礼物模型
    ShowGiftModel *sendGift = [ShowGiftModel giftWithName:gift_dic[@"name"]
                                                     user:gift_dic[@"user"]
                                                    count:gift_dic[@"count"]];
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
        _giftView.showMaxGiftViewHeight = 60;   // 每个展示礼物的高度
        _giftView.giftShowTime = 5;             // 普遍的展示时间
        _giftView.giftAnimationTime = 0.5;      // 礼物出入场动画时间
        
        _giftView.arrangementType = AxcGiftViewArrangementTypeBottomToTop;  // 优先排列方式，从上到下或从下到上
        _giftView.enterAnimationStyle = AxcGiftOperationAnimationStyleLeft; // 礼物入场位置
        _giftView.quitAnimationStyle = AxcGiftOperationAnimationStyleLeft; // 礼物出场位置
        _giftView.is_gradually = YES;   // 开启渐入渐出动画效果
        
        _giftView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_giftView];
    }
    return _giftView;
}

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
                       [self user:@"机器" name:@"飞机" count:1],
                       [self user:@"芹菜盒子" name:@"开通伯爵" count:1]];
    }
    return _giftArray;
}

- (NSDictionary *)user:(NSString *)user name:(NSString *)name count:(NSInteger )count{
    return @{@"user":user,@"name":name,@"count":@(count)};
}



@end
