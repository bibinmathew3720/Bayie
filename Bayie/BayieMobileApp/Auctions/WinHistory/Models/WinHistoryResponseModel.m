//
//  WinHistoryResponseModel.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/31/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "WinHistoryResponseModel.h"

NSString *const kWinHistoryId = @"id";
NSString *const kWinHistoryAuctionId = @"auctions_id";
NSString *const kWinHistoryTitle = @"title";
NSString *const kWinHistoryShippingAddress = @"shipping_address";
NSString *const kWinHistoryShippingCity = @"shipping_city";
NSString *const kWinHistoryShippingZipCode = @"shipping_zipcode";
NSString *const kWinHistoryShippingStatus = @"status";

@implementation WinHistoryResponseModel
-(id)initWithWinHistoryResponse:(NSDictionary *)dataDictionary{
    self = [super init];
    if (self) {
        self.auctionId = 0;
        self.productId = 0;
        self.productName = @"";
        self.shippingAddress = @"-";
        self.shippingCity = @"-";
        self.shippingZipCode = @"-";
        self.shippingStatus = @"-";
    }
    if (![dataDictionary[kWinHistoryId] isKindOfClass:[NSNull class]]){
        self.productId = [dataDictionary[kWinHistoryId] intValue];
    }
    if (![dataDictionary[kWinHistoryTitle] isKindOfClass:[NSNull class]]){
        self.productName = dataDictionary[kWinHistoryTitle];
    }
    if (![dataDictionary[kWinHistoryAuctionId] isKindOfClass:[NSNull class]]){
        self.auctionId = [dataDictionary[kWinHistoryAuctionId] intValue];
    }
    if (![dataDictionary[kWinHistoryShippingAddress] isKindOfClass:[NSNull class]]){
        self.shippingAddress = dataDictionary[kWinHistoryShippingAddress];
    }
    if (![dataDictionary[kWinHistoryShippingCity] isKindOfClass:[NSNull class]]){
        self.shippingCity = dataDictionary[kWinHistoryShippingCity];
    }
    if (![dataDictionary[kWinHistoryShippingZipCode] isKindOfClass:[NSNull class]]){
        self.shippingZipCode = dataDictionary[kWinHistoryShippingZipCode];
    }
    if (![dataDictionary[kWinHistoryShippingStatus] isKindOfClass:[NSNull class]]){
        self.shippingStatus = dataDictionary[kWinHistoryShippingStatus];
    }
    return self;
}
@end
