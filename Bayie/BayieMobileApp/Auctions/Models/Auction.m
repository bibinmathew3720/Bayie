//
//  Auction.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/17/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "Auction.h"
#import "AdImages.h"
#import "BidHistory.h"
#import "NSString+Extension.h"

NSString *const kData = @"data";
NSString *const kAdId = @"id";
NSString *const kTitle = @"title";
NSString *const kTime = @"adTime";
NSString *const kAuctionaId = @"auctions_id";
NSString *const kBasePrice = @"base_price";
NSString *const kBidCount = @"bid_count";
NSString *const kCategoryId = @"category_Id";
NSString *const kCategoryName = @"category_name";
NSString *const kCreatedDate = @"createdDate";
NSString *const kCurrentBidAmount = @"current_bid_amount";
NSString *const kCurrentBidUser = @"current_bid_user";
NSString *const kCurrentPrice = @"current_price";
NSString *const kAdDescription = @"description";
NSString *const kAdExpiredOn = @"expired_on";
NSString *const kFavorite = @"favourite";
NSString *const kItemCondition = @"item_condition";
NSString *const kLocation = @"location";
NSString *const kMinimumBidAmount = @"min_bid_amount";
NSString *const kSlug = @"slug";
NSString *const kStartsOn = @"start_on";
NSString *const kStatus = @"status";
NSString *const kAuctionType = @"type";
NSString *const kViewCount = @"view_count";
NSString *const kDefaultImage = @"defaultImage";
NSString *const kImageBaseUrl = @"imageBaseUrl";
NSString *const kShareUrl = @"shareUrl";
NSString *const kImages = @"images";
NSString *const kBidHistory = @"bid_history";
NSString *const kImage_Url = @"image_url";

@implementation Auction
-(id)initWithAuctionDictionary:(NSDictionary *)auctionDictionary{
    self = [super init];
    if (self) {
        self.adId = 0;
        self.adTitle = @"";
        self.adTime = @"";
        self.auctionId = 0;
        self.basePrice = 0.0;
        self.bidCount = 0;
        self.categoryId = 0;
        self.categoryName = @"";
        self.createdDate = @"";
        self.currentBidAmount = 0.0;
        self.currentPrice = 0.0;
        self.currentBidUser = @"";
        self.adDescription = @"";
        self.expiredOn = @"";
        self.isExpired = NO;
        self.isFavorite = false;
        self.itemCondition = @"";
        self.location = @"";
        self.minimumBidAmount = 0.0;
        self.slug = @"";
        self.startsOn = @"";
        self.isActive = false;
        self.type = @"";
        self.viewCount = 0;
        self.defaultImageUrl = @"";
        self.imageBaseUrl = @"";
        self.shareUrl = @"";
        self.imageUrl = @"";
    }
    
    if(![auctionDictionary[kData] isKindOfClass:[NSNull class]]){
        NSDictionary *dataDictionary = auctionDictionary[kData];
        if (![dataDictionary[kAdId] isKindOfClass:[NSNull class]]){
            self.adId = [dataDictionary[kAdId] intValue];
        }
        if (![dataDictionary[kTitle] isKindOfClass:[NSNull class]]){
            self.adTitle = dataDictionary[kTitle];
        }
        if (![dataDictionary[kTime] isKindOfClass:[NSNull class]]){
            self.adTime = dataDictionary[kTime];
        }
        if (![dataDictionary[kAuctionaId] isKindOfClass:[NSNull class]]){
            self.auctionId = [dataDictionary[kAuctionaId] intValue];
        }
        if (![dataDictionary[kBasePrice] isKindOfClass:[NSNull class]]){
            self.basePrice = [dataDictionary[kBasePrice] floatValue];
        }
        if (![dataDictionary[kBidCount] isKindOfClass:[NSNull class]]){
            self.bidCount = [dataDictionary[kBidCount] intValue];
        }
        if (![dataDictionary[kCategoryId] isKindOfClass:[NSNull class]]){
            self.categoryId = [dataDictionary[kCategoryId] intValue];
        }
        if (![dataDictionary[kCategoryName] isKindOfClass:[NSNull class]]){
            self.categoryName = dataDictionary[kCategoryName];
        }
        if (![dataDictionary[kCreatedDate] isKindOfClass:[NSNull class]]){
            self.createdDate = dataDictionary[kCreatedDate];
        }
        if (![dataDictionary[kCurrentBidAmount] isKindOfClass:[NSNull class]]){
            self.currentBidAmount = [dataDictionary[kCurrentBidAmount] floatValue];
        }
        if (![dataDictionary[kCurrentBidUser] isKindOfClass:[NSNull class]] && dataDictionary[kCurrentBidUser]){
            self.currentBidUser = dataDictionary[kCurrentBidUser];
        }
        if (![dataDictionary[kCurrentPrice] isKindOfClass:[NSNull class]]){
            self.currentPrice = [dataDictionary[kCurrentPrice] floatValue];
        }
        if (![dataDictionary[kAdDescription] isKindOfClass:[NSNull class]]){
            self.adDescription = dataDictionary[kAdDescription];
        }
        if (![dataDictionary[kAdExpiredOn] isKindOfClass:[NSNull class]]){
            self.expiredOn = dataDictionary[kAdExpiredOn];
            self.expiredOnDate = [self.expiredOn convertToDate];
            self.isExpired = [self isDateExpired:self.expiredOnDate];
        }
        if (![dataDictionary[kFavorite] isKindOfClass:[NSNull class]]){
            NSString *favorite = dataDictionary[kFavorite];
            if ([favorite isEqualToString:@"false"])
                self.isFavorite = NO;
            else
                self.isFavorite = YES;
        }
        if (![dataDictionary[kItemCondition] isKindOfClass:[NSNull class]]){
            self.itemCondition = dataDictionary[kItemCondition];
        }
        if (![dataDictionary[kLocation] isKindOfClass:[NSNull class]]){
            self.location = dataDictionary[kLocation];
        }
        if (![dataDictionary[kMinimumBidAmount] isKindOfClass:[NSNull class]]){
            self.minimumBidAmount = [dataDictionary[kMinimumBidAmount] floatValue];
        }
        if (![dataDictionary[kSlug] isKindOfClass:[NSNull class]]){
            self.slug = dataDictionary[kSlug];
        }
        if(![dataDictionary[kImage_Url] isKindOfClass:[NSNull class]]){
            self.imageUrl = dataDictionary[kImage_Url];
        }
        if (![dataDictionary[kStartsOn] isKindOfClass:[NSNull class]]){
            self.startsOn = dataDictionary[kStartsOn];
            self.startsOnDate = [self.startsOn convertToDate];
        }
        if (![dataDictionary[kStatus] isKindOfClass:[NSNull class]]){
            NSString *status = dataDictionary[kStatus];
            if ([status isEqualToString:@"Active"])
                self.isActive = YES;
            else
                self.isActive = NO;
        }
        if (![dataDictionary[kAuctionType] isKindOfClass:[NSNull class]]){
            self.type = dataDictionary[kAuctionType];
        }
        if (![dataDictionary[kViewCount] isKindOfClass:[NSNull class]]){
            self.viewCount = [dataDictionary[kViewCount] intValue];
        }
    }
    if(![auctionDictionary[kDefaultImage] isKindOfClass:[NSNull class]]){
        self.defaultImageUrl = auctionDictionary[kDefaultImage];
    }
    if(![auctionDictionary[kImageBaseUrl] isKindOfClass:[NSNull class]]){
        self.imageBaseUrl = auctionDictionary[kImageBaseUrl];
    }
    if(![auctionDictionary[kShareUrl] isKindOfClass:[NSNull class]]){
        self.shareUrl = auctionDictionary[kShareUrl];
    }
    if(![auctionDictionary[kImages] isKindOfClass:[NSNull class]]){
        NSArray *imagesArray = auctionDictionary[kImages];
        self.imagesArray = [[NSMutableArray alloc] init];
        for (NSDictionary *item in imagesArray){
            AdImages *adImage = [[AdImages alloc] initWithImageDictionary:item];
            if(![auctionDictionary[kImageBaseUrl] isKindOfClass:[NSNull class]]){
                adImage.imageBaseUrl = auctionDictionary[kImageBaseUrl];
            }
            [self.imagesArray addObject:adImage];
        }
    }
    if(![auctionDictionary[kBidHistory] isKindOfClass:[NSNull class]]){
        NSArray *bidHistoryArray = auctionDictionary[kBidHistory];
        self.bidHistory = [[NSMutableArray alloc] init];
        for (NSDictionary *item in bidHistoryArray){
            BidHistory *bidHistory = [[BidHistory alloc] initWithBidDictionary:item];
            if(![auctionDictionary[kImageBaseUrl] isKindOfClass:[NSNull class]]){
                bidHistory.imageBaseUrl = auctionDictionary[kImageBaseUrl];
            }
            [self.bidHistory addObject:bidHistory];
        }
    }
    return self;
}



-(BOOL) isDateExpired:(NSDate *)compDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [currentDate convertToDate];
    if ([today compare:compDate] == NSOrderedDescending){
        return YES;
    }
    return NO;
}
@end
