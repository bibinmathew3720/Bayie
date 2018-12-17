//
//  CustomCategoryCollectionViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 29/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface CustomCategoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (nonatomic, strong) Auction *auct;
@end
