

//
//  SellerDetailTableViewCell.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 04/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SellerDetailTableViewCell.h"

@implementation SellerDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusView.layer.cornerRadius = 4.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
