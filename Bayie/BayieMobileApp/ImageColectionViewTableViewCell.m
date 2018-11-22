//
//  ImageColectionViewTableViewCell.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 02/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ImageColectionViewTableViewCell.h"
#import "ImageCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation ImageColectionViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    UICollectionViewFlowLayout *flowLayout = (id)self.imageCollectionView.collectionViewLayout;
//    
//    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
//        flowLayout.itemSize = CGSizeMake((self.frame.size.width),240);
//    } else {
//        flowLayout.itemSize = CGSizeMake((self.frame.size.width),240);
//    }
//    
//    [flowLayout invalidateLayout];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self.imageCollectionView.collectionViewLayout invalidateLayout];
////    [self.imageCollectionView reloadData];
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showImages{
    [self.imageCollectionView reloadData];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageDataArray.count > 0){
        return self.imageDataArray.count;
    }else{
        return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *imageCollectionCell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell"
                                                 forIndexPath:indexPath];
    if (self.imageDataArray.count > 0){
        imageCollectionCell.imageInfo = self.imageDataArray[indexPath.row];
        if ([imageCollectionCell.imageInfo.type isEqualToString:@"video"]){
            imageCollectionCell.videoView.hidden = NO;
            
            ImageItem *imageItem = [self.imageDataArray objectAtIndex:indexPath.row];
            [imageCollectionCell.adImageView sd_setImageWithURL:[NSURL URLWithString:imageItem.videoThumbUrl]];
        }
        else{
            imageCollectionCell.videoView.hidden = YES;
            if (imageCollectionCell.imageInfo.imageUrl){
                if (!self.imageBaseUrl){
                    self.imageBaseUrl = @"";
                }
                NSString *URLString = [self.imageBaseUrl stringByAppendingString:imageCollectionCell.imageInfo.imageUrl];
                if (imageCollectionCell.imageInfo.isDefault == true){
                    [imageCollectionCell.adImageView sd_setImageWithURL:[NSURL URLWithString:self.defalutImageUrl]];
                }else{
                    [imageCollectionCell.adImageView sd_setImageWithURL:[NSURL URLWithString:URLString]];
                }
            }else{
                if (self.defalutImageUrl){
                    [imageCollectionCell.adImageView sd_setImageWithURL:[NSURL URLWithString:self.defalutImageUrl]];
                }
            }
        }

    }
    return imageCollectionCell;

}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0,0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
//    return CGSizeMake((self.frame.size.width),240);
    return CGSizeMake(( [UIScreen mainScreen].bounds.size.width),self.frame.size.height);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.imageCollectionView.frame.size.width;
    int currentPage = self.imageCollectionView.contentOffset.x / pageWidth;
    if([self.delegate respondsToSelector:@selector(indexValue:)]) {
        [self.delegate indexValue: currentPage];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *collectionCell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ImageItem *imageItem = [self.imageDataArray objectAtIndex:indexPath.row];
    if ([imageItem.type isEqualToString:@"image"]){
        if([self.delegate respondsToSelector:@selector(indexValue:)]) {
            [self.delegate imageSelected:indexPath.row images:self.imageDataArray andImageView:collectionCell.adImageView];
        }
    }
    else if ([imageItem.type isEqualToString:@"video"]){
        NSString *videoUrlString = [self.imageBaseUrl stringByAppendingString:imageItem.videoUrl];
        if([self.delegate respondsToSelector:@selector(selectedWithVideo:)]) {
            [self.delegate selectedWithVideo:videoUrlString];
        }
    }
}

@end
