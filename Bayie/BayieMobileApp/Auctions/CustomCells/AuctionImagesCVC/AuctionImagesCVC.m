//
//  AuctionImagesCVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "AuctionImagesCVC.h"
@interface AuctionImagesCVC()
@end
@implementation AuctionImagesCVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAdImage:(AdImages *)adImage{
    if ([adImage.type isEqualToString:@"video"]){
        self.videoView.hidden = NO;
        [self.adImagesView  sd_setImageWithURL:[NSURL URLWithString:adImage.videoThumb]];
    }
    else if ([adImage.type isEqualToString:@"image"]){
       self.videoView.hidden = YES;
         NSString *URLString = [adImage.imageBaseUrl stringByAppendingString:adImage.imageUrl];
         [self.adImagesView sd_setImageWithURL:[NSURL URLWithString:URLString]];
    }
    }

@end
