//
//  BidHistoryTVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "BidHistoryTVC.h"

@implementation BidHistoryTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBidHistory:(BidHistory *)bidHistory{
    self.nameLabel.text = bidHistory.bidBy;
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f OMR",bidHistory.bid_amount];
}

@end
