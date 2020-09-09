//
//  AxcGiftOperationCell.m
//  GiftView
//
//  Created by 众诚云金 on 2020/9/8.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import "AxcGiftOperationCell.h"

@implementation AxcGiftOperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor =
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 动画相关
// 出现
- (void)appearAnimation{
    self.is_use = YES;
    // 坐标
    CGRect frame = CGRectZero;
    switch (self.enterAnimationStyle) {
        case AxcGiftOperationAnimationStyleLeft:{   // 左
            frame = [self leftFrame];
        }break;
        case AxcGiftOperationAnimationStyleRight:{  // 右
            frame = [self rightFrame];
        }break;
        case AxcGiftOperationAnimationStyleTop:{    // 上
            frame = [self topFrame];
        }break;
        case AxcGiftOperationAnimationStyleBottom:{ // 下
            frame = [self bottomFrame];
        }break;
        case AxcGiftOperationAnimationStyleCustom:{ // 自定义
            frame = [self customFrameWithState:AxcGiftOperationAnimationStateEnter];
        }break;
        default:break;
    }
    self.giftAnimationView.frame = frame;
    // 渐入渐出
    if (self.is_gradually) {
        self.giftAnimationView.alpha = 0;
    }
    [UIView animateWithDuration:self.giftAnimationTime animations:^{
        self.giftAnimationView.frame = self.bounds;
        self.giftAnimationView.alpha = 1;
    }];
    [self resetTimer];
}

// 消失
- (void)aisappearAnimation{
    // 即将完成回调
    [self.delegate giftShowWillComplete:self];

    self.giftAnimationView.frame = self.bounds;
    [UIView animateWithDuration:self.giftAnimationTime animations:^{
        CGRect frame = CGRectZero;
        switch (self.quitAnimationStyle) {
            case AxcGiftOperationAnimationStyleLeft:{   // 左
                frame = [self leftFrame];
            }break;
            case AxcGiftOperationAnimationStyleRight:{  // 右
                frame = [self rightFrame];
            }break;
            case AxcGiftOperationAnimationStyleTop:{    // 上
                frame = [self topFrame];
            }break;
            case AxcGiftOperationAnimationStyleBottom:{ // 下
                frame = [self bottomFrame];
            }break;
            case AxcGiftOperationAnimationStyleCustom:{ // 自定义
                frame = [self customFrameWithState:AxcGiftOperationAnimationStateQuit];
            }break;
            default:break;
        }
        self.giftAnimationView.frame = frame;

        // 渐入渐出
        if (self.is_gradually) {
            self.giftAnimationView.alpha = 0;
        }
    }completion:^(BOOL finished) {
        [self emptyData];
        // 回调展示完成
        [self.delegate giftShowComplete];
    }];
}
#pragma mark - 坐标
#define kViweHeight self.frame.size.height
#define kViweWidth self.frame.size.width
- (CGRect)customFrameWithState:(AxcGiftOperationAnimationState )state{
    if ([self.delegate respondsToSelector:@selector(customAnimationWithState:gift:identifier:)]) {
        return [self.delegate customAnimationWithState:state gift:self.gift identifier:self.identifier];
    }
    return CGRectZero;  // 未设置
}
- (CGRect)bottomFrame{
    return CGRectMake(0,kViweHeight,kViweWidth,kViweHeight);
}
- (CGRect)topFrame{
    return CGRectMake(0,-kViweHeight,kViweWidth,kViweHeight);
}
- (CGRect)rightFrame{
    return CGRectMake(kViweWidth,0,kViweWidth,kViweHeight);
}
- (CGRect )leftFrame{
    return CGRectMake(-kViweWidth,0,kViweWidth,kViweHeight);
}

#pragma mark - 其他函数
// 清空数据
- (void)emptyData{
    self.identifier = nil;
    self.is_use = NO;
}
// 重置计时器
- (void)resetTimer{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(aisappearAnimation) object:self.identifier];
    [self performSelector:@selector(aisappearAnimation) withObject:self.identifier afterDelay:self.showTime];
}

- (void)setGiftAnimationView:(UIView *)giftAnimationView{
    [_giftAnimationView removeFromSuperview];
    _giftAnimationView = giftAnimationView;
    _giftAnimationView.alpha = 1;
    _giftAnimationView.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_giftAnimationView];
}

#pragma mark - 懒加载

@end
