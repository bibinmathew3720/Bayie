//
//  BidHistoryCell.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/31/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "BidHistoryCell.h"

@implementation BidHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBidHistory:(BidHistory *)bidHistory{
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f OMR",bidHistory.bid_amount];
    self.dateAndTimeLabel.text = bidHistory.bid_time;
}

@end
