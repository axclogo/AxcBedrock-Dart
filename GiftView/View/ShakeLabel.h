//
//  ShakeLabel.h
//  GiftView
//
//  Created by 众诚云金 on 2020/9/9.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeLabel : UILabel
// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic,strong) UIColor *borderColor;

- (void)startAnimWithDuration:(NSTimeInterval)duration;
@end
