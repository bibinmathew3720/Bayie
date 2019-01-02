//
//  AuctionImagesCVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdImages.h"

@interface AuctionImagesCVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *adImagesView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (nonatomic, strong) AdImages *adImage;
@end
