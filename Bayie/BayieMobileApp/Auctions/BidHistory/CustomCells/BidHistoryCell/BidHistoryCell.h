//
//  BidHistoryCell.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/31/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidHistory.h"

@interface BidHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (nonatomic, strong) BidHistory *bidHistory;
@end
