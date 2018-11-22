//
//  BCollectionViewCell.h
//  BayieMobileApp
//
//  Created by Apple on 02/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DKImagePickerController/DKImagePickerController-Swift.h>
@protocol BCollectionViewCellDelegate;
@interface BCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) DKAsset *asset ;

@property (nonatomic, strong) id imageDetails;
@property (nonatomic, strong) NSString *imageBaseUrl;
@property (nonatomic, strong) NSString *defaultImageUrl;
@property (nonatomic, assign) id <BCollectionViewCellDelegate>cellDelegate;
@end
@protocol BCollectionViewCellDelegate <NSObject>

-(void)addMoreButtonActionDelegateWithTag:(NSUInteger)cellTag;
-(void)removeButtonActionDelegateWithTag:(NSUInteger)cellTag;
-(void)selectedVideoWithTag:(NSUInteger)cellTag;
@end
