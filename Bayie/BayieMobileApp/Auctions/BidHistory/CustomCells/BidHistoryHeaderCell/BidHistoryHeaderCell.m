//
//  BidHistoryHeaderCell.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/31/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "BidHistoryHeaderCell.h"

@implementation BidHistoryHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialisation];
    // Initialization code
}

-(void)initialisation{
    self.amountHeadingLabel.text = NSLocalizedString(@"Amount", @"Amount");
    self.timeHeadingLabel.text = NSLocalizedString(@"DateAndTime", @"Date and Time");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
