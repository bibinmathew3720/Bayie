


//
//  PostAdvertisementViewController.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 19/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "PostAdvertisementViewController.h"

#import "BayieHub.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "ImageCollectionViewCell.h"
#import <DKImagePickerController/DKImagePickerController-Swift.h>

@interface PostAdvertisementViewController ()<UIWebViewDelegate>{
    //    [DKAsset] *assets;
    NSMutableArray *uploadedUrlArray;
    NSUInteger uploadImageCount;
    NSUInteger uploadIndex;
    BOOL isNeedTocallJavaMethod;
    MBProgressHUD *hud;
}

@end

@implementation PostAdvertisementViewController

- (void)viewDidLoad {
    self.title = @"POST AD";
    [super viewDidLoad];
    isNeedTocallJavaMethod = false;
    self.addImageButton.hidden = true;
    self.propertiesWebview.delegate = self;
    [self navigationCustomization];
    [self loadWbeView];
//    self.assets = [[NSMutableArray alloc] init];
    uploadedUrlArray = [[NSMutableArray alloc] init];
    if (_assets.count > 0){
        [self uploadImage];
    }

    // Do any additional setup after loading the view.
}

-(void)navigationCustomization{
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                            imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = myBackButton;
}

- (void)backBtnClicked{
    [self dismissViewControllerAnimated:true completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadWbeView{
    DataClass *dataObj1=[DataClass getInstance];

    NSString *url = [PostAdWebViewUrlEnglish stringByAppendingString:@"9"];
    if (dataObj1.userId){
        url = [PostAdWebViewUrlEnglish stringByAppendingString:dataObj1.userId];
    }
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self addHudToWebview];
    [self.propertiesWebview loadRequest:request];
    //    updateAdImages(imageArray,userToken)
}

-(void)addHudToWebview{
    hud = [MBProgressHUD showHUDAddedTo:self.propertiesWebview animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    hud.removeFromSuperViewOnHide = true;
   }
-(void)showHideHud: (BOOL) isHide{
    [hud hideAnimated:isHide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showImages{
    [self.imageCollectionView reloadData];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.assets.count > 0){
        return self.assets.count;
    }else{
        return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *imageCollectionCell = [collectionView
                                                    dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell"
                                                    forIndexPath:indexPath];
    if (self.assets.count > 0){
        DKAsset *imageDetials = [self.assets objectAtIndex:indexPath.row];
        [imageDetials fetchOriginalImage:false completeBlock:^(UIImage * image, NSDictionary * dict) {
            imageCollectionCell.adImageView.image = image;
        }];
        //        imageCollectionCell.adImageView = [imageDetials ]
        //        imageCollectionCell.imageInfo = self.imageDataArray[indexPath.row];
        //        if (imageCollectionCell.imageInfo.imageUrl){
        //            if (!self.imageBaseUrl){
        //                self.imageBaseUrl = @"";
        //            }
        //            NSString *URLString = [self.imageBaseUrl stringByAppendingString:imageCollectionCell.imageInfo.imageUrl];
        //            URLString = [URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        //            //            [imageCollectionCell.adImageView sd_setImageWithURL:[NSURL URLWithString:URLString]];
        //        }
        
    }
    return imageCollectionCell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0,0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width),240);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self showImagePicker];
}


-(IBAction)addPhotoBtnClcked{
    [self showImagePicker];
}

-(void)showImagePicker{
    DKImagePickerController *pickerController = [DKImagePickerController new];
    pickerController.assetType = DKImagePickerControllerAssetTypeAllAssets;
    pickerController.showsCancelButton = YES;
    pickerController.showsEmptyAlbums = YES;
    pickerController.allowMultipleTypes = YES;
    if (self.assets.count > 0){
        pickerController.defaultSelectedAssets = self.assets;
    }else{
        pickerController.defaultSelectedAssets = @[];
    }
    pickerController.maxSelectableCount = 4;
    pickerController.sourceType = DKImagePickerControllerSourceTypeBoth;
    //  pickerController.assetGroupTypes    // unavailable
    //  pickerController.defaultAssetGroup  // unavailable
    
    [pickerController setDidSelectAssets:^(NSArray * __nonnull assetsDetails) {
        NSLog(@"didSelectAssets");
        if (assetsDetails){
            if (assetsDetails.count > 0){
                //                self.addImageButton.hidden = true;
                self.assets = assetsDetails;
                [self uploadImage];
            }else{
                if (self.assets.count > 0){
                    
                }else{
                    //                    self.addImageButton.hidden = false;
                }
            }
        }
        [self.imageCollectionView reloadData];
    }];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void)getAdCategoryFromServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"category"];
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString]};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
    
}

-(void)uploadAllImages{
    uploadImageCount = self.assets.count;
    uploadIndex = 0;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    for (DKAsset *object in self.assets) {
        [object fetchImageDataForAsset:true completeBlock:^(NSData * imageData, NSDictionary * dict) {
//            [self uploadImage:imageData];
        }];
    }
    [hud hideAnimated:YES];
}

-(void)uploadCompletedwithImageUrl:(NSString *)url{
    uploadIndex = uploadIndex + 1;
    if (url.length > 0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:url forKey:@"image_url"];
        [uploadedUrlArray addObject:dict];
    }
    if (uploadImageCount == uploadIndex){
        //        [self callJavaScriptMethod];
        isNeedTocallJavaMethod = true;
        [self.propertiesWebview reload];
        
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (isNeedTocallJavaMethod == true){
        isNeedTocallJavaMethod = false;
        [self callJavaScriptMethod];

    }
    [self showHideHud:true];
    NSLog(@"finish");
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"Error for WEBVIEW: %@", [error description]);
    [self showHideHud:true];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)requestURL navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [requestURL URL];
    NSString *responseString = [url absoluteString];
    NSString *newString = [responseString stringByReplacingOccurrencesOfString:@"%20"  withString:@" "];

//    NSString *newString = [responseString stringByReplacingOccurancesOfString:@" " withString:@"%20"];

    if ([newString rangeOfString:@"AD successfully created"].location == NSNotFound) {
        NSLog(@"string does not contain bla");
    } else {
        [self showSuccesAlert];
    }
    return YES;
    
}

-(void)showSuccesAlert{
    UIAlertController * alert =[UIAlertController
                                alertControllerWithTitle:@"Bayie" message:@"Ad created sucessfully" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self.navigationController dismissViewControllerAnimated:true completion:^{
																		 [[NSNotificationCenter defaultCenter] postNotificationName:@"showLandingScreen" object:nil];
																	 }];
                               }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)callJavaScriptMethod{
    DataClass *obj=[DataClass getInstance];
    NSString *token = obj.userToken;
    NSMutableString * jsonString = [NSMutableString new];
    [jsonString appendString:@"["];
    for (int i =0 ;i<uploadedUrlArray.count ;i++){
        NSDictionary * item = uploadedUrlArray[i];
        [jsonString appendFormat:@"{image_url: \"%@\"}",[item objectForKey:@"image_url"]];
        if (uploadedUrlArray.count > 1){
            if( i != (uploadedUrlArray.count - 1)){
                [ jsonString appendString:@","];
            }
        }
    }
    
    [jsonString appendString:@"]"];
    
    NSString *functionCall = [NSString stringWithFormat:@"updateAdImages('%@','%@')", jsonString,token];
    
    [self.propertiesWebview stringByEvaluatingJavaScriptFromString:functionCall];
    
}


-(void)uploadImage{
//    -(void)uploadImage:(NSData *) imageData{

//    NSString *URLString = [AdBaseUrl stringByAppendingString:@"adsImages"];
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"uploadMultiImages"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (DKAsset *object in self.assets) {
            [object fetchImageDataForAsset:true completeBlock:^(NSData * imageData, NSDictionary * dict) {
                [formData appendPartWithFileData:imageData name:@"file[]" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
            }];
        }
    } error:nil];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    DataClass *obj=[DataClass getInstance];
//    [request setValue:obj.userToken forHTTPHeaderField:@"userToken"];

    //    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          [self uploadCompletedwithImageUrl:@""];
                      } else {
                          if([responseObject isKindOfClass:[NSDictionary class]]) {
                              if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                                  NSArray * imagesDictionaries = responseObject[@"data"] ;
                                  NSMutableArray * subCategoryItems = [NSMutableArray array];
                                  for(NSDictionary * imageDetails in imagesDictionaries){
//                                      imageDetails
//                                      SubCategory * subCategoryItem = [[SubCategory alloc] initWithDictionary:subCategoryDictionary];
                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                      [dict setValue:imageDetails[@"image_url"] forKey:@"image_url"];
                                      [uploadedUrlArray addObject:dict];

//                                      [uploadedUrlArray addObject:imageDetails[@"image_url"]];
                                  }
                                  self->isNeedTocallJavaMethod = true;
                                  [self.propertiesWebview reload];

                              }
                              NSDictionary *responseDict = responseObject;
//                              [self uploadCompletedwithImageUrl:responseDict[@"image_url"]];
                          }
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
    //    return @"";
    
}

@end
