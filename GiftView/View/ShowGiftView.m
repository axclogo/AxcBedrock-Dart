//
//  ShowGiftView.m
//  GiftView
//
//  Created by 众诚云金 on 2020/9/9.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import "ShowGiftView.h"

@implementation ShowGiftView

+ (ShowGiftView *)loadXibView{
    NSArray * xibArray = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] ;
    ShowGiftView *view = xibArray.firstObject;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)setModel:(ShowGiftModel *)model{
    _model = model;
    
    self.userNameLabel.text = _model.user;
    self.giftLabel.text = [NSString stringWithFormat:@"送出 %@",_model.name];
    self.countLabel.text = [NSString stringWithFormat:@"%ld",_model.count];
    
    self.countLabel.borderColor = [UIColor yellowColor];
    [self.countLabel startAnimWithDuration:0.3];

    self.userNameLabel.textColor =
    self.countLabel.textColor = [UIColor orangeColor];
    self.giftLabel.textColor = [UIColor whiteColor];
    
}

@end
