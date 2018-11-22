//
//  PostAdCatViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 26/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPostAdTableViewCell.h"

@protocol PostAdCatViewControllerDelegate;
@interface PostAdCatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *postAdTableView;

@property (nonatomic, assign) BOOL isFromEditAd;
@property (nonatomic, assign) BOOL isFromMore;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) id <PostAdCatViewControllerDelegate>postAdCatCnlrDel;
@end
@protocol PostAdCatViewControllerDelegate <NSObject>

-(void)postAdCatDelegateWithImageAssetsArray:(NSArray *)imageAssetsArray;
-(void)postAdCatDelegateWithVideoData:(NSData *)videoData thumbNailImage:(UIImage *)thumbNailImage withVideoUrl:(NSURL *)videoUrl;

@end
