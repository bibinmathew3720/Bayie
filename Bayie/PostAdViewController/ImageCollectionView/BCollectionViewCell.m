//
//  BCollectionViewCell.m
//  BayieMobileApp
//
//  Created by Apple on 02/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "BCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface BCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, strong) NSString *currentDefaultImageUrl;
@property (nonatomic, strong) NSString *currentImageBaseUrl;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewheightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *addMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *removeLabel;

@end
@implementation BCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self localisation];
    // Initialization code
}

-(void)localisation{
    self.addMoreLabel.text = NSLocalizedString(@"AddMore", @"Add More");
    self.removeLabel.text = NSLocalizedString(@"Remove", @"Remove");
}

- (void)setAsset:(DKAsset *)asset {
    [asset fetchOriginalImage:true completeBlock:^(UIImage * image, NSDictionary * dict) {
        self.collectionImageView.image = image;
    }];
    //self.bottomViewheightConstraint.constant = 0;
    //self.bottomView.hidden = YES;
}

-(void)setImageDetails:(id)imageDetails
{
    self.playButton.hidden = YES;
    self.collectionImageView.hidden = NO;
    if([imageDetails isKindOfClass:[NSDictionary class]]){
        if ([[imageDetails valueForKey:@"type"] isEqualToString:@"video"]){
            self.collectionImageView.hidden = YES;
            self.playButton.hidden = NO;
             NSString *thumbUrlString = [NSString stringWithFormat:@"%@",[imageDetails valueForKey:@"video_thumb"]];
             [self.collectionImageView sd_setImageWithURL:thumbUrlString placeholderImage:[UIImage imageNamed:@""]];
        }
        else{
            NSString *imageUrlString = [NSString stringWithFormat:@"%@",[imageDetails valueForKey:@"image_url"]];
            NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
            [self.collectionImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
        }
            
    }
    else if([imageDetails isKindOfClass:[UIImage class]]){
        self.collectionImageView.image = imageDetails;
    }
    else if ([imageDetails isKindOfClass:[NSString class]]){
        NSString *imageUrlString = [NSString stringWithFormat:@"%@%@",self.currentImageBaseUrl,imageDetails];
        NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
        [self.collectionImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
    }
    else if ([imageDetails isKindOfClass:[DKAsset class]]){
        DKAsset *asset = (DKAsset *)imageDetails;
        [asset fetchOriginalImage:true completeBlock:^(UIImage * image, NSDictionary * dict) {
            self.collectionImageView.image = image;
        }];
    }
    else if ([imageDetails isKindOfClass:[NSURL class]]){
        NSData *videoData = [NSData dataWithContentsOfURL:imageDetails];
        UIImage *thumnailImage = [self getThumbNailImageFromVideoUrl:imageDetails];
        _collectionImageView.image = thumnailImage;
        self.playButton.hidden = NO;
    }
}

-(void)setDefaultImageUrl:(NSString *)defaultImageUrl{
    self.currentDefaultImageUrl = defaultImageUrl;
}

-(void)setImageBaseUrl:(NSString *)imageBaseUrl{
    self.currentImageBaseUrl = imageBaseUrl;
}

#pragma mark - Button Actions

- (IBAction)removeButtonAction:(UIButton *)sender {
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(removeButtonActionDelegateWithTag:)]){
        [self.cellDelegate removeButtonActionDelegateWithTag:self.tag];
    }
}

- (IBAction)addMoreButtonAction:(UIButton *)sender {
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(addMoreButtonActionDelegateWithTag:)]){
        [self.cellDelegate addMoreButtonActionDelegateWithTag:self.tag];
    }
}

-(UIImage *)getThumbNailImageFromVideoUrl:(NSURL *)videoUrl{
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    
    return image;
}
- (IBAction)playbuttonAction:(UIButton *)sender {
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(selectedVideoWithTag:)]){
        [self.cellDelegate selectedVideoWithTag:self.tag];
    }
}

@end
