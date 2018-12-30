//
//  BidHistory.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/29/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "BidHistory.h"
NSString *const kBidBy = @"bidBy";
NSString *const kBidAmount = @"bid_amount";
NSString *const kBidTime = @"bid_time";
NSString *const kProfileImage = @"profile_image";

@implementation BidHistory
-(id)initWithBidDictionary:(NSDictionary *)bidDictionary{
    self = [super init];
    if (self) {
        self.bidBy = @"";
        self.bid_amount = 0.0;
        self.bid_time = @"";
        self.profile_image = @"";
    }
    if (![bidDictionary[kBidBy] isKindOfClass:[NSNull class]]){
        self.bidBy = bidDictionary[kBidBy];
    }
    if (![bidDictionary[kBidAmount] isKindOfClass:[NSNull class]]){
        self.bid_amount = [bidDictionary[kBidAmount] floatValue];
    }
    if (![bidDictionary[kBidTime] isKindOfClass:[NSNull class]]){
        self.bid_time = bidDictionary[kBidTime];
    }
    if (![bidDictionary[kProfileImage] isKindOfClass:[NSNull class]]){
        self.profile_image = bidDictionary[kProfileImage];
    }
    return self;
}
@end
