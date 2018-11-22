//
//  ImageCollectionViewCell.h
//  BayieMobileApp
//
//  Created by Ajeesh T S on 02/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageItem.h"

@interface ImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ImageItem * imageInfo;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@end
