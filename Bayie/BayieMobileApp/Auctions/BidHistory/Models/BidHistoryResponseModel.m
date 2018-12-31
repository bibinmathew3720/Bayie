//
//  BidHistoryResponseModel.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//
#import "BidHistory.h"
#import "BidHistoryResponseModel.h"

NSString *const kBidHistoryId = @"id";
NSString *const kBidHistoryAuctionId = @"auctions_id";
NSString *const kBidHistoryTitle = @"title";
NSString *const kBidHistoryArray = @"bid_history";


@implementation BidHistoryResponseModel
-(id)initWithBidHistoryResponse:(NSDictionary *)dataDictionary{
    self = [super init];
    if (self) {
        self.auctionId = 0;
        self.productId = 0;
        self.productName = @"";
    }
    if (![dataDictionary[kBidHistoryId] isKindOfClass:[NSNull class]]){
        self.productId = [dataDictionary[kBidHistoryId] intValue];
    }
    if (![dataDictionary[kBidHistoryTitle] isKindOfClass:[NSNull class]]){
        self.productName = dataDictionary[kBidHistoryTitle];
    }
    if (![dataDictionary[kBidHistoryAuctionId] isKindOfClass:[NSNull class]]){
        self.auctionId = [dataDictionary[kBidHistoryAuctionId] intValue];
    }
    if(![dataDictionary[kBidHistoryArray] isKindOfClass:[NSNull class]]){
        NSArray *bidArray = dataDictionary[kBidHistoryArray];
        self.bidHistoryarray = [[NSMutableArray alloc] init];
        for (NSDictionary *item in bidArray){
            BidHistory *bidHistory = [[BidHistory alloc] initWithBidDictionary:item];
            [self.bidHistoryarray addObject:bidHistory];
        }
    }
    return self;
}
@end
