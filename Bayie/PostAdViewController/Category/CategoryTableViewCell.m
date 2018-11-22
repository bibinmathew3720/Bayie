//
//  CategoryTableViewCell.m
//  BayieMobileApp
//
//  Created by Apple on 03/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "CategoryTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface CategoryTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategory:(id)category {
    self.categoryLabel.text = [category valueForKey:@"category_name"];
    [self.categoryImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.baseUrl,[category valueForKey:@"mobile_icon"] ]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!image) {
            self.imageViewWidthConstraint.constant = 0;
            self.imageViewHeightConstraint.constant = 0;
        }
    }];
}

- (void)setLocationDetails:(id)locationDetails {
    self.imageViewWidthConstraint.constant = 0;
    self.imageViewHeightConstraint.constant = 0;
    self.categoryLabel.text = [locationDetails valueForKey:@"location"];
}

@end
