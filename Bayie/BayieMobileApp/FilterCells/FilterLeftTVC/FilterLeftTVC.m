//
//  FilterLeftTVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "FilterLeftTVC.h"

@implementation FilterLeftTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLeftData:(id)leftData{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[leftData valueForKey:@"attribute_name"]];
}

@end
