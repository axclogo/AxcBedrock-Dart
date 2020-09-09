//
//  ShowGiftModel.m
//  GiftView
//
//  Created by 众诚云金 on 2020/9/9.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import "ShowGiftModel.h"

@implementation ShowGiftModel

+ (instancetype )giftWithName:(NSString *)name user:(NSString *)user count:(NSNumber *)count{
    ShowGiftModel *model = [ShowGiftModel new];
    model.name = name;
    model.count = count.integerValue;
    model.user = user;
    return model;
}


@end
