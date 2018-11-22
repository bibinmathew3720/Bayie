//
//  FilterRightTVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "FilterRightTVC.h"

@implementation FilterRightTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRightData:(id)rightData
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[rightData valueForKey:@"category_name"]];
}

-(void)setLocationData:(id)locationData{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[locationData valueForKey:@"location"]];
}

@end
