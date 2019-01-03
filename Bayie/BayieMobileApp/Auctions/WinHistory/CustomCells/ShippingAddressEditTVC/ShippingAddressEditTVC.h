//
//  ShippingAddressEditTVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 1/3/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinHistoryResponseModel.h"
@protocol ShippingAddressEditTVCDelegate;
@interface ShippingAddressEditTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressHeadingLabel;
@property (weak, nonatomic) IBOutlet UIView *shippingAddressView;
@property (weak, nonatomic) IBOutlet UITextView *shippingAddressTV;
@property (weak, nonatomic) IBOutlet UILabel *shippingLocationHeadingLabel;
@property (weak, nonatomic) IBOutlet UIView *shippingLocationView;
@property (weak, nonatomic) IBOutlet UITextView *shippingLocationTV;
@property (weak, nonatomic) IBOutlet UILabel *shippingZipCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *shippingZipCodeView;
@property (weak, nonatomic) IBOutlet UITextView *shippingZipCodeTV;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) WinHistoryResponseModel *winHistoryModel;
@property (nonatomic, assign) id <ShippingAddressEditTVCDelegate>delegate;
@end

@protocol ShippingAddressEditTVCDelegate <NSObject>
-(void)closeButtonActionDelegateWithTag:(NSInteger)tag;
-(void)saveBUttonActionDelegateWithTag:(NSInteger)tag andWinHistoryModel:(WinHistoryResponseModel *)model;
@end
