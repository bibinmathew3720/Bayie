//
//  BidHistoryHeaderView.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidHistoryResponseModel.h"
@protocol BidHistoryHeaderViewDelegate;
@interface BidHistoryHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewistoryButton;
@property (nonatomic, strong) BidHistoryResponseModel *bisHistoryResponse;

@property (nonatomic, assign) id <BidHistoryHeaderViewDelegate>bidHistoryHeaderDelegate;
@end
@protocol BidHistoryHeaderViewDelegate<NSObject>
-(void)viewHistoryButtonActionDelegateWithTag:(NSInteger)tag;
@end
