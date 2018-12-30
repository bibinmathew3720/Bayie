//
//  BidHistoryTVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidHistory.h"

@interface BidHistoryTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) BidHistory *bidHistory;
@end
