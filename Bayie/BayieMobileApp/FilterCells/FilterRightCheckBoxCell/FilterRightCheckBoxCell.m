//
//  FilterRightCheckBoxCell.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "FilterRightCheckBoxCell.h"

@implementation FilterRightCheckBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCheckData:(id)checkData{
    self.headingLabel.text = [NSString stringWithFormat:@"%@",checkData];
}

@end
