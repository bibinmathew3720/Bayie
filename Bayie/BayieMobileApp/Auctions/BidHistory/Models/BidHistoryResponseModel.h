//
//  BidHistoryResponseModel.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidHistoryResponseModel : NSObject
@property (nonatomic, assign) int auctionId;
@property (nonatomic, assign) int productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSMutableArray *bidHistoryarray;
-(id)initWithBidHistoryResponse:(NSDictionary *)bidHistoryResponse;
@end
