//
//  PostAdCatViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 26/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "PostAdCatViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "Utility.h"
#import "BayieHub.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "PostBAdViewController.h"
#import "SubCategoryViewController.h"
#import "PostAdvertisementViewController.h"
#import <DKImagePickerController/DKImagePickerController-Swift.h>


@interface PostAdCatViewController () <PostBAdViewDelegate>
{
    NSArray *categoryDataArray;
    NSDictionary *categoryDataDict;
    NSString *cat_name;
    NSString *cat_img;
    NSString *cat_id;
    NSString *cat_Imageurl;
    NSString *defaultcat_Imageurl;
    MBProgressHUD *hud;
  DKImagePickerController *pickerController;
  DKImagePickerControllerDefaultUIDelegate *pickerDelegate;
}
@property (nonatomic, strong) NSData *videoData;
@end

@implementation PostAdCatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    //if (self.videoData == nil){
        [self addingActionSheetForPhotoAndVideo];
   // }
  if (pickerController) {
    [pickerController deselectAllAssets];
      //TODO: ------
    pickerDelegate.doneButton.hidden = YES;
  }
}

-(void) addingActionSheetForPhotoAndVideo{
    UIAlertController *alertCntrlr = [UIAlertController alertControllerWithTitle:@"Bayie" message:NSLocalizedString(@"ChooseFileType", @"Choose File Type") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo", @"Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self showImagePicker];
        [pickerDelegate.doneButton.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }];
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Video", @"Video") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self.isFromEditAd){
            if([self checkVideosCount]){
                [self addingAlertControllerForCameraAndGallery];
            }
            else{
                [self addingAlertControllerForVideoLimit];
            }
        }
        else{
            [self addingAlertControllerForCameraAndGallery];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.selectedIndex = 0;
       // if (self.isFromEditAd){
            [self dismissViewControllerAnimated:true completion:nil];
        //}
    }];
    [alertCntrlr addAction:photoAction];
    [alertCntrlr addAction:videoAction];
    [alertCntrlr addAction:cancelAction];
    [self presentViewController:alertCntrlr animated:true completion:nil];
}

-(void)addingAlertControllerForVideoLimit{
    UIAlertController * alert =[UIAlertController
                                alertControllerWithTitle:@"Bayie" message: NSLocalizedString(@"VIDEOLIMIT", @"Maximum video limit reached") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   [self addingActionSheetForPhotoAndVideo];
                                   
                               }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(BOOL)checkVideosCount{
    BOOL isValid = YES;
    if (self.isFromEditAd){
        
    }
    else{
        for (id item  in self.imagesArray){
            if ([item isKindOfClass:[NSURL class]]){
                isValid = NO;
            }
        }
    }
    return  isValid;
}

-(void)addingAlertControllerForCameraAndGallery{
    UIAlertController *alertCntrlr = [UIAlertController alertControllerWithTitle:@"Bayie" message:NSLocalizedString(@"ChooseVideoType", @"Choose Video Type") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", @"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addingVideoViewControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
       
    }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Gallery", @"Gallery") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addingVideoViewControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.selectedIndex = 0;
        //if (self.isFromEditAd){
            [self dismissViewControllerAnimated:true completion:nil];
        //}
    }];
    [alertCntrlr addAction:cameraAction];
    [alertCntrlr addAction:galleryAction];
    [alertCntrlr addAction:cancelAction];
    [self presentViewController:alertCntrlr animated:true completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
    @try{
        [pickerDelegate.doneButton.titleLabel removeObserver:self forKeyPath:@"text"];
    }@catch(id anException){
        NSLog(@"Exception");
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
  
}
//- (BOO L) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (tabBarController.selectedIndex == 2){
//        [self showImagePicker];
//    }
//    return YES;
//}

#pragma mark - Adding Video Controller

-(void)addingVideoViewControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    //videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.sourceType = sourceType;
    [videoPicker setVideoMaximumDuration:60];
    //videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    videoPicker.view.backgroundColor = [UIColor whiteColor];
    // videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    videoPicker.delegate = self;
    [self presentViewController:videoPicker animated:YES completion:nil];
}

#pragma mark - UIImagePicker Controller Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([info objectForKey:UIImagePickerControllerOriginalImage]){
        NSLog(@"Image");
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        self.videoData = videoData;
        [picker dismissViewControllerAnimated:YES completion:^{
            
            UIImage *thumnailImage = [self getThumbNailImageFromVideoUrl:videoURL];
            
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            NSTimeInterval durationInSeconds = 0.0;
            if (asset){
                durationInSeconds = CMTimeGetSeconds(asset.duration);
                if (durationInSeconds>=61) {
                    [self addingAlertControllerForTimeLimit];
                }
                else{
                    if (self.isFromEditAd || self.isFromMore) {
                        [pickerController removeFromParentViewController];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        if(self.postAdCatCnlrDel && [self.postAdCatCnlrDel respondsToSelector:@selector(postAdCatDelegateWithVideoData:thumbNailImage:withVideoUrl:)]){
                            [self.postAdCatCnlrDel postAdCatDelegateWithVideoData:videoData thumbNailImage:thumnailImage withVideoUrl:videoURL];
                        }
                    }
                    else{
                        PostBAdViewController *postAdViewController = [[PostBAdViewController alloc]initWithNibName:@"PostBAdViewController" bundle:nil];
                        postAdViewController.postAdDelegate = self;
                        postAdViewController.isVideoType = true;
                        postAdViewController.videoData = videoData;
                        postAdViewController.thumbNailImage = thumnailImage;
                        postAdViewController.localVideoUrl = videoURL;
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAdViewController];
                        [self presentViewController:nav animated:true completion:nil];
                    }
                }
            }
            
            //[self uploadVideoWithData:videoData];
           
        }];
    }
}



-(void)addingAlertControllerForTimeLimit{
    UIAlertController * alert =[UIAlertController
                                alertControllerWithTitle:@"Bayie" message: @"Maximum video duration is 60 seconds" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   [self addingAlertControllerForCameraAndGallery];
                                   
                               }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}



-(UIImage *)getThumbNailImageFromVideoUrl:(NSURL *)videoUrl{
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    
    return image;
}


-(void)showImagePicker{

    pickerController = [[DKImagePickerController alloc] init];
    pickerController.navigationBar .barTintColor = AppCommonBlueColor;
    pickerController.assetType = DKImagePickerControllerAssetTypeAllAssets;
    pickerController.showsCancelButton = YES;
    pickerController.showsEmptyAlbums = YES;
    pickerController.allowMultipleTypes = YES;
    //    if (self.assets.count > 0){
    //        pickerController.defaultSelectedAssets = self.assets;
    //    }else{
    pickerController.defaultSelectedAssets = @[];
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [doneButton setTitle:NSLocalizedString(@"SELECT", @"") forState:UIControlStateNormal];
  [doneButton setTitleColor:AppCommonWhiteColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:LatoRegular size:14];
  [doneButton addTarget:self action:@selector(showAdView) forControlEvents:UIControlEventTouchUpInside];
//  pickerController.doneButton = doneButton;
    //    }
    int imagesCount = 0;
    if (!self.isFromEditAd){
        for (id item  in self.imagesArray){
            if ([item isKindOfClass:[DKAsset class]]){
                imagesCount = imagesCount+1;
            }
        }
    }
    else{
        for (id item  in self.imagesArray){
            if ([item isKindOfClass:[DKAsset class]]){
                imagesCount = imagesCount+1;
            }
            else if ([item isKindOfClass:[NSDictionary class]]){
                if ([[item valueForKey:@"type"] isEqualToString:@"image"]){
                   imagesCount = imagesCount+1;
                }
            }
        }
    }
    pickerController.maxSelectableCount = 6-imagesCount;
    pickerController.sourceType = DKImagePickerControllerSourceTypeBoth;
    //  pickerController.assetGroupTypes    // unavailable
    //  pickerController.defaultAssetGroup  // unavailable
//    pickerController.delegate = self;
    
    pickerController.showsCancelButton = NO;
    __weak UIViewController *weakself = self;
    [pickerController setDidSelectAssets:^(NSArray * __nonnull assetsDetails) {
        NSLog(@"didSelectAssets");
        if (assetsDetails){
            if (assetsDetails.count > 0){
                //                self.addImageButton.hidden = true;
                //                self.assets = assetsDetails;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdCategory" bundle:[NSBundle mainBundle]];
                PostAdvertisementViewController *postAdViewController = [storyboard instantiateViewControllerWithIdentifier:@"PostAddVC"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAdViewController];
                postAdViewController.assets = [assetsDetails mutableCopy];
                [weakself presentViewController:nav animated:true completion:nil];
            }else{
                
            }
        }
    }];
  pickerDelegate = pickerController.UIDelegate;

  pickerDelegate.doneButton = doneButton;
  [self addChildViewController:pickerController];
  [self.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
  [self.view addSubview:pickerController.view];
  [pickerController didMoveToParentViewController:self];
//    [self presentViewController:pickerController animated:YES completion:nil];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  
  if ([keyPath isEqualToString:@"text"]) {
    if (pickerDelegate.imagePickerController.selectedAssets.count > 0){
      pickerDelegate.doneButton.hidden = NO;
    }
    else {
      pickerDelegate.doneButton.hidden = YES;
    }
  }
  
  
  
}
- (void) showAdView {
    if(self.isFromEditAd){
        [pickerController removeFromParentViewController];
        [self dismissViewControllerAnimated:YES completion:nil];
        if(self.postAdCatCnlrDel && [self.postAdCatCnlrDel respondsToSelector:@selector(postAdCatDelegateWithImageAssetsArray:)]){
            [self.postAdCatCnlrDel postAdCatDelegateWithImageAssetsArray:pickerDelegate.imagePickerController.selectedAssets];
        }
    }
    else{
        
        if (pickerDelegate.imagePickerController.selectedAssets.count > 0){
            //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdCategory" bundle:[NSBundle mainBundle]];
            //    PostAdvertisementViewController *postAdViewController = [storyboard instantiateViewControllerWithIdentifier:@"PostAddVC"];
            //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAdViewController];
            //    postAdViewController.assets = pickerDelegate.imagePickerController.selectedAssets;
            //    [self presentViewController:nav animated:true completion:nil];
            
            if (self.imagesArray.count >0){
                [pickerController removeFromParentViewController];
                [self dismissViewControllerAnimated:YES completion:nil];
                if(self.postAdCatCnlrDel && [self.postAdCatCnlrDel respondsToSelector:@selector(postAdCatDelegateWithImageAssetsArray:)]){
                    [self.postAdCatCnlrDel postAdCatDelegateWithImageAssetsArray:pickerDelegate.imagePickerController.selectedAssets];
                }
            }
            else{
                PostBAdViewController *postAdViewController = [[PostBAdViewController alloc]initWithNibName:@"PostBAdViewController" bundle:nil];
                postAdViewController.postAdDelegate = self;
                postAdViewController.imageAssets = pickerDelegate.imagePickerController.selectedAssets;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAdViewController];
                [self presentViewController:nav animated:true completion:nil];
            }
        }
    }
    
}


- (void)imagePickerController:(DKImagePickerController * _Nonnull)imagePickerController didSelectAssets:(NSArray<DKAsset *> * _Nonnull)didSelectAssets {
  NSLog(@"didSelectAssets");

}


- (void) gotBayieAPIData:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
        NSDictionary *responseDict = notification.object;
        NSLog(@"%@", responseDict);
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            categoryDataArray = responseDict[@"data"];
            cat_Imageurl = responseDict[@"baseUrl"];
            defaultcat_Imageurl = responseDict[@"mob_defaultImage"];
            NSLog(@"%@", categoryDataArray);
        }   else if (![errormsg isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
        }
        [self.postAdTableView reloadData];
        [hud hideAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)categoryList{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSError *error;
    NSString *jsonString = @"{\"language\":\"English\"}";
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"category"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return categoryDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PostAdCell";
    
    CustomPostAdTableViewCell *postAdcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    categoryDataDict = [categoryDataArray objectAtIndex:indexPath.row];
    
    NSString *url_CatImg = [categoryDataDict valueForKey:@"mobile_icon"];
    
    NSLog(@"%@", url_CatImg);
    NSString *url_CatImg_FULL;
    if(url_CatImg == (id)[NSNull null]){
        url_CatImg_FULL = defaultcat_Imageurl;
    }else{
        url_CatImg_FULL = [cat_Imageurl stringByAppendingPathComponent:url_CatImg];
    }
    //    if([[categoryDataDict valueForKey:@"category_name"] isEqualToString:@"sample 2"]){
    //
    //
    //        NSLog(@"%@", [categoryDataDict valueForKey:@"mobile_icon"]);
    //    }
    
    
    
    postAdcell.postAdLabel.text = [categoryDataDict valueForKey:@"category_name"];
    postAdcell.postAdImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_CatImg_FULL]]];
    
    return postAdcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    NSDictionary *dataDic = [categoryDataArray objectAtIndex:indexPath.row];
    cat_name = [dataDic valueForKey:@"category_name"];
    cat_id = [dataDic valueForKey:@"id"];
    NSString *url_Img = [dataDic valueForKey:@"mobile_icon"];
    NSString *url_Img_FULL;
    if(url_Img == nil){
        url_Img_FULL = defaultcat_Imageurl;
    }else{
        url_Img_FULL = [cat_Imageurl stringByAppendingPathComponent:url_Img];
    }
    cat_img = url_Img_FULL;
//    [self performSegueWithIdentifier:@"SubCat" sender:self];
     */
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SubCat"]) {
        SubCategoryViewController *destvc= (SubCategoryViewController *)segue.destinationViewController;
        destvc.catImageurl = cat_img;
        destvc.categoryTitle = cat_name;
        destvc.catID = cat_id;
        
        //        UINavigationController *nav = segue.destinationViewController;
        //       SubCategoryViewController *destvc = (SubCategoryViewController *)nav.topViewController;
        //        destvc.catImageurl = cat_img;
        //        destvc.categoryTitle = cat_name;
        //        destvc.catID = cat_id;
        
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [hud hideAnimated:YES];
}

#pragma mark - PostAd ViewController Delegate
- (void)postBAdViewControllerItem:(PostBAdViewController *) viewController clickedBackButton:(id)sender{
    self.tabBarController.selectedIndex = 0;
}
@end
