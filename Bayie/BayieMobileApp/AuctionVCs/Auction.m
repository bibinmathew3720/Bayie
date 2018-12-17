//
//  Auction.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/17/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "Auction.h"

@implementation Auction
-(id)initWithAuctionDictionary:(NSDictionary *)auctionDictionary{
    self = [super init];
    if (self) {
        self.adId = 1;
        self.title = @"";
    }
    return self;
}
@end
