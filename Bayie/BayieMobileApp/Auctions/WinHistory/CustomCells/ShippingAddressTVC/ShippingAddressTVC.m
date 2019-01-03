//
//  ShippingAddressTVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 1/3/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import "ShippingAddressTVC.h"

@implementation ShippingAddressTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self localisation];
    [self initialisation];
    // Initialization code
}

-(void)localisation{
    self.statusHeadingLabel.text = NSLocalizedString(@"Status", @"Status");
    self.shippingAddressHeadingLabel.text = NSLocalizedString(@"ShippingAddress", @"Shipping Address");
    self.shippingLocationHeadingLabel.text = NSLocalizedString(@"ShippingLocation", @"Shipping Location");
    self.shippingZipCodeHeadingLabel.text = NSLocalizedString(@"ShippingZipcode", @"Shipping Zipcode");
    [self.editButton setTitle:NSLocalizedString(@"EDIT", @"EDIT") forState:UIControlStateNormal];
}

-(void)initialisation{
    self.editButton.layer.borderWidth = 0.5;
    self.editButton.layer.borderColor = [[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:0.4] CGColor];
}

-(void)setWinHistoryModel:(WinHistoryResponseModel *)winHistoryModel{
    self.statusLabel.text = winHistoryModel.shippingStatus;
    self.shippingAddressLabel.text = winHistoryModel.shippingAddress;
    self.shippingLocationLabel.text = winHistoryModel.shippingCity;
    self.shippingZipCodeLabel.text = winHistoryModel.shippingZipCode;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editButtonAction:(UIButton *)sender {
    if (self.shippingAddressTVCDelegate && [self.shippingAddressTVCDelegate respondsToSelector:@selector(editButtonActionWithTag:)]){
        [self.shippingAddressTVCDelegate editButtonActionWithTag:self.tag];
    }
}

@end
