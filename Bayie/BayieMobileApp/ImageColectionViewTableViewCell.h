//
//  ImageColectionViewTableViewCell.h
//  BayieMobileApp
//
//  Created by Ajeesh T S on 02/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagesCollectionDelegte <NSObject>
@optional
- (void)indexValue:(int)index;
-(void)imageSelected:(NSInteger)index images:(NSArray*)imageURLs andImageView:(UIImageView *)imageView;
-(void)selectedWithVideo:(NSString *)videoUrlString;
@end

@interface ImageColectionViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic, weak) id <ImagesCollectionDelegte> delegate;
@property (nonatomic, strong) NSArray * imageDataArray;
@property (nonatomic, strong) NSString *imageBaseUrl;
@property (nonatomic, strong) NSString *defalutImageUrl;


-(void)showImages;
@end
