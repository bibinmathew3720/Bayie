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
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;
@end
