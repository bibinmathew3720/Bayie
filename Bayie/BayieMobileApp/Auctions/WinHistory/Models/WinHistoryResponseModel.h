//
//  WinHistoryResponseModel.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/31/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinHistoryResponseModel : NSObject
@property (nonatomic, assign) int auctionId;
@property (nonatomic, assign) int productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *shippingAddress;
@property (nonatomic, strong) NSString *shippingCity;
@property (nonatomic, strong) NSString *shippingZipCode;
@property (nonatomic, strong) NSString *shippingStatus;
-(id)initWithWinHistoryResponse:(NSDictionary *)dataDictionary;
@end
