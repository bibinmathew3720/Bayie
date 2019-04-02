//
//  AuctionDetailVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/27/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AuctionDetailVCDelegate;
@interface AuctionDetailVC : UIViewController
@property(nonatomic,strong) NSString *adId;
@property(nonatomic, assign) BOOL isFromNotification;
@property (nonatomic, assign) id <AuctionDetailVCDelegate>auctionDetailDelegate;
@end
@protocol AuctionDetailVCDelegate <NSObject>
-(void)bidDetailsModifiedDelegate;
@end
