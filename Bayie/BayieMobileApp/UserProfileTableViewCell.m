


//
//  UserProfileTableViewCell.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 01/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "UserProfileTableViewCell.h"

@implementation UserProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _profileImageView.layer.cornerRadius = 50;
    _profileImageView.clipsToBounds = true;
    // Initialization code
}

- (void) drawRect:(CGRect)rect {
	[super drawRect:rect];
//	self.separatorInset =   UIEdgeInsetsMake(0.f, rect.size.width, 0.f, 0.f);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
