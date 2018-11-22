//
//  CustomMyAdsTableViewCell.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "CustomMyAdsTableViewCell.h"
#import "MyChatsViewController.h"
#import "AppDelegate.h"

#import "PostBAdViewController.h"

@implementation CustomMyAdsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.chatButton.layer setBorderWidth:1.0];
    [self.chatButton.layer setBorderColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor];
    [self.editButton.layer setBorderWidth:1.0];
    [self.editButton.layer setBorderColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor];
    [self.deleteButton.layer setBorderWidth:1.0];
    [self.deleteButton.layer setBorderColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



@end
