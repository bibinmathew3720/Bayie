//
//  VideoVC.m
//  Estisharat
//
//  Created by Bibin Mathew on 2/11/18.
//  Copyright © 2018 Vk. All rights reserved.
//

#import "VideoVC.h"
@import AVFoundation;
@import AVKit;

@interface VideoVC ()
{
    AVPlayerViewController *playerViewController;
}

@end

@implementation VideoVC

-(void)viewDidLoad{
    [self initialisation];
    playerViewController = [[AVPlayerViewController alloc] init];
    [self playVideo:self.videoUrl];
}
-(void)initialisation{
    self.title = @"Video";
    self.navigationController.navigationBar.hidden = NO;
    [self addingBackArrow];
}

-(void)addingBackArrow{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrowArabicWhite"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }else{
        UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow-white"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)rightButtonAction:(UIButton *)button{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Button Action

-(void)leftButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playVideo : (NSString *)videoURL{
    NSURL *url = [NSURL URLWithString:videoURL];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL: url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
    playerViewController.player = player;
    [playerViewController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    
    playerViewController.showsPlaybackControls = YES;
    
    [self.view addSubview:playerViewController.view];
    
    [player play];
}

@end
