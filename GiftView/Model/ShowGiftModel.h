//
//  ShowGiftModel.h
//  GiftView
//
//  Created by 众诚云金 on 2020/9/9.
//  Copyright © 2020 AxcLogo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowGiftModel : NSObject


+ (instancetype )giftWithName:(NSString *)name user:(NSString *)user count:(NSNumber *)count;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSString *user;

@end

NS_ASSUME_NONNULL_END
