//
//  ShowGiftView.h
//  GiftView
//
//  Created by 众诚云金 on 2020/9/9.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowGiftModel.h"
#import "ShakeLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowGiftView : UIView

+ (ShowGiftView *)loadXibView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet ShakeLabel *countLabel;

@property(nonatomic,strong)ShowGiftModel *model;

@end

NS_ASSUME_NONNULL_END
