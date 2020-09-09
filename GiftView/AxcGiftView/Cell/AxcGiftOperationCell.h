//
//  AxcGiftOperationCell.h
//  GiftView
//
//  Created by 众诚云金 on 2020/9/8.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AxcGiftOperationAnimationStyleLeft,     // 左
    AxcGiftOperationAnimationStyleRight,    // 右
    AxcGiftOperationAnimationStyleTop,      // 上
    AxcGiftOperationAnimationStyleBottom,   // 下
    
    AxcGiftOperationAnimationStyleCustom,   // 自定义 需要实现代理
} AxcGiftOperationAnimationStyle;

typedef enum : NSUInteger {
    AxcGiftOperationAnimationStateEnter,    // 入场
    AxcGiftOperationAnimationStateQuit,     // 出场
} AxcGiftOperationAnimationState;   // 动画状态



@class AxcGiftOperationCell;

@protocol AxcGiftOperationCellDelegate <NSObject>
// 展示即将完成
- (void)giftShowWillComplete:(AxcGiftOperationCell *)cell;
// 展示完成
- (void)giftShowComplete;
// 自定义动画位置回调
- (CGRect )customAnimationWithState:(AxcGiftOperationAnimationState )state gift:(id)gift identifier:(NSString *)identifier;
@end



@interface AxcGiftOperationCell : UITableViewCell

// 承载动画的View
@property(strong,nonatomic)UIView *giftAnimationView;

// 当前展示礼物的id
@property(nonatomic,strong)NSString *identifier;
// 礼物
@property(nonatomic,strong)id gift;
// 展示时间
@property(nonatomic,assign)CGFloat showTime;
// 礼物动画时间
@property(nonatomic,assign)CGFloat giftAnimationTime;
// 入场动画位置
@property(nonatomic,assign)AxcGiftOperationAnimationStyle enterAnimationStyle;
// 出场动画位置
@property(nonatomic,assign)AxcGiftOperationAnimationStyle quitAnimationStyle;
// 是否渐入渐出
@property(nonatomic,assign)BOOL is_gradually;

// 出现
- (void)appearAnimation;
// 消失
- (void)aisappearAnimation;
// 重置计时器
- (void)resetTimer;

// 是否使用中
@property(nonatomic,assign)BOOL is_use;
// 回调
@property(nonatomic,weak)id<AxcGiftOperationCellDelegate >delegate;

@end

