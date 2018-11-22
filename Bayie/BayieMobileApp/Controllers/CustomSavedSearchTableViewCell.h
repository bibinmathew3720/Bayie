//
//  CustomSavedSearchTableViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSavedSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;


@end
