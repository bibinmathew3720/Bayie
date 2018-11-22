//
//  PostAdViewController.h
//  BayieMobileApp
//
//  Created by Apple on 02/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostBAdViewDelegate;

@interface PostBAdViewController : UIViewController

@property (nonatomic, strong) NSArray *imageAssets;
@property (nonatomic,strong) id<PostBAdViewDelegate>postAdDelegate;
@property (nonatomic, assign) BOOL isVideoType;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, strong) UIImage *thumbNailImage;
@property (nonatomic, strong) NSURL *localVideoUrl;
@property (nonatomic, strong) NSString *videoUrl;

//From Ad Edit

@property (nonatomic, strong) NSString *adId;
@property (nonatomic, assign) BOOL isFromEditAd;


@end

@protocol PostBAdViewDelegate <NSObject>

- (void)postBAdViewControllerItem:(PostBAdViewController *) viewController clickedBackButton:(id)sender;

@end
