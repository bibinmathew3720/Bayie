//
//  PostAdvertisementViewController.h
//  BayieMobileApp
//
//  Created by Ajeesh T S on 19/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostAdvertisementViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UIWebView *propertiesWebview;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (nonatomic, strong) NSArray * imageDataArray;
@property (nonatomic, strong) NSString *imageBaseUrl;
@property (nonatomic, strong) NSMutableArray *assets;
@end
