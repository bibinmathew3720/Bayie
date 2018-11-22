//
//  ListingCollectionCell.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 2/25/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "ListingCollectionCell.h"

@implementation ListingCollectionCell
-(void)setCategoryItem:(id)categoryItem{
  
    
}

-(void)awakeFromNib{
    //self.layer.masksToBounds
    [super awakeFromNib];
    
    
  
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.bottomView.frame.size.height - 1, self.bottomView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.5].CGColor ;
    [self.bottomView.layer addSublayer:bottomBorder];
    
    //Right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.bottomView.frame.size.width - 1, 0, 1, self.bottomView.frame.size.height);
    rightBorder.backgroundColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.3].CGColor ;
    [self.bottomView.layer addSublayer:rightBorder];
    
    //Left border
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 1, self.bottomView.frame.size.height);
    leftBorder.backgroundColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.1].CGColor ;
    [self.bottomView.layer addSublayer:leftBorder];
   
}
@end
