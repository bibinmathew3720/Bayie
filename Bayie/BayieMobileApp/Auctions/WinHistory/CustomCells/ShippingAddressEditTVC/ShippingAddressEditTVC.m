//
//  ShippingAddressEditTVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 1/3/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import "ShippingAddressEditTVC.h"

@interface ShippingAddressEditTVC()<UITextViewDelegate>
@property (nonatomic, strong) WinHistoryResponseModel *currentModel;
@end
@implementation ShippingAddressEditTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self localisation];
    [self initialisation];
    // Initialization code
}

-(void)localisation{
    self.shippingAddressHeadingLabel.text = NSLocalizedString(@"ShippingAddress", @"Shipping Address");
    self.shippingLocationHeadingLabel.text = NSLocalizedString(@"ShippingLocation", @"Shipping Location");
    self.shippingZipCodeLabel.text = NSLocalizedString(@"ShippingZipcode", @"Shipping Zipcode");
    [self.saveButton setTitle:NSLocalizedString(@"SAVE", @"SAVE") forState:UIControlStateNormal];
     [self.closeButton setTitle:NSLocalizedString(@"CLOSE", @"CLOSE") forState:UIControlStateNormal];
}

-(void)initialisation{
    self.shippingAddressTV.delegate = self;
    self.shippingLocationTV.delegate = self;
    self.shippingZipCodeTV.delegate = self;
    [self settingBorderToView:self.shippingAddressView];
    [self settingBorderToView:self.shippingLocationView];
    [self settingBorderToView:self.shippingZipCodeView];
    [self settingBorderToView:self.saveButton];
    [self settingBorderToView:self.closeButton];
}

-(void)settingBorderToView:(UIView *)view{
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:0.4] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWinHistoryModel:(WinHistoryResponseModel *)winHistoryModel{
    self.currentModel = winHistoryModel;
    self.shippingAddressTV.text = winHistoryModel.shippingAddress;
    self.shippingLocationTV.text = winHistoryModel.shippingCity;
    self.shippingZipCodeTV.text = winHistoryModel.shippingZipCode;
}
- (IBAction)saveButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveBUttonActionDelegateWithTag:andWinHistoryModel:)]){
        [self.delegate saveBUttonActionDelegateWithTag:self.tag andWinHistoryModel:self.currentModel];
    }
}
- (IBAction)closeButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonActionDelegateWithTag:)]){
        [self.delegate closeButtonActionDelegateWithTag:self.tag];
    }
}

#pragma mark - TextView Delegates

-(void)textViewDidChange:(UITextView *)textView{
    if (textView == self.shippingAddressTV){
        self.currentModel.shippingAddress = textView.text;
    }
    else if (textView == self.shippingLocationTV){
        self.currentModel.shippingCity = textView.text;
    }
    else if (textView == self.shippingZipCodeTV){
        self.currentModel.shippingZipCode = textView.text;
    }
}

@end
