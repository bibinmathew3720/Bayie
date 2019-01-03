//
//  ShippingAddressTVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 1/3/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinHistoryResponseModel.h"
@protocol ShippingAddressTVCDelegate;
@interface ShippingAddressTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLocationHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingZipCodeHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingZipCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, strong) WinHistoryResponseModel *winHistoryModel;
@property (nonatomic, assign) id <ShippingAddressTVCDelegate>shippingAddressTVCDelegate;
@end
@protocol ShippingAddressTVCDelegate <NSObject>
-(void)editButtonActionWithTag:(NSInteger)tag;
@end
