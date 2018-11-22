


//
//  AdDetailedViewController.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 02/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//
#import "Utility.h"
#import "AdDetailedViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UINavigationBar+Awesome.h"
#import "DataClass.h"
#import "Advertisement.h"
#import "UserProfileTableViewCell.h"
#import "ImageColectionViewTableViewCell.h"
#import "DescriptionTableViewCell.h"
#import "AdPropertyTableViewCell.h"
#import "AdDeatilsHeaderTableViewCell.h"
#import "AdReportTableViewCell.h"
#import "SellerDetailTableViewCell.h"
#import "AdSummaryTableViewCell.h"
#import "UIViewController+TransparentNavBar.h"
#import "AdCategoryViewController.h"
#import "AdSubCategoryViewController.h"
#import "SubCategory.h"
#import "ChatDetailViewController.h"
#import "SeeAllAdsViewController.h"
#import "Utility.h"

#import "VideoVC.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"

@interface AdDetailedViewController ()<AdCategoryDelegte,AdSubCategoryDelegte,ImagesCollectionDelegte>{
    Advertisement *adDetails;
    UIButton *favouriteBtn;
    UILabel *imageCountLbl;
    BOOL noAttirbuteValues;
    Category *selectedCategory;
    SubCategory *selectedSubCategory;
    MBProgressHUD *hud;
    
}
@property (weak, nonatomic) IBOutlet UITableView *adTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *adimageColectionView;
@property (nonatomic, strong) NSString *videoUrlString;

@end

@implementation AdDetailedViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseNavigationBar];
    noAttirbuteValues = false;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
	self.adTableView.contentOffset = CGPointZero;
    self.adTableView.estimatedRowHeight = 44;//the estimatedRowHeight but if is more this autoincremented with autolayout
    self.adTableView.rowHeight = UITableViewAutomaticDimension;
    self.adTableView.tableFooterView = [UIView new];
//    self.title = @"Adv";
    [self getAdDetailsFromServer];
    // Do any additional setup after loading the view.
}


- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[self.navigationController setNavigationBarHidden:false];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)customiseNavigationBar{
    [self.navigationController setNavigationBarHidden:false];
    UIBarButtonItem *myBackButton;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow-right"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    }
    else {
       myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
 
    }
        self.navigationItem.leftBarButtonItem = myBackButton;
    favouriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,-1,44,44)];
    [favouriteBtn setImage:[UIImage
                            imageNamed:@"fav"] forState:UIControlStateNormal];
    favouriteBtn.tag = 0;
    [favouriteBtn addTarget:self action:@selector(favoriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    favouriteBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *favButton = [[UIBarButtonItem alloc] initWithCustomView:favouriteBtn];
    UIView *titltViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
    titltViewContainer.backgroundColor = [UIColor clearColor];
    imageCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(25,-3,60,40)];
    imageCountLbl.backgroundColor = [UIColor clearColor];
    imageCountLbl.textColor = [UIColor whiteColor];
    imageCountLbl.font = [UIFont systemFontOfSize:18.0];
    imageCountLbl.textAlignment = NSTextAlignmentLeft;
//    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
//    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
//        imageCountLbl.textAlignment = NSTextAlignmentLeft;
//    }else {
//        imageCountLbl.textAlignment = NSTextAlignmentLeft;
//    }
    UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera"]];
    cameraIcon.frame = CGRectMake(0,7,20,20);
    cameraIcon.contentMode = UIViewContentModeCenter;
    [titltViewContainer addSubview:cameraIcon];
    [titltViewContainer addSubview:imageCountLbl];
  
    self.navigationItem.titleView = titltViewContainer;
    self.navigationItem.rightBarButtonItem = favButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.69 blue:0.69 alpha:1];
	self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:false];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [hud hideAnimated:true];
    [self.navigationController setNavigationBarHidden:true];
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
//    [self.adTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
//    [self updateCollectionViewLayoutWithSize:size];
//    self.adimageColectionView
}


- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    if (self.adimageColectionView){
        UICollectionViewFlowLayout *flowLayout = (id)self.adimageColectionView.collectionViewLayout;
        
        if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
            flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 176.f);
        } else {
            flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 176.f);
        }
        
        [flowLayout invalidateLayout];
//        [self.adimageColectionView reloadData];
        CGRect visibleRect = (CGRect){.origin = self.adimageColectionView.contentOffset, .size = self.adimageColectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [self.adimageColectionView indexPathForItemAtPoint:visiblePoint];
        NSArray* visibleCellIndex = self.adimageColectionView.indexPathsForVisibleItems;
        if (visibleCellIndex){
//            if (visibleCellIndex.count > 1){
//                NSIndexPath *visibleIndex1 = visibleCellIndex.firstObject;
//                NSIndexPath *visibleIndex2 = visibleCellIndex.lastObject;
//                
//                if(visibleIndex1.row < visibleIndex2.row){
//                    [self.adimageColectionView scrollToItemAtIndexPath:visibleCellIndex.firstObject
//                                                      atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                                              animated:YES];
//                }else{
//                    [self.adimageColectionView scrollToItemAtIndexPath:visibleCellIndex.lastObject
//                                                      atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                                              animated:YES];
//
//                }
//            }else{
                [self.adimageColectionView scrollToItemAtIndexPath:visibleCellIndex.lastObject
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                      animated:YES];
//            }
        }
        

    } //force the elements to get laid out again with the new size
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)indexValue:(int)index{
    if(adDetails.imageItems){
        NSUInteger count = adDetails.imageItems.count;
        imageCountLbl.text = [NSString stringWithFormat:@"%d/%lu",index + 1, (unsigned long)count];
    }
}

- (void)favoriteBtnClicked:(id)sender {
    DataClass *obj=[DataClass getInstance];
    if(obj.userToken==nil)
        [Utility showLogInAlertInController:self];
    else{
        
        if (adDetails.adInfo.idField){
            if (favouriteBtn.tag == 0){
                [self addOrRemovefavourite:adDetails.adInfo.idField isAdd:true];
                [self changeFavouriteBtnImage:true];
            }else{
                [self addOrRemovefavourite:adDetails.adInfo.idField isAdd:false];
                [self changeFavouriteBtnImage:false];
            }
        }
    }
}

- (void)changeFavouriteBtnImage:(BOOL)isFavourite {
    if (isFavourite == true){
        favouriteBtn.tag = 1;
        [favouriteBtn setImage:[UIImage imageNamed:@"fav_selected"] forState:UIControlStateNormal];
    }else{
        favouriteBtn.tag = 0;
        [favouriteBtn setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    }
}


- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    CGRect rect = self.navigationController.navigationBar.frame;
//    float y = rect.size.height + rect.origin.y;
////    self.adTableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
//}

-(IBAction)sellAllAdsButtonClicked{
    
    
    SeeAllAdsViewController *ad = [self.storyboard instantiateViewControllerWithIdentifier:@"SeeAllAdsViewController"];
    ad.user_ID = adDetails.adInfo.userId;
//      fav.hidesBottomBarWhenPushed = true;
//          [self.navigationController.navigationBar setHidden:false];
    [self.navigationController pushViewController:ad animated:true];
    
}

-(IBAction)reportButtonClicked{
    DataClass *obj=[DataClass getInstance];
    if(obj.userToken==nil)
        [Utility showLogInAlertInController:self];
    else
        [self addingReportAlert];
}

-(void)addingReportAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Bayie\n" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"reason";
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = [[alertController textFields][0] text];
        if (text.length > 0){
            text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
            if (text.length == 0){
                [self showWarningAlert];
            }else{
                [self sendReport:text];
            }
        }else{
            [self showWarningAlert];
        }
        //compare the current password and do action here
        
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showWarningAlert{
    UIAlertController * alert =[UIAlertController
                                alertControllerWithTitle:@"Bayie" message:@"Please enter valid text" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIView Action

-(IBAction)chatButtonClicked{
    DataClass *dataClass = [DataClass getInstance];
    if(dataClass.userToken !=nil){
        
        ChatDetailViewController *chatDetailPage = [[UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chatDetail"];
        ChatModel *chatModel = [[ChatModel alloc] init];
        chatModel.from_user_id = [DataClass getInstance].userId;
        chatModel.to_user_id = adDetails.adInfo.userId;
        chatModel.ad_id = adDetails.adInfo.adId;
        chatModel.ad_image =  adDetails.defaultImage;
        chatModel.seller_user_name = adDetails.adInfo.postedBy;
        chatModel.buyer_user_name = adDetails.adInfo.title;
        chatModel.chatTitle = adDetails.adInfo.postedBy;
        chatModel.last_message = adDetails.adInfo.createdDate;
        chatModel.seller_profile_image = [NSString stringWithFormat:@"%@%@",adDetails.imageBaseUrl,adDetails.adInfo.userProfileImage];
        chatDetailPage.chatModel = chatModel;
        
        
        if (adDetails.imageItems.count > 0){
            ImageItem * imageInfo = adDetails.imageItems.firstObject;
            NSString *url = imageInfo.imageUrl;
            NSString *uRLString = [adDetails.imageBaseUrl stringByAppendingString:url];
            chatModel.ad_image =  uRLString;
        }
        
        [self.navigationController pushViewController:chatDetailPage animated:1];
    }
    else{
        [Utility showLogInAlertInController:self];
    }

}



-(IBAction)shareAdButtonClicked{
    // grab an item we want to share
    NSString *shareData = @"";
    if (adDetails.shareUrl){
        shareData = adDetails.shareUrl;
    }
    
    NSArray *items = @[shareData];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentViewController:controller animated:YES completion:^{
        // executes after the user selects something
    }];
}

-(IBAction)callCustomerButtonClicked{
    if(adDetails.adInfo.mobileNumber){
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",adDetails.adInfo.mobileNumber]];
        UIApplication *application = [UIApplication sharedApplication];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:phoneUrl options:@{}
               completionHandler:^(BOOL success) {
                   NSLog(@"Open %@: %d",adDetails.adInfo.mobileNumber,success);
               }];
        } else {
            BOOL success = [application openURL:phoneUrl];
            NSLog(@"Open %@: %d",adDetails.adInfo.mobileNumber,success);
        }
    }
}

#pragma mark - UITable View DataSource and Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if( adDetails ){
        if(adDetails.adAttributes){
            if (adDetails.adAttributes.count > 0) {
                return 3;
            }else{
                noAttirbuteValues = true;
                return 2;
            }
        }else{
            noAttirbuteValues = true;
            return 2;
        }
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section  == 0){
        if( adDetails ){
            return 6;
        }else {
            return 0;
        }
    }
    else if(section == 1){
        if(noAttirbuteValues == true){
            return 4;
        }else{
            return adDetails.adAttributes.count;
        }
    }
    else{
        return 4;
    }
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section  == 0){
        if (indexPath.row == 0) {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                return 340;
            else
                return 240;
        }
        else if (indexPath.row == 1) {
             return UITableViewAutomaticDimension;//return 105;
        }
        else if (indexPath.row == 2) {
            return UITableViewAutomaticDimension;
        }
        else if (indexPath.row == 3) {
            return 83;
        }
        else if (indexPath.row == 8) {
            return 103;
        }
        else{
            return 51;
        }
    }
    if (indexPath.section  == 1){
        if(noAttirbuteValues == true){
            if (indexPath.row == 0) {
                return 44;
            }
            if (indexPath.row == 1) {
                return 150;
            }
            else if (indexPath.row == 2) {
                return 44;
            }
            else if (indexPath.row == 3) {
                return 60;
            }
            return 44;
        }else{
            return 44;
        }
    }
    else{
        if (indexPath.row == 0) {
            return 44;
        }
        if (indexPath.row == 1) {
            return 150;
        }
        else if (indexPath.row == 2) {
            return 44;
        }
        else if (indexPath.row == 3) {
            return 60;
        }
        return 44;
    }
}

-(UITableViewCell *)getSummryCell{
    AdSummaryTableViewCell *summaryCell = [self.adTableView dequeueReusableCellWithIdentifier:@"AdSummaryCell"];
    if (adDetails.adInfo.title){
        summaryCell.adSummaryLbl.text = [Utility tripJSONResidue:adDetails.adInfo.title];
    }
    if (adDetails.adInfo.price){
//        NSString *priceVal = adDetails.adInfo.price;
			NSString *price = [Utility tripJSONResidue:adDetails.adInfo.price];
			if ([price isKindOfClass:[NSString class]] && price.length > 0 ){
				price = [NSString stringWithFormat:@"%@ OMR", price];
			}
			summaryCell.priceLbl.text = [Utility tripJSONResidue:price];
    }
    NSString *adInfo = @"by ";
    if (adDetails.adInfo.postedBy){
        adInfo = [adInfo stringByAppendingString:adDetails.adInfo.postedBy];
    }
    if (adDetails.adInfo.adTime){
        adInfo = [adInfo stringByAppendingString:@" | "];
        adInfo = [adInfo stringByAppendingString:adDetails.adInfo.adTime];
    }
    if (adDetails.adInfo.location){
        adInfo = [adInfo stringByAppendingString:@" | "];
        adInfo = [adInfo stringByAppendingString:adDetails.adInfo.location];
    }
    summaryCell.userDetaisLbl.text = [Utility tripJSONResidue:adInfo];
    
    return summaryCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    UITableViewCell *cell;
    if (indexPath.section  == 0){
        if (indexPath.row == 0){
            ImageColectionViewTableViewCell *adImageCell = [tableView dequeueReusableCellWithIdentifier:@"AdImagesCell"];
//            [adImageCell.imageCollectionView.collectionViewLayout invalidateLayout];
            adImageCell.imageCollectionView.pagingEnabled = true;
            self.adimageColectionView = adImageCell.imageCollectionView;
            adImageCell.imageDataArray = adDetails.imageItems;
            if (adDetails.imageItems){
                if (adDetails.imageItems.count < 1){
                    if (adDetails.imageBaseUrl){
                        ImageItem * imageItemsItem = [[ImageItem alloc] init];
                        imageItemsItem.imageUrl = adDetails.imageBaseUrl;
                        imageItemsItem.isDefault = true;
                        adImageCell.imageDataArray = [[NSArray alloc] initWithObjects:imageItemsItem, nil];
                        imageCountLbl.text = @"1/1";
                    }
                }
            }else{
                if (adDetails.imageBaseUrl){
                    ImageItem * imageItemsItem = [[ImageItem alloc] init];
                    imageItemsItem.imageUrl = adDetails.imageBaseUrl;
                    imageItemsItem.isDefault = true;
                    adImageCell.imageDataArray = [[NSArray alloc] initWithObjects:imageItemsItem, nil];
                    imageCountLbl.text = @"1/1";
                }
            }
            adImageCell.defalutImageUrl = adDetails.defaultImage;
            adImageCell.delegate = self;
            adImageCell.imageBaseUrl = adDetails.imageBaseUrl;
            [adImageCell showImages];
            
            return adImageCell;
        }
        else if (indexPath.row == 1){
            return [self getSummryCell];
        }
        else if (indexPath.row == 2){
            DescriptionTableViewCell *decrCell = [tableView dequeueReusableCellWithIdentifier:@"AdDescriptionCell"];
            if (adDetails.adInfo.descriptionField){
							
							decrCell.descLbl.text = [Utility tripJSONResidue:adDetails.adInfo.descriptionField];
            }
            return decrCell;
        }
        else if (indexPath.row == 3){
            AdDeatilsHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"AdDetailsHeaderCell"];
            if (adDetails.adInfo.itemCondition){
                headerCell.valuLabel.text = [Utility tripJSONResidue:adDetails.adInfo.itemCondition];
            }
            else{
                if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                    headerCell.valuLabel.text = @"غير قابل للتطبيق";
                }else {
                    headerCell.valuLabel.text = @"NA";
                }
            }
            return headerCell;
        }
        
        else{
            UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
            
            switch (indexPath.row) {
                case 4:{
                    AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
                    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                        propertyCell.titleLbl.text = @"الفئة";
                    }else {
                        propertyCell.titleLbl.text = @"Category";
                    }
                    
                    if (adDetails.adInfo.categoryName){
                        propertyCell.valuLabel.text = [Utility tripJSONResidue:adDetails.adInfo.categoryName];
                    }
                    else{
                        propertyCell.valuLabel.text = @"";
                    }
                    
                    return propertyCell;
                    break;
                }
                case 5:
                {
                    AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
                    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                        propertyCell.titleLbl.text = @"السعر";
                    }else {
                        propertyCell.titleLbl.text = @"Price";
                    }
                    if (adDetails.adInfo.price){
                        NSString *price = [Utility tripJSONResidue:adDetails.adInfo.price];
                        if ([price isKindOfClass:[NSString class]] && price.length > 0 ){
                            if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                                price = [NSString stringWithFormat:@"ريال عماني %@", price];
                            }else {
                                price = [NSString stringWithFormat:@"%@ OMR", price];
                            }
                            
                        }
                        else{
                            NSString *notAvaiString = @"";
                            if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                               notAvaiString = @"غير قابل للتطبيق";
                            }else {
                                notAvaiString = @"NA";
                            }
                            price = notAvaiString;
                        }
                        propertyCell.valuLabel.text = price;
                    }
                    else{
                        propertyCell.valuLabel.text = @"";
                    }
                    
                    return propertyCell;
                    break;
                }
                    
                case 6:
                {
                    AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
                    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                        propertyCell.titleLbl.text = @"اسم العلامة التجارية";
                    }else {
                        propertyCell.titleLbl.text = @"Brand Name";
                    }
                    if (adDetails.adInfo.categoryName){
                        propertyCell.valuLabel.text = [Utility tripJSONResidue:adDetails.adInfo.categoryName];
                    }
                    else{
                        propertyCell.valuLabel.text = @"";
                    }
                    return propertyCell;
                    break;
                }
                case 7:
                {
                    AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
                    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                        propertyCell.titleLbl.text = @"منشور من طرف";
                    }else {
                        propertyCell.titleLbl.text = @"Posted By";
                    }
                    if (adDetails.adInfo.postedBy){
                        propertyCell.valuLabel.text = [Utility tripJSONResidue:adDetails.adInfo.postedBy];
                    }
                    else{
                        propertyCell.valuLabel.text = @"";
                    }
                    return propertyCell;
                    break;
                }
                case 8:
                    listCell.textLabel.text = @"About";
                    break;
                    
                default:
                    listCell.textLabel.text = @"About";
                    break;
            }
            cell = listCell;
        }
    }
    else if (indexPath.section  == 1){
        if(noAttirbuteValues == true){
            if (indexPath.row == 0){
                AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
                propertyCell.titleLbl.text = @"Posted By";
                if (adDetails.adInfo.postedBy){
                    propertyCell.valuLabel.text = [Utility tripJSONResidue:adDetails.adInfo.postedBy];
                }
                else{
                    propertyCell.valuLabel.text = @"";
                }
                return propertyCell;
            }
            
            if (indexPath.row == 1){
                SellerDetailTableViewCell *sellerCell = [tableView dequeueReusableCellWithIdentifier:@"SellecerDetailsCell"];
                if (adDetails.adInfo.postedBy){
                    sellerCell.nameLbl.text = [Utility tripJSONResidue:adDetails.adInfo.postedBy];
                }
                if (adDetails.adInfo.memberSince){
                    NSString *memberSince = @"Member ";
                    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]) {
                        memberSince = @"عضو ";
                    }
                    memberSince = [memberSince stringByAppendingString:[self getyearFromStringDate:adDetails.adInfo.memberSince]];
                    sellerCell.dateSinceLbl.text = [Utility tripJSONResidue:memberSince];
                }
                if (adDetails.adInfo.userProfileImage){
                    NSString *userProfImageUrl = [NSString stringWithFormat:@"%@%@",adDetails.imageBaseUrl,adDetails.adInfo.userProfileImage];
                    [sellerCell.userImageView sd_setImageWithURL:[NSURL URLWithString:userProfImageUrl]];
                }
                return sellerCell;
            }
            else if (indexPath.row == 2){
                AdReportTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
                if (adDetails.adInfo.viewCount){
                    headerCell.adIdLbl.text = [NSString stringWithFormat:@" %@",[Utility tripJSONResidue:adDetails.adInfo.viewCount]];
                }
                return headerCell;
            }else{
                UITableViewCell *shareCell = [tableView dequeueReusableCellWithIdentifier:@"ShareAddCell"];
                return shareCell;
            }
        }else{
            AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
            if (indexPath.row < adDetails.adAttributes.count){
                AdAttribute *attribute = adDetails.adAttributes[indexPath.row];
                if (attribute.value){
                    propertyCell.valuLabel.text = [Utility tripJSONResidue:attribute.value];
									
									if([[Utility tripJSONResidue:attribute.value] isKindOfClass:[NSString class]] && [Utility tripJSONResidue:attribute.value].length > 0 && [attribute.attribute isKindOfClass:[NSString class]] && [attribute.attribute isEqualToString:@"Price"]) {
										
										propertyCell.valuLabel.text = [NSString stringWithFormat:@"%@ OMR",[Utility tripJSONResidue:attribute.value]];

									}
                }
                else{
                    propertyCell.valuLabel.text = @"";
                }
                if (attribute.attribute){
                    propertyCell.titleLbl.text = [Utility tripJSONResidue:attribute.attribute];
                }
                else{
                    propertyCell.titleLbl.text = @"";
                }
            }
            return propertyCell;
        }
    }
    else{
        if (indexPath.row == 0){
            AdPropertyTableViewCell *propertyCell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
            propertyCell.titleLbl.text = @"Posted By";
            if (adDetails.adInfo.postedBy){
                propertyCell.valuLabel.text = [Utility tripJSONResidue:adDetails.adInfo.postedBy];
            }
            else{
                propertyCell.valuLabel.text = @"";
            }
            return propertyCell;
        }
        
        if (indexPath.row == 1){
            SellerDetailTableViewCell *sellerCell = [tableView dequeueReusableCellWithIdentifier:@"SellecerDetailsCell"];
            if (adDetails.adInfo.postedBy){
                sellerCell.nameLbl.text = [Utility tripJSONResidue:adDetails.adInfo.postedBy];
            }
            if (adDetails.adInfo.memberSince){
                NSString *memberSince = @"Member Since ";
                memberSince = [memberSince stringByAppendingString:[self getyearFromStringDate:adDetails.adInfo.memberSince]];
                sellerCell.dateSinceLbl.text = [Utility tripJSONResidue:memberSince];
            }
            if (adDetails.adInfo.userProfileImage){
                [sellerCell.userImageView sd_setImageWithURL:[NSURL URLWithString:adDetails.adInfo.userProfileImage]];
            }
            return sellerCell;
        }
        else if (indexPath.row == 2){
            AdReportTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
            if (adDetails.adInfo.adId){
                headerCell.adIdLbl.text = [Utility tripJSONResidue:adDetails.adInfo.adId];
            }
            return headerCell;
        }else{
            UITableViewCell *shareCell = [tableView dequeueReusableCellWithIdentifier:@"ShareAddCell"];
            return shareCell;
        }
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    if (indexPath.row == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdCategory" bundle:[NSBundle mainBundle]];
        AdCategoryViewController *adCategoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"AdCategoryVC"];
        adCategoryViewController.delegate = self;
        [self.navigationController pushViewController:adCategoryViewController animated:YES];
    }
    if (indexPath.row > 1){
        if (selectedCategory){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdCategory" bundle:[NSBundle mainBundle]];
            AdSubCategoryViewController *adSubCategoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"AdSubCategoryVC"];
            adSubCategoryViewController.categoryId = selectedCategory.idField;
            adSubCategoryViewController.delegate = self;
            [self.navigationController pushViewController:adSubCategoryViewController animated:YES];
        }
    }
     */
}

#pragma CategroyDelegate
- (void)selectedCategory:(Category *)category{
    selectedCategory =  category;
}

#pragma SubCategroyDelegate

- (void)selectedSubCategory:(SubCategory *)subCategory{
    selectedSubCategory = subCategory;
}

-(NSString *)getyearFromStringDate:(NSString *)dateStr{
    NSArray *items = [dateStr componentsSeparatedByString:@"-"];
    if (items){
        return items.firstObject;
    }else{
        return @"";
    }
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)getAdDetailsFromServer{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"adDetails"];
    //    DataClass *obj=[DataClass getInstance];
    
    NSDictionary *parameters =  @{@"adId":self.adId,@"language":[DataClass currentLanguageString]};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    DataClass *obj=[DataClass getInstance];
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
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
                
                if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    
                }
                else{
                    //                    if([responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    adDetails = [[Advertisement alloc] initWithDictionary:responseDict];
                    //                    if([responseDict[@"images"] isKindOfClass:[NSArray class]]){
                    //                        [adDetails addImages:responseDict[@"images"]];
                    //                    }
                    [self.adTableView reloadData];
                    [self displayVideoView:[responseDict valueForKey:@"images"]];
                    if(adDetails.imageItems){
                        NSUInteger count = adDetails.imageItems.count;
                        imageCountLbl.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)count];
                        [self changeFavouriteBtnImage:self->adDetails.adInfo.isFavourite];
                    }
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
    
}

-(void)displayVideoView:(NSArray *)imagesArray{
    NSPredicate *videoPredicate = [NSPredicate predicateWithFormat:@"SELF.type == %@",@"video"];
    NSArray *filteredArray = [imagesArray filteredArrayUsingPredicate:videoPredicate];
    if (filteredArray.count>0){
        id videoDetails = filteredArray.firstObject;
        self.videoUrlString = [videoDetails valueForKey:@"video_url"];
    }
}

-(void)addOrRemovefavourite:(NSString *)adID isAdd:(BOOL)status{
        DataClass *obj=[DataClass getInstance];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
        
        NSString *URLString = [AdBaseUrl stringByAppendingString:@"addToFavourite"];
        if (status == true){
            
        }else{
            URLString = [AdBaseUrl stringByAppendingString:@"removeFavourite"];
        }
        
        
        NSDictionary *parameters =  @{@"adId":adID,@"userToken":obj.userToken};
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
                //            favouriteBtn.tag = 1;
                NSLog(@"Reply JSON: %@", responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSLog(@"Response == %@",responseObject);
                }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *responseDict = responseObject;
                    
                    if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                            
                            NSString *msg = @"Added as favorite";
                            if (!status) {
                                msg = @"Removed from favorite";
                            }
                            UIAlertController * alert =[UIAlertController
                                                        alertControllerWithTitle:@"Bayie" message:msg preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* okButton = [UIAlertAction
                                                       actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                       handler:nil];
                            [alert addAction:okButton];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                        });
                        
                        
                    }
                    else{
                        //                    if([responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                        adDetails = [[Advertisement alloc] initWithDictionary:responseDict];
                        //                    if([responseDict[@"images"] isKindOfClass:[NSArray class]]){
                        //                        [adDetails addImages:responseDict[@"images"]];
                        //                    }
                        [self.adTableView reloadData];
                        if(adDetails.imageItems){
                            NSUInteger count = adDetails.imageItems.count;
                            imageCountLbl.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)count];
                            
                        }
                    }
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    
                    UIAlertController * alert =[UIAlertController
                                                alertControllerWithTitle:@"Bayie" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:nil];
                    [alert addAction:okButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                });
                
                
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            }
            [hud hideAnimated:YES];
        }]resume];
    
}

-(void)sendReport:(NSString *)report{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"reportAbuse"];
    DataClass *obj=[DataClass getInstance];
    
    NSDictionary *parameters =  @{@"adId":adDetails.adInfo.adId,@"userId":obj.userId,@"report":report,@"language":[DataClass currentLanguageString]};
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
            //            favouriteBtn.tag = 1;
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                
                if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    
                }
                else{
                  
                }

							dispatch_async(dispatch_get_main_queue(), ^{
								[hud hideAnimated:YES];

								UIAlertController * alert =[UIAlertController
																						alertControllerWithTitle:@"Bayie" message:@"Ad has been reported " preferredStyle:UIAlertControllerStyleAlert];
								
								UIAlertAction* okButton = [UIAlertAction
																					 actionWithTitle:@"OK"
																					 style:UIAlertActionStyleDefault
																					 handler:nil];
								[alert addAction:okButton];
								
								[self presentViewController:alert animated:YES completion:nil];
							});
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
					dispatch_async(dispatch_get_main_queue(), ^{
						[hud hideAnimated:YES];
						UIAlertController * alert =[UIAlertController
																				alertControllerWithTitle:@"Bayie" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
						
						UIAlertAction* okButton = [UIAlertAction
																			 actionWithTitle:@"OK"
																			 style:UIAlertActionStyleDefault
																			 handler:nil];
						[alert addAction:okButton];
						
						[self presentViewController:alert animated:YES completion:nil];
					});
        }
        [hud hideAnimated:YES];
    }]resume];
    
}
-(void)imageSelected:(NSInteger)index images:(NSArray*)imageURLs andImageView:(UIImageView *)imageView{
    [self addingFullImageControllerWithImagae:imageView.image withImageView:imageView];
}

-(void)selectedWithVideo:(NSString *)videoUrlString{
    VideoVC *videoVC = [[VideoVC alloc] initWithNibName:@"VideoVC" bundle:nil
                        ] ;
    videoVC.videoUrl = videoUrlString;
    UINavigationController *videoNavntlr = [[UINavigationController alloc] initWithRootViewController:videoVC];
    [self presentViewController:videoNavntlr animated:true completion:nil];
}

-(void)addingFullImageControllerWithImagae:(UIImage *)fullImage withImageView:(UIImageView *)imageView{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}



@end
