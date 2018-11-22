//
//  FilterRightCheckBoxCell.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterRightCheckBoxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (nonatomic, strong) id checkData;
@end
