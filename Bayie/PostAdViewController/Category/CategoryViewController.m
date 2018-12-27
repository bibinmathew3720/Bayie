//
//  CategoryViewController.m
//  BayieMobileApp
//
//  Created by Apple on 03/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

//#define AllString @"All"

#import "DataClass.h"
#import "CategoryViewController.h"
#import "ListingViewController.h"

#import "CategoryTableViewCell.h"

@interface CategoryViewController ()<ListingViewControllerDelegate>

@property (nonatomic,strong) NSString * subCategoryString;
@property (nonatomic, strong) id selSubCategory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//For Category View Controller
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewHeightConstraint;
@property (nonatomic, strong) NSArray *parentSubCatArray;
@property (nonatomic, strong) id parentSelSubCategory;
@property (nonatomic, assign) BOOL isSubCat;
@property (nonatomic, strong) id parentDataClass;
@property (nonatomic, strong) NSString *allString;
@property (weak, nonatomic) IBOutlet UIImageView *backArrowImageView;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    [self customisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialisation{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        self.backArrowImageView.image = [UIImage imageNamed:ArabicBackArrowImageName];
    }
    self.allString = NSLocalizedString(@"All", @"All String");
    if(!self.isFromBrowseCategory){
        self.navigationView.hidden = YES;
        self.navigationViewHeightConstraint.constant = 0;
        self.parentSelSubCategory = nil;
    }
    else{
        self.parentDataClass = [NSDictionary dictionaryWithObjectsAndKeys:[DataClass getInstance].categoryId,@"id",[DataClass getInstance].categoryTitle,@"category_name", nil];
        self.dataArray = [self addAllOptionToCategoryArray:self.dataArray];
        [self.tableView reloadData];
    }
   
}

- (void)customisation {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - UIView Action

- (IBAction)customleftButtonAction:(UIButton *)sender {
    if(self.isSubCat){
        DataClass *obj = [DataClass getInstance];
        obj.categoryTitle = [self.parentDataClass valueForKey:@"category_name"];
        obj.categoryId = [self.parentDataClass valueForKey:@"id"];
        obj.category =   [self.parentDataClass valueForKey:@"id"];
        self.dataArray = [self addAllOptionToCategoryArray:self.parentSubCatArray];
        [self.tableView reloadData];
        self.isSubCat = NO;
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSMutableArray *)addAllOptionToCategoryArray:(NSArray *)subCatArray{
    NSMutableArray *catMutArray = [[NSMutableArray alloc] init];
    [catMutArray addObjectsFromArray:subCatArray];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.allString,@"category_name", nil];
    if(![catMutArray containsObject:dict])
        [catMutArray insertObject:dict atIndex:0];
    return catMutArray;
}

- (void)rightButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if(!self.isLocation)
        if(self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryViewControllerItem:clickedsubCategoryItem:andSubCAtegoryElement:)]) {
            [self.categoryDelegate categoryViewControllerItem:self clickedsubCategoryItem:self.subCategoryString andSubCAtegoryElement:self.selSubCategory];
        }
    
}

#pragma mark - UITableView  Datasource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(!self.isLocation) {
        cell.baseUrl = self.baseUrl;
        NSLog(@"%@",[self.dataArray objectAtIndex:indexPath.row]);
        cell.category = [self.dataArray objectAtIndex:indexPath.row];
    }else {
        cell.locationDetails = [self.dataArray objectAtIndex:indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFromBrowseCategory){
        self.selSubCategory = [self.dataArray objectAtIndex:indexPath.row];
        NSLog(@"Data Array:%@",self.dataArray);
         NSArray *tempArray = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sub_category"];
        if([tempArray count] != 0){
            if(![[self.selSubCategory valueForKey:@"category_name"] isEqualToString:self.allString]){
                self.parentSelSubCategory = self.selSubCategory;
                self.isSubCat = YES;
            }
            self.parentSubCatArray = self.dataArray;
            
            self.dataArray = [self addAllOptionToCategoryArray:tempArray];
            [self.tableView reloadData];
        }
        else {
            [self loadAdsListingVCWithCategoryDetails:self.selSubCategory];
        }
    }
    else if(self.isLocation){
        if(self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryViewControllerItem:clickedLocationItem:)]) {
            [self.categoryDelegate categoryViewControllerItem:self clickedLocationItem:[self.dataArray objectAtIndex:indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else if(!self.isSubCategory) {
        if(self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryViewControllerItem:clickedItem:)]) {
            [self.categoryDelegate categoryViewControllerItem:self clickedItem:[self.dataArray objectAtIndex:indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        self.selSubCategory = [self.dataArray objectAtIndex:indexPath.row];
        if([self.subCategoryString length] >0)
            self.subCategoryString = [NSString stringWithFormat:@"%@->%@",self.subCategoryString,[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"category_name"]];
        else
            self.subCategoryString = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"category_name"]];
        self.dataArray = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sub_category"];
        if([self.dataArray count] != 0)
            [self.tableView reloadData];
        else {
            if(self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryViewControllerItem:clickedsubCategoryItem:andSubCAtegoryElement:)]) {
                [self.categoryDelegate categoryViewControllerItem:self clickedsubCategoryItem:self.subCategoryString andSubCAtegoryElement:self.selSubCategory];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//Load Ad Listing Page

-(void)loadAdsListingVCWithCategoryDetails:(id)catDetails{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    UIStoryboard *storyboard;
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        if([DataClass isiPad]){
            storyboard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
        }else{
            storyboard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
        }
    }
    else{
        if([DataClass isiPad]){
            storyboard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
        }else{
            storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
            
        }
    }
    DataClass *obj=[DataClass getInstance];
    obj.isFromSort = false;
    if(![[self.selSubCategory valueForKey:@"category_name"] isEqualToString:self.allString])
    {
        obj.categoryTitle = [catDetails valueForKey:@"category_name"];
        obj.categoryId = [catDetails valueForKey:@"id"];
        obj.category =  [catDetails valueForKey:@"id"];
    }
    else{
        if(self.isSubCat){
            obj.categoryTitle = [self.parentSelSubCategory valueForKey:@"category_name"];
            obj.categoryId = [self.parentSelSubCategory valueForKey:@"id"];
            obj.category =  [self.parentSelSubCategory valueForKey:@"id"];
        }
        else{
            if(self.parentSelSubCategory==nil){
                obj.categoryTitle = [self.parentDataClass valueForKey:@"category_name"];
                obj.categoryId = [self.parentDataClass valueForKey:@"id"];
                obj.category =  [self.parentDataClass valueForKey:@"id"];
            }
        }
    }
    ListingViewController *listingVC = [storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"];
    listingVC.catID = obj.categoryId ;
    listingVC.catTitle = obj.categoryTitle;
    listingVC.listingDelegate = self;
    listingVC.pageType = self.pageType;
    [self.navigationController pushViewController:listingVC animated:YES];
}

#pragma mark - Listing View Delegate

-(void)backButtonAcionDelegateFromListingPage{

    if(self.parentSelSubCategory!=nil){
        DataClass *dataClass = [DataClass getInstance];
        dataClass.category = [self.parentSelSubCategory valueForKey:@"id"];
        dataClass.categoryId =[self.parentSelSubCategory valueForKey:@"id"];
        dataClass.categoryTitle = [self.parentSelSubCategory valueForKey:@"category_name"];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



@end
