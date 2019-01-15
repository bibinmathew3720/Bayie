//
//  PostAdViewController.m
//  BayieMobileApp
//
//  Created by Apple on 02/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>

#import "Utility.h"
#import "PostBAdViewController.h"

#import "VideoVC.h"
#import "FilterVC.h"
#import "DataClass.h"
#import "UserProfile.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "CLAlertHandler.h"
#import "NSString+Extension.h"
#import "BCollectionViewCell.h"
#import "CategoryViewController.h"
#import "VerifyOTPViewController.h"

#import "PostAdCatViewController.h"

@interface PostBAdViewController () <UICollectionViewDelegate,UICollectionViewDataSource,CategoryViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate,FilterVCDelegate,BCollectionViewCellDelegate,PostAdCatViewControllerDelegate>{
    MBProgressHUD *hud;
}

@property (nonatomic,strong) id locationDetils;
@property (nonatomic,strong) id selectedCategory;
@property (nonatomic,strong) id selectedSubCategory;
@property (nonatomic,strong) NSDictionary* filterDictionary;
@property (nonatomic,strong) NSMutableArray *uploadedUrlArray;
@property (weak, nonatomic) IBOutlet UILabel *subCategoryLabel;
@property (nonatomic,strong) NSArray * subCategoryDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *selectedCategoryLabel;

@property (weak, nonatomic) IBOutlet UITextField *postAdTitleTextFeild;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;


@property (weak, nonatomic) IBOutlet UILabel *categoryDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *subCategoryHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *adDetailHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *postAdButton;
@property (nonatomic,assign) BOOL isArabic;

//Edit Post

@property (nonatomic, strong) id AdDetails;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *removedImagesIdArray;
@property (nonatomic, strong) NSString *imageBaseUrl;
@property (nonatomic, strong) NSString *defaultImageUrlString;
@property (weak, nonatomic) IBOutlet UIView *addMoreView;
@property (weak, nonatomic) IBOutlet UIImageView *addMoreImageView;

@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *videoDeleteButton;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSMutableArray *videosArray;
@property (nonatomic, strong) NSString *oldUrlString;
@property (nonatomic, strong) NSDictionary *videoDetailsForEdit;;

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@end

@implementation PostBAdViewController

#pragma mark - UIView LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedCategory = nil;
    self.filterDictionary = nil;
    [self customisation];
    [self customisCollectionView];
    self.uploadedUrlArray = [[NSMutableArray alloc]init];
    self.videosArray = [[NSMutableArray alloc] init];
    [self changeLanguage];
    //Edit Post
    self.imagesArray = [[NSMutableArray alloc] init];
    self.removedImagesIdArray = [[NSMutableArray alloc] init];
    self.videosArray = [[NSMutableArray alloc] init];
    if(self.isFromEditAd)
        [self getAdDetailsFromServer];
    else{
        [self populateUserDetails];
       // [self populateVideoDetails];
    }
}

-(void)populateUserDetails{
    DataClass *dataClass = [DataClass getInstance];
    self.nameTextField.text = dataClass.userName;
    self.emailTextField.text = dataClass.userEmail;
    self.mobileTextField.text = dataClass.userMobile;
    [self.imagesArray addObjectsFromArray:self.imageAssets];
    if (self.localVideoUrl != nil){
        [self.imagesArray addObject:self.localVideoUrl];
    }
    [self.collectionView reloadData];
}

-(void)populateVideoDetails{
    if (self.isVideoType){
        self.videoView.hidden = NO;
        self.addMoreView.hidden = YES;
        self.videoImageView.image = self.thumbNailImage;
    }
    else{
        self.videoView.hidden = YES;
        self.videoImageView.image = nil;
        self.addMoreView.hidden = NO;
    }
}

- (void)changeLanguage {
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        self.isArabic = YES;
        self.title = @"نشر إعلان";
        self.categoryDetailsLabel.text = @"تفاصيل الفئة";
        self.categoryLabel.text = @"الفئة";
        self.selectedCategoryLabel.text = @"اخترالفئة";
        self.subCategoryHeadingLabel.text = @"الفئة الفرعية";
        self.subCategoryLabel.text = @"حدد الفئة الفرعية";
        self.adDetailHeadingLabel.text =@"تفاصيل الإعلان";
        self.postAdTitleTextFeild.placeholder = @"عنوان";
        self.descriptionTextView.text = @"أدخل وصفا لإعلانك";
        self.priceTextField.placeholder = @"السعر";
        self.additionalDetailLabel.text = @"تفاصيل اضافية";
        self.contactDetailLabel.text = @"بيانات المتصل";
        self.nameTextField.placeholder = @"اسم";
        self.emailTextField.placeholder = @"البريد الإلكتروني";
        self.mobileTextField.placeholder = @"موبايل";
        self.locationTextField.placeholder = @"موقعك";
        [self.postAdButton setTitle:@"نشر إعلان" forState:UIControlStateNormal];
        if(self.isFromEditAd){
            self.title = @"تعديل الإعلان";
            [self.postAdButton setTitle:@"تحديث" forState:UIControlStateNormal];
        }
    }
    else {
        self.title = @"Post Ad";
        self.categoryDetailsLabel.text = @"CATEGORY DETAILS";
        self.categoryLabel.text = @"Category";
        self.selectedCategoryLabel.text = @"Select Category";
        self.subCategoryHeadingLabel.text = @"Sub Category";
        self.subCategoryLabel.text = @"Select Sub Category";
        self.adDetailHeadingLabel.text = @"AD DETAILS";
        self.postAdTitleTextFeild.placeholder = @"Title";
        self.descriptionTextView.text = @"Enter a description for your ad";
        self.priceTextField.placeholder = @"Price";
        self.additionalDetailLabel.text = @"Additional Details";
        self.contactDetailLabel.text = @"CONTACT DETAILS";
        self.nameTextField.placeholder = @"Name";
        self.emailTextField.placeholder = @"Email";
        self.mobileTextField.placeholder = @"Mobile";
        self.locationTextField.placeholder = @"Location";
        [self.postAdButton setTitle:@"POST AD" forState:UIControlStateNormal];
        if(self.isFromEditAd){
           self.title = @"Edit Ad";
           [self.postAdButton setTitle:@"UPDATE" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UIView Customisation

- (void)customisation {
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:ArabicBackArrowImageName]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }else{
        UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:BackArrowImageName]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }
    self.navigationItem.leftBarButtonItem.tintColor = AppCommonWhiteColor;
}

- (void)customisCollectionView {
    [self.collectionView registerNib: [UINib nibWithNibName:@"BCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bCell"];
    [self.collectionView  setCollectionViewLayout:[self collectionViewLayout]];
    self.collectionView .delegate = self;
    self.collectionView .dataSource = self;
    //self.contentInset =UIEdgeInsetsMake(30, 30, 10, 30);
    self.collectionView .contentInset =UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - UIView Action

- (void)rightButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)subCategorySelectionTapAction:(id)sender {
    if([self.subCategoryDataArray count] == 0){
        if(self.isFromEditAd){
            [self getCategoriesWithCompletionBlocke:^(BOOL status, id response) {
                NSLog(@"Sel Category:%@",self.selectedCategory);
                NSLog(@"Sel Category:%@",response);
                NSPredicate *subCatPredicate = [NSPredicate predicateWithFormat:@"SELF.id == %@",[self.selectedCategory valueForKey:@"id"]];
                NSArray *catArray = response;
                self.subCategoryDataArray = [[[catArray filteredArrayUsingPredicate:subCatPredicate] firstObject]valueForKey:@"sub_category"];
                [self showCategoryUIWithData:self.subCategoryDataArray withStatus:1];
            }];
        }
        else{
            [[CLAlertHandler standardHandler] showAlert:self.isArabic?@"الرجاء تحديد الفئة":@"Please select a category" title:@"Bayie" inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }
    else {
        [self showCategoryUIWithData:self.subCategoryDataArray withStatus:1];
    }
}

- (IBAction)categorySelectionTapAction:(id)sender {
    [self getCategoriesWithCompletionBlocke:^(BOOL status, id response) {
         [self showCategoryUIWithData:response withStatus:0];
    }];
}

- (IBAction)locationTapGuestureAction:(id)sender {
    [self getLocationDetails];
}

- (IBAction)postAdButtonAction:(id)sender {
        if([self isValid]) {
            if(self.isFromEditAd){
                [self.view endEditing:YES];
                if ([self checkVideo]){
                    for (id item  in self.imagesArray){
                        if ([item isKindOfClass:[NSURL class]]){
                            NSURL *videoURL = item;
                           // NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
                            
                            [self compress:videoURL completionBlock:^(id data, BOOL result) {
                                AVAssetExportSession *exportSession = (AVAssetExportSession *)data;
                                
                                NSData *videoData = [NSData dataWithContentsOfURL:exportSession.outputURL];
                                NSLog(@"Output video length:%lu",(unsigned long)videoData.length);
                                [self uploadVideoWithData:videoData];
                            }];
                            
                            //[self uploadVideoWithData:videoData];
                        }
                    }
                }
                else if ([self checkImage]){
                    [self uploadImage];
                }
                else {
                    [self updateAdApi];
                }
                
//                if(self.selectedAsstesMutableArray.count>0)
//                    [self uploadImage];
//                else if (self.videoData != nil){
//                   [self uploadVideoWithData:self.videoData];
//                }
//                else{
//                    [self updateAdApi];
//                }
            }

            else  {
                if ([self checkVideo]){
                    for (id item  in self.imagesArray){
                        if ([item isKindOfClass:[NSURL class]]){
                            NSURL *videoURL = item;
                            [self compress:videoURL completionBlock:^(id data, BOOL result) {
                                AVAssetExportSession *exportSession = (AVAssetExportSession *)data;
                                NSData *videoData = [NSData dataWithContentsOfURL:exportSession.outputURL];
                                NSLog(@"Output video length:%lu",(unsigned long)videoData.length);
                                [self uploadVideoWithData:videoData];
                            }];
                            
                        }
                    }
                }
                else if ([self checkImage]){
                    [self uploadImage];
                }
            }
        }
}

- (void)compress:(NSURL *)videoPath completionBlock:(void(^)(id data, BOOL result))block{
    NSString *outputFilePath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputFilePath];
    [self compressVideoWithURL:videoPath outputURL:outputURL handler:^(AVAssetExportSession *exportSession) {
        block(exportSession,YES);
    }];
}

- (void)compressVideoWithURL:(NSURL*)inputURL
                   outputURL:(NSURL*)outputURL
                     handler:(void (^)(AVAssetExportSession*))handler {
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:inputURL];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.fileLengthLimit = 3000000;
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        handler(exportSession);
    }];
}

-(BOOL)checkVideo{
    if (self.isFromEditAd){
        for (id item  in self.imagesArray){
            if ([item isKindOfClass:[NSURL class]]){
                NSURL *videoURL = item;
                NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
                return YES;
            }
        }
    }
    else{
        for (id item  in self.imagesArray){
            if ([item isKindOfClass:[NSURL class]]){
                NSURL *videoURL = item;
                NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)checkImage{
    for (id item  in self.imagesArray){
        if ([item isKindOfClass:[DKAsset class]]){
           
            return YES;
        }
    }
    return NO;
}

- (IBAction)addMoreButtonAction:(UIButton *)sender {
    [self loadingPostAdCatController];
}

- (IBAction)videoButtonAction:(UIButton *)sender {
}

- (IBAction)additionalDetailsTapGuestureAction:(id)sender {
    if(self.selectedCategory){
        FilterVC *filterVC = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
        filterVC.categoryName = [self.selectedCategory valueForKey:@"category_name"];
        filterVC.categoryID = [self.selectedCategory valueForKey:@"id"];
        filterVC.isFromPostAd = YES;
        filterVC.isFromEditAd = self.isFromEditAd;
        filterVC.adDetails = self.AdDetails;
        filterVC.filterVcDelegate = self;
        filterVC.selectedFilterDictionary = self.filterDictionary;
        [self settingTitleForFilterVC:filterVC];
        [self.navigationController pushViewController:filterVC animated:YES];
    }else {
        [[CLAlertHandler standardHandler] showAlert:self.isArabic?@"الرجاء تحديد الفئة":@"Please select a category" title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
            
        }];
    }
}

-(void)settingTitleForFilterVC:(FilterVC *)filterVC{
    if(self.isArabic){
        if(self.isFromEditAd)
            filterVC.title = @"تعديل الإعلان";
        else
            filterVC.title = @"نشر إعلان";
    }
    else{
        if(self.isFromEditAd)
            filterVC.title = @"Edit Ad";
        else
            filterVC.title = @"Post Ad";
    }
    
}

#pragma mark -

- (BOOL)isValid {
    BOOL valid = NO;
    NSString * message;
    if([self.selectedCategoryLabel.text length] == 0 || [self.selectedCategoryLabel.text isEqualToString:@"Select Category"] || [self.selectedCategoryLabel.text isEqualToString:@"اختر الفئة"] ) {
        message = self.isArabic?@"الرجاء تحديد الفئة":@"Please select a category";
    }
//    else if([self.subCategoryLabel.text length] == 0 || [self.subCategoryLabel.text isEqualToString:@"Select Sub Category"] || [self.subCategoryLabel.text isEqualToString:@"حدد الفئة الفرعية"]) {
//        message = self.isArabic?@"الرجاء تحديد فئة فرعية":@"Please Select a Sub Category.";
//    }
    else if([self.postAdTitleTextFeild.text length] == 0) {
        message = self.isArabic?@"يرجى إضافة عنوان":@"Please add a title.";
    }else if([self.postAdTitleTextFeild.text length] < 10) {
        message = self.isArabic?@"أدخل عنوان الإعلان بحد أدنى 10 أحرف.":@"Enter title for ad with minimum 10 characters.";
    }else if([self.descriptionTextView.text length] == 0 || [self.descriptionTextView.text isEqualToString:@"Enter a description for your ad"] ||[self.descriptionTextView.text isEqualToString:@"أدخل وصفا لإعلانك"]) {
        message = self.isArabic?@"يرجى إضافة تنقيح لإعلانك.":@"Please add descrition for your ad.";
    }else if([self.priceTextField.text length] == 0) {
        message = self.isArabic?@"يرجى إضافة سعر.":@"Please add a price.";
    }else if([self.nameTextField.text length] == 0) {
        message = self.isArabic?@"الرجاء إضافة اسم للاتصال.":@"Please add a name to contact.";
    }else if([self.emailTextField.text length] == 0) {
        message = self.isArabic?@"الرجاء إضافة بريد إلكتروني إلى جهة الاتصال.":@"Please add an email to contact.";
    }else if(![self.emailTextField.text validEmail]) {
        message = self.isArabic?@"الرجاء إدخال بريد إلكتروني صالح للاتصال.":@"Please enter a valid email to contact.";
    }else if([self.mobileTextField.text length] == 0) {
        message = self.isArabic?@"الرجاء إدخال رقم جوال صحيح.":@"Please enter a valid mobile number.";
    }else if([self.mobileTextField.text length] != 8) {
        message = self.isArabic?@"الرجاء إدخال رقم جوال صحيح.":@"Please enter a valid mobile number.";
    }else if([self.locationTextField.text length] == 0) {
        message = self.isArabic?@"الرجاء إدخال موقع صالح.":@"Please enter a valid location.";
    }else
        valid = YES;
    if(!valid)
        [[CLAlertHandler standardHandler] showAlert:message title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
            
        }];
    return valid;
}

#pragma mark -

- (void)showCategoryUIWithData:(id)data withStatus:(int) statusValue {
    CategoryViewController * categoryController = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
    categoryController.baseUrl = [data valueForKey:@"baseUrl"];
    categoryController.dataArray = data;
    categoryController.categoryDelegate = self;
    switch (statusValue) {
        case 0:
            
            break;
        case 1:
            categoryController.isSubCategory = YES;
            break;
        case 2:
            categoryController.isLocation = YES;
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:categoryController animated:YES];
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"أدخل وصفا لإعلانك"]||[textView.text isEqualToString:@"Enter a description for your ad"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text  length] == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = self.isArabic?@"أدخل وصفا لإعلانك": @"Enter a description for your ad";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - UICollection View Delegate and Datasource

- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.frame.size.width, 200);
    layout.minimumInteritemSpacing = 10;
    return layout;
}

- (Class)collectionViewCellClass {
    return [UICollectionViewCell class];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.isFromEditAd){
        if(self.imagesArray.count == 0){
            self.addMoreView.hidden = NO;
            self.collectionView.hidden = YES;
        }
        else{
            self.addMoreView.hidden = YES;
            self.collectionView.hidden = NO;
        }
        return self.imagesArray.count;
    }
    else
        return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bCell" forIndexPath:indexPath ];
    cell.tag = indexPath.row+1000;
    if(self.isFromEditAd){
        cell.imageBaseUrl = self.imageBaseUrl;
        cell.defaultImageUrl = self.defaultImageUrlString;
        cell.imageDetails = [self.imagesArray objectAtIndex:indexPath.row];
    }
    else{
         cell.imageDetails = [self.imagesArray objectAtIndex:indexPath.row];
//        if ([[self.imagesArray objectAtIndex:indexPath.row] isKindOfClass: [DKAsset class]]){
//            cell.asset = [self.imagesArray objectAtIndex:indexPath.row];
//        }
//        else if ([[self.imagesArray objectAtIndex:indexPath.row] isKindOfClass: [NSData class]]){
//            
//        }
    }
    cell.tag = indexPath.row;
    cell.cellDelegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 200);;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // return 20;
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //return 20;
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -

- (void)categoryViewControllerItem:(CategoryViewController *)viewController clickedItem:(id)item {
    NSLog(@"Sel Category:%@",self.selectedCategory);
    if(self.selectedCategory!=nil && ![self.selectedCategory isEqual:[NSNull null]]){
        NSString *selCategoryIdString = [NSString stringWithFormat:@"%@",[self.selectedCategory valueForKey:@"id"]];
         NSString *clickedItemIdString = [NSString stringWithFormat:@"%@",[item valueForKey:@"id"]];
        if(![selCategoryIdString isEqualToString:clickedItemIdString]){
            self.filterDictionary = nil;
            self.selectedSubCategory = nil;
            self.subCategoryLabel.text = @"";
        }
    }
    self.selectedCategory = item;
    self.selectedCategoryLabel.text = [item valueForKey:@"category_name"];
    self.subCategoryDataArray = [item valueForKey:@"sub_category"];
    NSLog(@"%@",[item valueForKey:@"sub_category"]);
}

- (void)categoryViewControllerItem:(CategoryViewController *)viewController clickedsubCategoryItem:(id)item andSubCAtegoryElement:(id)subCategoryElement {
    self.selectedSubCategory = subCategoryElement;
    if(item!=nil)
        self.subCategoryLabel.text = item;
}

- (void)categoryViewControllerItem:(CategoryViewController *)viewController clickedLocationItem:(id)item {
    self.locationDetils = item;
    self.self.locationTextField.text = [item valueForKey:@"location"];
}

#pragma mark - Filter VC Delegate

- (void)filterVcItem:(FilterVC *) viewController clickedItem:(id)item {
    self.filterDictionary = item;
}

#pragma mark - Api

- (void)getCategoriesWithCompletionBlocke:(void(^)(BOOL status,id response))categoryCompletion {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
     DataClass *obj=[DataClass getInstance];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=getAllCategories" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue:obj.userToken forHTTPHeaderField:@"Usertoken"];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.categoryArray = [responseObject valueForKey:@"data"];
                        categoryCompletion(YES,[responseObject valueForKey:@"data"]);
                       
                    });
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            categoryCompletion(NO,nil);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

- (void)getLocationDetails {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
     DataClass *obj=[DataClass getInstance];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=locationList" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue:obj.userToken forHTTPHeaderField:@"Usertoken"];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
    
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showCategoryUIWithData:[responseObject valueForKey:@"data"] withStatus:2];
                    });
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

-(void)uploadImage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"uploadMultiImages"];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(self.isFromEditAd){
            NSMutableArray *imageAssetArray = [[NSMutableArray alloc] init];
            for (id item in _imagesArray){
                if ([item isKindOfClass:[DKAsset class]]){
                    [imageAssetArray addObject:item];
                }
            }
            for (DKAsset *object in imageAssetArray) {
                [object fetchImageDataForAsset:true completeBlock:^(NSData * imageData, NSDictionary * dict) {
                    [formData appendPartWithFileData:imageData name:@"file[]" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
                }];
            }
        }
        else{
                NSMutableArray *imageAssetArray = [[NSMutableArray alloc] init];
                for (id item in _imagesArray){
                    if ([item isKindOfClass:[DKAsset class]]){
                        [imageAssetArray addObject:item];
                    }
                }
                for (DKAsset *object in imageAssetArray) {
                    [object fetchImageDataForAsset:true completeBlock:^(NSData * imageData, NSDictionary * dict) {
                        [formData appendPartWithFileData:imageData name:@"file[]" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
                    }];
                }
        }
    } error:nil];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [request setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {

                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                      });
                      if (error) {
                          NSLog(@"Error: %@", error);
                          //[self uploadCompletedwithImageUrl:@""];
                      } else {

                          if([responseObject isKindOfClass:[NSDictionary class]]) {
                              if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                                  NSArray * imagesDictionaries = responseObject[@"data"] ;
                                  for(NSDictionary * imageDetails in imagesDictionaries){
                                      //                                      imageDetails
                                      //                                      SubCategory * subCategoryItem = [[SubCategory alloc] initWithDictionary:subCategoryDictionary];
                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                      [dict setValue:imageDetails[@"image_url"] forKey:@"image_url"];
                                      [self.uploadedUrlArray addObject:dict];
                                  }
                                  if(self.isFromEditAd)
                                      [self updateAdApi];
                                  else
                                      [self postAdDetails];
                              }
                          }
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];

    [uploadTask resume];
}

// For Video Upload

-(void)uploadVideoWithData:(NSData *)videoData{
     _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
        NSString *URLString = [@"https://bayie.digiora.com/api/apiAds.php?action=" stringByAppendingString:@"uploadVideo"];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:videoData name:@"file" fileName:@"fileName.mp4" mimeType:@"video/mp4"];
        } error:nil];
        
        [request setValue:AuthValue forHTTPHeaderField:@"Authentication"];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionUploadTask *uploadTask;
        request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Video Uploading Progress = %f", uploadProgress.fractionCompleted);
            });
        }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              if (error) {
                                                  NSLog(@"Error:%@",error);
                                                  _bgTask = UIBackgroundTaskInvalid;
                                                  [MBProgressHUD hideHUDForView:self.view animated:true];
                                              }
                                              else {
                                                  [MBProgressHUD hideHUDForView:self.view animated:true];
                                                  id data = [responseObject valueForKey:@"data"];
                                                  self.videoName = [data valueForKey:@"video"];
                                                  self.videoUrl = [data valueForKey:@"video_url"];
                                                  if (self.isFromEditAd) {
                                                      if ([self checkImage]){
                                                          [self uploadImage];
                                                      }
                                                      else{
                                                          [self updateAdApi];
                                                      }
                                                  }
                                                  else{
                                                      if ([self checkImage]){
                                                          [self uploadImage];
                                                      }
                                                      else{
                                                          [self postAdDetails];
                                                      }
                                                  }
                                                  NSLog(@"Success");
                                                  NSLog(@"%@",responseObject);
                                              }
                                          }];
        [uploadTask resume];
    
    
   
    
    
}

- (void)postAdDetails {
    DataClass *obj=[DataClass getInstance];
    NSString *userToken = (obj.userToken == nil?@"":obj.userToken);
    id filterDict = (self.filterDictionary == nil?@"":self.filterDictionary);
    NSString *catIdString = @"";
    if(self.selectedSubCategory ==nil){
        catIdString = [NSString stringWithFormat:@"%@",[self.selectedCategory valueForKey:@"id"]];
    }
    else{
        catIdString = [NSString stringWithFormat:@"%@",[self.selectedSubCategory valueForKey:@"id"]];
    }
    NSDictionary * parameters;
    if (!self.isVideoType) {
        parameters = @{@"images":self.uploadedUrlArray,@"title":self.postAdTitleTextFeild.text,@"category":catIdString,@"attributes":filterDict,@"price":self.priceTextField.text,@"priceType":@"Fixed",@"condition":@"new",@"description":self.descriptionTextView.text,@"name":self.nameTextField.text,@"email":self.emailTextField.text,@"mobileNumber":self.mobileTextField.text,@"location":[self.locationDetils valueForKey:@"id"],@"language":[DataClass currentLanguageString],@"userToken":userToken};
    }
    else{
        NSDictionary *videoDict = @{ @"video":self.videoName, @"video_url":self.videoUrl
                                    };
        parameters = @{@"video":videoDict,@"title":self.postAdTitleTextFeild.text,@"category":catIdString,@"attributes":filterDict,@"price":self.priceTextField.text,@"priceType":@"Fixed",@"condition":@"new",@"description":self.descriptionTextView.text,@"name":self.nameTextField.text,@"email":self.emailTextField.text,@"mobileNumber":self.mobileTextField.text,@"location":[self.locationDetils valueForKey:@"id"],@"language":[DataClass currentLanguageString],@"userToken":userToken,@"images":self.uploadedUrlArray};
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=postAd" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setValue:obj.userToken forHTTPHeaderField:@"Usertoken"];
    
//    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if([responseDict valueForKey:@"adToken"]){
                    NSString *adToken = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"adToken"]];
                    [self showOTPScreenWithAdToken:adToken];
                    _bgTask = UIBackgroundTaskInvalid;
                }
                else if (![responseDict[@"error"] isEqualToString:@""]) {
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    [[CLAlertHandler standardHandler] showAlert:[responseObject valueForKey:@"data"] title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        _bgTask = UIBackgroundTaskInvalid;
                        if(self.postAdDelegate && [self.postAdDelegate respondsToSelector:@selector(postBAdViewControllerItem:clickedBackButton:)]){
                            [self.postAdDelegate postBAdViewControllerItem:self clickedBackButton:self];
                        }
                    }];
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:@"Bayie" inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

-(void)showOTPScreenWithAdToken:(NSString *)adToken{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    UIStoryboard *storyboard;
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        if([DataClass isiPad]){
            storyboard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
            
        }else{
            storyboard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
        }
    }else if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        if([DataClass isiPad]){
            storyboard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
        }else{
            storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
        }
       
    }
    VerifyOTPViewController *otpVC = [storyboard instantiateViewControllerWithIdentifier:@"VerifyOTP"];
    otpVC.otpType = OTPTypePostAd;
    otpVC.adToken = adToken;
    [self.navigationController pushViewController:otpVC animated:YES];
}

#pragma mark - Get Ad Details

-(void)getAdDetailsFromServer{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"fetchAdDetails"];
    DataClass *obj=[DataClass getInstance];
    NSDictionary *parameters =  @{@"adId":self.adId,@"language":[DataClass currentLanguageString],@"userToken":obj.userToken};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                
                if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    //[self populateAdDetailsWithResponse:responseObject];
                }
                else{
                   [self populateAdDetailsWithResponse:responseObject];
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
}

-(void)populateAdDetailsWithResponse:(id)adDetails{
    NSLog(@"Ad Details:%@",adDetails);
    self.AdDetails = adDetails;
    id data = [adDetails valueForKey:@"data"];
    //Populating Category Details
   
    if([adDetails valueForKey:@"breadcrumbs"]){
        id breadCrubs = [adDetails valueForKey:@"breadcrumbs"];
        self.selectedCategory = [NSDictionary dictionaryWithObjectsAndKeys:[breadCrubs valueForKey:@"category_name"],@"category_name",[breadCrubs valueForKey:@"id"],@"id", nil];
         self.selectedCategoryLabel.text = [NSString stringWithFormat:@"%@",[self.selectedCategory valueForKey:@"category_name"]];
    }
    
    if([adDetails valueForKey:@"attributes"]){
        self.filterDictionary = [adDetails valueForKey:@"attributes"];
    }
    
    if([[adDetails valueForKey:@"breadcrumbs"] valueForKey:@"sub_category"]){
        self.selectedSubCategory = [[adDetails valueForKey:@"breadcrumbs"] valueForKey:@"sub_category"];
        while ([self getSubCategoryFromInputValue:self.selectedSubCategory]!=nil) {
            self.selectedSubCategory = [self.selectedSubCategory valueForKey:@"sub_category"];
        }
       self.subCategoryLabel.text = [NSString stringWithFormat:@"%@",[self.selectedSubCategory valueForKey:@"category_name"]];
    }
    //Populating Ad Details
    self.postAdTitleTextFeild.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"title"]];
    NSString *description = [NSString stringWithFormat:@"%@",[data valueForKey:@"description"]];
    if(description.length>0){
        self.descriptionTextView.text = description;
        self.descriptionTextView.textColor = [UIColor blackColor];
    }
    self.priceTextField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"price"]];
    for (id item in [adDetails valueForKey:@"images"]){
       // if ([[item valueForKey:@"status"] isEqualToString:@"Active"]){
            [self.imagesArray addObject:item];
       // }
    }
    self.imageBaseUrl = [adDetails valueForKey:@"imageBaseUrl"];
    [self.collectionView reloadData];
    if ([adDetails valueForKey:@"video"]){
        NSArray *videosArray = [adDetails valueForKey:@"video"];
        for (id video in videosArray) {
           // if ([[video valueForKey:@"status"] isEqualToString:@"Active"]){
                //[self.videosArray addObject:video];
                self.oldUrlString = [video valueForKey:@"video"];
                self.videoDetailsForEdit = @{ @"video":[video valueForKey:@"video"], @"video_url":[video valueForKey:@"video_url"],@"old":@"no_video"};
                [self.imagesArray addObject:video];
                [self.collectionView reloadData];
           // }
        }
        if (self.videosArray.count > 0){
            self.isVideoType = YES;
            [self populateVideoDetails];
        }
    }
   
    self.defaultImageUrlString = [adDetails valueForKey:@"defaultImage"];
    [self.addMoreImageView sd_setImageWithURL:[NSURL URLWithString:self.defaultImageUrlString] placeholderImage:[UIImage imageNamed:@""]];
    
    //Populating User Details
    self.nameTextField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"name"]];
    self.emailTextField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"email"]];
    self.mobileTextField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"mobile_number"]];
    
    self.locationDetils = [NSDictionary dictionaryWithObjectsAndKeys:[data valueForKey:@"location_name"],@"location",[data valueForKey:@"location"],@"id", nil];
    self.locationTextField.text = [NSString stringWithFormat:@"%@",[self.locationDetils valueForKey:@"location"]];
    
   // if([data valueForKey:@"location"]){
//        if([[data valueForKey:@"location"] count]>0){
//            id location = [[data valueForKey:@"location"] firstObject];
//            self.locationDetils = [NSDictionary dictionaryWithObjectsAndKeys:[location valueForKey:@"location"],@"location",[location valueForKey:@"id"],@"id", nil];
//            self.locationTextField.text = [NSString stringWithFormat:@"%@",[self.locationDetils valueForKey:@"location"]];
//        }
  //  }
    
}

-(id)getSubCategoryFromInputValue:(id)inputValue{
    if([inputValue valueForKey:@"sub_category"]){
        return [inputValue valueForKey:@"sub_category"];
    }
    else
        return nil;
}

#pragma mark - BCollectionView Cell Delegate

-(void)addMoreButtonActionDelegateWithTag:(NSUInteger)cellTag{
    NSMutableArray *imagesMutarray = [[NSMutableArray alloc] init];
    for (id item  in self.imagesArray){
        if ([item isKindOfClass:[DKAsset class]]){
            [imagesMutarray addObject:item];
        }
        else if ([item isKindOfClass:[NSDictionary class]]){
            if ([[item valueForKey:@"type"] isEqualToString:@"image"]){
                //if ([[item valueForKey:@"status"] isEqualToString:@"Active"]){
                    [imagesMutarray addObject:item];
               // }
            }
        }
    }
    if(imagesMutarray.count>=6){
        UIAlertController *alertCntlr = [UIAlertController alertControllerWithTitle:@"Bayie" message:NSLocalizedString(@"PHOTOLIMIT", @"Photo Limit") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCntlr addAction:okAction];
        [self presentViewController:alertCntlr animated:YES completion:nil];
    }
    else{
        [self loadingPostAdCatController];
    }
}

-(void)selectedVideoWithTag:(NSUInteger)cellTag{
    id imageDetails = [self.imagesArray objectAtIndex:cellTag];
    if ([imageDetails isKindOfClass:[NSURL class]]){
        NSString *videoUrlString = [NSString stringWithFormat:@"%@",imageDetails];
        [self loadVideoVC:videoUrlString];
    }
    else if ([imageDetails isKindOfClass:[NSDictionary class]]){
        NSString *videoUrlString = [NSString stringWithFormat:@"%@",[imageDetails valueForKey:@"video_url"]];
        [self loadVideoVC:videoUrlString];
    }
}

-(void)loadVideoVC:(NSString *)videoUrl{
    VideoVC *videoVC = [[VideoVC alloc] initWithNibName:@"VideoVC" bundle:nil];
    videoVC.videoUrl = videoUrl;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:videoVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)videoDeleteButtonAction:(UIButton *)sender {
    if (self.videoData != nil){
        self.videoData = nil;
        self.isVideoType = NO;
        [self populateVideoDetails];
    }
    else{
        if (self.videosArray.count > 0){
            NSLog(@"Video %@",self.videosArray.firstObject);
            [self callingRemoveVideoApiWithVideoDetails:self.videosArray.firstObject];
        }
    }
}

-(void)loadingPostAdCatController{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    UIStoryboard *storyBoard;
    PostAdCatViewController *postAdCatVC;
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        if([DataClass isiPad]){
            storyBoard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
            
        }else{
            storyBoard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
        }
    }
    else{
        if([DataClass isiPad]){
            storyBoard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
            
        }else{
            storyBoard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
        }
    }
    postAdCatVC = [storyBoard instantiateViewControllerWithIdentifier:@"PostAdCatViewController"];
    postAdCatVC.postAdCatCnlrDel = self;
    postAdCatVC.isFromEditAd = self.isFromEditAd;
    postAdCatVC.isFromMore = YES;
    postAdCatVC.imagesArray = self.imagesArray;
    [self presentViewController:postAdCatVC animated:YES completion:nil];
}

#pragma mark - Update Ad Api

-(void)updateAdApi{
    DataClass *obj=[DataClass getInstance];
    //need to add removed images
    NSString *catIdString = @"";
    if(self.selectedSubCategory ==nil){
        catIdString = [NSString stringWithFormat:@"%@",[self.selectedCategory valueForKey:@"id"]];
    }
    else{
       catIdString = [NSString stringWithFormat:@"%@",[self.selectedSubCategory valueForKey:@"id"]];
    }
    NSDictionary * parameters ;
    NSDictionary *videoDict;
    if (self.isVideoType){
        if (self.oldUrlString.length>0){
            videoDict = @{ @"video":self.videoName, @"video_url":self.videoUrl,@"old":self.oldUrlString
                           };
        }
        else{
            videoDict = @{ @"video":self.videoName, @"video_url":self.videoUrl,@"old":@"no_video"
                                         };
        }
        parameters = @{@"video":videoDict,@"adId":self.adId,@"images":self.uploadedUrlArray,@"title":self.postAdTitleTextFeild.text,@"category":catIdString,@"attributes":self.filterDictionary == nil?@"":self.filterDictionary,@"price":self.priceTextField.text,@"condition":@"New",@"description":self.descriptionTextView.text,@"name":self.nameTextField.text,@"email":self.emailTextField.text,@"mobileNumber":self.mobileTextField.text,@"location":[self.locationDetils valueForKey:@"id"]==nil?@"":[self.locationDetils valueForKey:@"id"],@"language":[DataClass currentLanguageString],@"removed_images":[self removedImagesIdArray],@"userToken":obj.userToken};
    }
    else{
        if (self.videoDetailsForEdit != nil){
           
            parameters = @{@"video":self.videoDetailsForEdit,@"adId":self.adId,@"images":self.uploadedUrlArray,@"title":self.postAdTitleTextFeild.text,@"category":catIdString,@"attributes":self.filterDictionary == nil?@"":self.filterDictionary,@"price":self.priceTextField.text,@"condition":@"New",@"description":self.descriptionTextView.text,@"name":self.nameTextField.text,@"email":self.emailTextField.text,@"mobileNumber":self.mobileTextField.text,@"location":[self.locationDetils valueForKey:@"id"]==nil?@"":[self.locationDetils valueForKey:@"id"],@"language":[DataClass currentLanguageString],@"removed_images":[self removedImagesIdArray],@"userToken":obj.userToken};
        }
        else{
            parameters = @{@"adId":self.adId,@"images":self.uploadedUrlArray,@"title":self.postAdTitleTextFeild.text,@"category":catIdString,@"attributes":self.filterDictionary == nil?@"":self.filterDictionary,@"price":self.priceTextField.text,@"condition":@"New",@"description":self.descriptionTextView.text,@"name":self.nameTextField.text,@"email":self.emailTextField.text,@"mobileNumber":self.mobileTextField.text,@"location":[self.locationDetils valueForKey:@"id"]==nil?@"":[self.locationDetils valueForKey:@"id"],@"language":[DataClass currentLanguageString],@"userToken":obj.userToken,@"removed_images":[self removedImagesIdArray]};
        }
       
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=updateAd" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    
    //    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    if([responseDict valueForKey:@"adToken"]){
                        NSString *adToken = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"adToken"]];
                        [self showOTPScreenWithAdToken:adToken];
                        _bgTask = UIBackgroundTaskInvalid;
                    }
                    else{
                        [[CLAlertHandler standardHandler] showAlert:[responseObject valueForKey:@"data"] title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                            _bgTask = UIBackgroundTaskInvalid;
                            [self dismissViewControllerAnimated:YES completion:nil];
                            if(self.postAdDelegate && [self.postAdDelegate respondsToSelector:@selector(postBAdViewControllerItem:clickedBackButton:)]){
                                [self.postAdDelegate postBAdViewControllerItem:self clickedBackButton:self];
                            }
                        }];
                    }
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:@"Bayie" inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

#pragma mark - Post Ad Cat Controller Delegate

-(void)postAdCatDelegateWithImageAssetsArray:(NSArray *)imageAssetsArray
{
    [self.imagesArray addObjectsFromArray:imageAssetsArray];
    [self.collectionView reloadData];
}

-(void)postAdCatDelegateWithVideoData:(NSData *)videoData thumbNailImage:(UIImage *)thumbNail withVideoUrl:(NSURL *)videoUrl{
    self.isVideoType = YES;
    self.videoData = videoData;
    self.thumbNailImage = thumbNail;
    BOOL isFound = false;
    for (id item  in self.imagesArray){
        if ([item isKindOfClass:[NSDictionary class]]){
            if ([[item valueForKey:@"type"] isEqualToString:@"video"]){
               // if ([[item valueForKey:@"status"] isEqualToString:@"Active"]){
                    [self.imagesArray removeObject:item];
                    [self.imagesArray addObject:videoUrl];
                    isFound = YES;
                    [self.collectionView reloadData];
                    break;
               // }
            }
        }
    }
    if (!isFound){
        [self.imagesArray addObject:videoUrl];
         [self.collectionView reloadData];
    }
}

-(void)removeButtonActionDelegateWithTag:(NSUInteger)cellTag
{
    NSLog(@"Seleted Image:%@",[self.imagesArray objectAtIndex:cellTag]);
    id selImage = [self.imagesArray objectAtIndex:cellTag];
    if([selImage isKindOfClass:[NSDictionary class]]){
        if ([[selImage valueForKey:@"type"] isEqualToString:@"video"]){
            [self callingRemoveVideoApiWithVideoDetails:selImage];
        }
        else{
            [self callingRemoveImageApiWithImageDetails:selImage];
        }
    }
    else if ([selImage isKindOfClass:[DKAsset class]]){
        [self.imagesArray removeObject:selImage];
        [self.collectionView reloadData];
    }
    else if ([selImage isKindOfClass:[NSURL class]]){
        [self.imagesArray removeObject:selImage];
        [self.collectionView reloadData];
    }
}

#pragma mark - Remove Image Api Calling

-(void)callingRemoveImageApiWithImageDetails:(id)imageDetails{
    DataClass *obj=[DataClass getInstance];
    //need to add removed images
    NSDictionary * parameters = @{@"adId":self.adId,@"image_url":[imageDetails valueForKey:@"image_url"],@"language":[DataClass currentLanguageString],@"userToken":obj.userToken};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=deleteAdsImage" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    [[CLAlertHandler standardHandler] showAlert:[responseObject valueForKey:@"data"] title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                        NSDictionary *removedImage = [imageDetails valueForKey:@"image"];
                        [self.removedImagesIdArray addObject:removedImage];
                        NSDictionary *removedImageUrlObject = [NSDictionary dictionaryWithObject:[imageDetails valueForKey:@"image_url"] forKey:@"image_url"];
                        if([self.uploadedUrlArray containsObject:removedImageUrlObject])
                            [self.uploadedUrlArray removeObject:removedImageUrlObject];
                        if([self.imagesArray containsObject:imageDetails])
                            [self.imagesArray removeObject:imageDetails];
                        [self.collectionView reloadData];
                        
                    }];
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:@"Bayie" inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

#pragma mark - Remove Image Api Calling

-(void)callingRemoveVideoApiWithVideoDetails:(id)videoDetails{
    DataClass *obj=[DataClass getInstance];
    //need to add removed images
    NSDictionary * parameters = @{@"video":[videoDetails valueForKey:@"video"],@"video_url":[videoDetails valueForKey:@"video_url"],@"language":[DataClass currentLanguageString],@"userToken":obj.userToken};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=deleteVideo" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    [[CLAlertHandler standardHandler] showAlert:@"Video removed successfully" title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                        [self.videosArray removeAllObjects];
                        self.isVideoType = NO;
                        self.videoDetailsForEdit = nil;
                        if([self.imagesArray containsObject:videoDetails])
                            [self.imagesArray removeObject:videoDetails];
                        [self.collectionView reloadData];
                       // [self populateVideoDetails];
                        //[self dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:@"Bayie" inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
@end
