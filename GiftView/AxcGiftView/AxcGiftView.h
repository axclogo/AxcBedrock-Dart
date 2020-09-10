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

/// 触发连击事件，当两个ID发生重复时，判定为连击事件，此回调中需要更新视图的连击数数据
/// 也可以在这里可以操作View需要做什么样的动画
- (void)axc_giftView:(AxcGiftView *)giftView comboWithGift:(id )gift showView:(UIView *)showView;

@optional
/// 礼物点击事件
/// 当礼物被点击后，触发的回调
- (void)axc_giftView:(AxcGiftView *)giftView clickWithShowView:(UIView *)showView gift:(id )gift identifier:(NSString *)identifier;

#pragma mark 礼物动画管理

/// 自定义礼物的入场和出场坐标
/// 需要enterAnimationStyle或者quitAnimationStyle设置成AxcGiftOperationAnimationStyleCustom才能调用
/// 根据state来判断礼物是进场还是出场状态
- (CGRect )axc_giftView:(AxcGiftView *)giftView customFrameAnimationWithState:(AxcGiftOperationAnimationState)state
                   gift:(id)gift identifier:(NSString *)identifier;

/// 是否需要渐入渐出
/// 可以根据不同的礼物设置是否渐入渐出，来实现自己需要的效果
- (BOOL )axc_giftView:(AxcGiftView *)giftView graduallyWithGift:(id )gift
           identifier:(NSString *)identifier;

/// 礼物动画时间
/// 可以根据不同礼物设置不同的动画时间
/// 根据state来判断礼物是进场还是出场的动画时间
- (CGFloat )axc_giftView:(AxcGiftView *)giftView giftAnimationTimeWithState:(AxcGiftOperationAnimationState)state
                    gift:(id )gift identifier:(NSString *)identifier;

/// 礼物动画时间曲线
/// 可以根据不同礼物设置不同的动画时间曲线
/// 根据state来判断礼物是进场还是出场的状态
- (UIViewAnimationOptions )axc_giftView:(AxcGiftView *)giftView giftAnimationOptionsWithState:(AxcGiftOperationAnimationState)state
                                   gift:(id )gift identifier:(NSString *)identifier;

/// 该礼物的展示时间
/// 在这里可以单独设置该礼物的展示时间，比方说价格高的，时间可以长一点
- (CGFloat )axc_giftView:(AxcGiftView *)giftView showTimeWithGift:(id )gift identifier:(NSString *)identifier;

/// 礼物动画延迟
/// 可以根据不同礼物设置不同的动画延迟
/// 根据state来判断礼物是进场还是出场的动画延迟
- (CGFloat )axc_giftView:(AxcGiftView *)giftView giftAnimationDelayWithState:(AxcGiftOperationAnimationState)state
                    gift:(id )gift identifier:(NSString *)identifier;

#pragma mark 礼物生命周期
/// 礼物即将出现
/// 出现前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillAppearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier;
/// 礼物正在展示
/// 展示中可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDidAppearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier;
/// 礼物即将消失
/// 消失前可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDisappearWithShowView:(UIView *)showView gift:(id )gift
           identifier:(NSString *)identifier;
/// 礼物已经消失
/// 消失后可以做些什么
- (void )axc_giftView:(AxcGiftView *)giftView giftWillDidDisappearWithShowView:(UIView *)showView gift:(id )gift
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

@end

@interface AxcGiftView : UIView

/// 插入一个礼物
/// @param gift 自己定义的礼物模型
/// @param identifier 礼物的唯一ID，一般情况使用：礼物ID+赠送者ID+受赠者ID作为标识，确保相同的礼物能触发连击
- (void)insertGift:(id )gift identifier:(NSString *)identifier;

@property(nonatomic,weak)id <AxcGiftViewDelegate > delegate;
@property(nonatomic,weak)id <AxcGiftViewDataSource > dataSource;

/// 最大展示数 默认 3
@property(nonatomic,assign)NSInteger showMaxGiftViewCount;

/// 每个礼物视图高度 默认60
@property(nonatomic,assign)CGFloat showMaxGiftViewHeight;

/// 列表排列方式，从上向下还是从下向上
@property(nonatomic,assign)AxcGiftViewArrangementType arrangementType;

/// 礼物的展示时间  如果需要根据不同礼物展示不同时间，需要实现代理方法 默认5秒
@property(nonatomic,assign)CGFloat giftShowTime;

/// 礼物入场动画时间 如果需要根据不同礼物不同动画时间，需要实现代理方法 默认0.5
@property(nonatomic,assign)CGFloat giftEnterAnimationTime;
/// 礼物出场动画时间 如果需要根据不同礼物不同动画时间，需要实现代理方法 默认0.5
@property(nonatomic,assign)CGFloat giftQuitAnimationTime;

/// 入场礼物动画曲线 如果需要根据不同礼物不同时间曲线，需要实现代理方法 默认 UIViewAnimationOptionCurveEaseInOut
@property(nonatomic,assign)UIViewAnimationOptions giftEnterAnimationOptions;
/// 出场礼物动画曲线 如果需要根据不同礼物不同时间曲线，需要实现代理方法 默认 UIViewAnimationOptionCurveEaseInOut
@property(nonatomic,assign)UIViewAnimationOptions giftQuitAnimationOptions;

/// 入场礼物动画延迟 如果需要根据不同礼物不同延迟时间，需要实现代理方法 默认0
@property(nonatomic,assign)CGFloat giftEnterAnimationDelay;
/// 出场礼物动画延迟 如果需要根据不同礼物不同延迟时间，需要实现代理方法 默认0
@property(nonatomic,assign)CGFloat giftQuitAnimationDelay;

/// 出入场是否渐入渐出 如果需要根据不同礼物展示不同渐入渐出，需要实现代理方法 默认YES
@property(nonatomic,assign)BOOL is_gradually;

/// 入场动画位置 如果需要根据不同礼物展示不同动画位置，需要实现代理方法 默认左
@property(nonatomic,assign)AxcGiftOperationAnimationStyle enterAnimationStyle;

/// 出场动画位置 如果需要根据不同礼物展示不同动画位置，需要实现代理方法  默认左
@property(nonatomic,assign)AxcGiftOperationAnimationStyle quitAnimationStyle;



/// 刷新视图
- (void)reloadData;
/// 刷新高度
- (void)reloadHeight;

@end

NS_ASSUME_NONNULL_END
