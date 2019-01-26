//
//  AuctionListingCVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 1/1/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import "Auction.h"

#import "AuctionListingCVC.h"

@implementation AuctionListingCVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialisation];
    // Initialization code
}

-(void)initialisation {
    [self.bidNowButton setTitle:NSLocalizedString(@"BIDNOW", @"BID NOW") forState:UIControlStateNormal];
}

-(void)setAuctionDetails:(id)auctionDetails{
    Auction *auction = [[Auction alloc] initWithAuctionDictionary:[NSDictionary dictionaryWithObject:auctionDetails forKey:@"data"]];
    
    if (auction.isExpired ){
        NSString *timeString = NSLocalizedString(@"Expired", @"Expired");
        [self.timerButton setTitle:timeString forState:UIControlStateNormal];
        self.bidNowButton.hidden = YES;
    }
    else{
       [self.timerButton setTitle:auction.expiredOn forState:UIControlStateNormal];
    }
   
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.bottomView.frame.size.height - 1, self.bottomView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.5].CGColor ;
    [self.bottomView.layer addSublayer:bottomBorder];
    
    //Right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.bottomView.frame.size.width - 1, 0, 1, self.bottomView.frame.size.height);
    rightBorder.backgroundColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.3].CGColor ;
    [self.bottomView.layer addSublayer:rightBorder];
    
    //Left border
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 1, self.bottomView.frame.size.height);
    leftBorder.backgroundColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.1].CGColor ;
    [self.bottomView.layer addSublayer:leftBorder];
    
}

@end
