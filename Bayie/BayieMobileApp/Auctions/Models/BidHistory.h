//
//  BidHistory.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/29/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidHistory : NSObject
@property (nonatomic, strong) NSString *bidBy;
@property (nonatomic, assign) CGFloat bid_amount;
@property (nonatomic, strong) NSString *bid_time;
@property (nonatomic, strong) NSString *profile_image;
@property (nonatomic, strong) NSString *imageBaseUrl;
-(id)initWithBidDictionary:(NSDictionary *)bidDictionary;
@end
