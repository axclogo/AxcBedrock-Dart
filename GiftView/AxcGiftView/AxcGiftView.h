//
//  AxcGiftView.h
//  GiftView
//
//  Created by 众诚云金 on 2020/9/8.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcGiftOperationCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {     // 礼物出现的排列方式
    AxcGiftViewArrangementTypeTopToBottom,  // 从上到下
    AxcGiftViewArrangementTypeBottomToTop,  // 从下到上
} AxcGiftViewArrangementType;

@class AxcGiftView;
@protocol AxcGiftViewDelegate <NSObject>

@optional
/// 触发连击事件
/// 在这里可以操作View需要做什么样的动画
- (void)axc_giftView:(AxcGiftView *)giftView comboWithGift:(id )gift showView:(UIView *)showView;

/// 自定义礼物的入场和出场坐标
/// 需要enterAnimationStyle或者quitAnimationStyle设置成AxcGiftOperationAnimationStyleCustom才能调用
/// 根据state来判断礼物是进场还是出场状态
- (CGRect )axc_giftView:(AxcGiftView *)giftView customFrameAnimationWithState:(AxcGiftOperationAnimationState)state
                   gift:(id)gift identifier:(NSString *)identifier;

/// 是否需要渐入渐出
/// 可以根据不同的礼物设置是否渐入渐出，来实现自己需要的效果
- (BOOL )axc_giftView:(AxcGiftView *)giftView graduallyWithGift:(id )gift
           identifier:(NSString *)identifier;

/// 礼物即将出现
/// 出现前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillAppearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier;
/// 礼物即将消失
/// 消失前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDisappearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier;

@end

@protocol AxcGiftViewDataSource <NSObject>

/// 回调要一个view视图
/// @param giftView 回调的本视图
/// @param gift 传入的礼物模型
/// @param identifier 礼物唯一ID
- (UIView *)axc_giftView:(AxcGiftView *)giftView giftViewWithGift:(id )gift identifier:(NSString *)identifier;

/// 连击数处理，需要返回增加连击数后的礼物模型
/// @param giftView 回调的本视图
/// @param gifts 两个礼物，第一个是之前的礼物，第二个是新增加的礼物。
/// 在这里需要将两个礼物的计数相加，达到连击数的效果
/// 然后返回处理连击后的礼物模型
- (id )axc_giftView:(AxcGiftView *)giftView comboCountWithGifts:(NSArray *)gifts;

@optional
/// 该礼物的展示时间
/// @param giftView 回调的本视图
/// @param gift 礼物模型
/// @param identifier ID
/// 在这里可以单独设置该礼物的展示时间，比方说价格高的，时间可以长一点
- (CGFloat )axc_giftView:(AxcGiftView *)giftView showTimeWithGift:(id )gift identifier:(NSString *)identifier;

@end

@interface AxcGiftView : UIView
/// 最大展示数 默认 3
@property(nonatomic,assign)NSInteger showMaxGiftViewCount;

/// 每个礼物视图高度 默认60
@property(nonatomic,assign)CGFloat showMaxGiftViewHeight;

/// 列表排列方式，优先使用上边的还是下边的
@property(nonatomic,assign)AxcGiftViewArrangementType arrangementType;

/// 礼物展示时间，如果需要根据不同礼物展示不同时间，需要实现数据源方法 默认5秒
@property(nonatomic,assign)CGFloat giftShowTime;

/// 礼物动画时间 默认0.5
@property(nonatomic,assign)CGFloat giftAnimationTime;

/// 入场动画位置 默认左
@property(nonatomic,assign)AxcGiftOperationAnimationStyle enterAnimationStyle;

/// 出场动画位置 默认左
@property(nonatomic,assign)AxcGiftOperationAnimationStyle quitAnimationStyle;

/// 出入场是否渐入渐出，如果需要根据不同礼物展示不同时间，需要实现数据源方法 默认YES
@property(nonatomic,assign)BOOL is_gradually;


/// 刷新视图
- (void)reloadData;
/// 刷新高度
- (void)reloadHeight;

/// 插入一个礼物
/// @param gift 自己定义的礼物模型
/// @param identifier 礼物的唯一ID，一般情况使用：礼物ID+赠送者ID+受赠者ID作为标识，确保相同的礼物能触发连击
- (void)insertGift:(id )gift identifier:(NSString *)identifier;

@property(nonatomic,weak)id <AxcGiftViewDelegate > delegate;
@property(nonatomic,weak)id <AxcGiftViewDataSource > dataSource;

@end

NS_ASSUME_NONNULL_END
