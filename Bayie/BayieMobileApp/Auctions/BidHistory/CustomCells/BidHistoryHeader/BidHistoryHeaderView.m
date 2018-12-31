//
//  BidHistoryHeaderView.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "Constant.h"
#import "BidHistoryHeaderView.h"

#define LightGrayColor [UIColor colorWithRed:0.60 green:0.64 blue:0.69 alpha:1.0]

@implementation BidHistoryHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialisation];
}

-(void)initialisation{
    [self.viewistoryButton setTitle:NSLocalizedString(@"VIEWHISTORY", @"VIEW HISTORY") forState:UIControlStateNormal];
    self.viewistoryButton.layer.borderColor = LightGrayColor.CGColor;
    self.viewistoryButton.layer.borderWidth = 1;
}

-(void)setBisHistoryResponse:(BidHistoryResponseModel *)bisHistoryResponse{
    self.idLabel.text = [NSString stringWithFormat:@"%d",bisHistoryResponse.auctionId];
    self.productNameLabel.text = bisHistoryResponse.productName;
}

- (IBAction)viewHistoryButtonAction:(UIButton *)sender {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
