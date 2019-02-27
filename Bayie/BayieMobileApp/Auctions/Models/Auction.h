//
//  Auction.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/17/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Auction : NSObject
@property (nonatomic, assign) int adId;
@property (nonatomic, strong) NSString *adTitle;
@property (nonatomic, strong) NSString *adTime;
@property (nonatomic, assign) int auctionId;
@property (nonatomic, assign) CGFloat basePrice;
@property (nonatomic, assign) int bidCount;
@property (nonatomic, assign) int categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, assign) CGFloat currentBidAmount;
@property (nonatomic, strong) NSString *currentBidUser;
@property (nonatomic, assign) CGFloat currentPrice;
@property (nonatomic, strong) NSString *adDescription;
@property (nonatomic, strong) NSString *expiredOn;
@property (nonatomic, strong) NSDate *expiredOnDate;
@property (nonatomic, assign) BOOL isExpired;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString *itemCondition;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) CGFloat minimumBidAmount;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *startsOn;
@property (nonatomic, strong) NSDate *startsOnDate;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, assign) int viewCount;
@property (nonatomic, strong) NSString *defaultImageUrl;
@property (nonatomic, strong) NSString *imageBaseUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *bidHistory;

-(id)initWithAuctionDictionary:(NSDictionary *)auctionDictionary;
@end
