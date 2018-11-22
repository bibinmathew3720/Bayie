//
//  FilterLeftTVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterLeftTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) id leftData;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowIMageView;
@end
