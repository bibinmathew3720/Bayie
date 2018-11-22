

//
//  AdSubCategoryViewController.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 05/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "AdSubCategoryViewController.h"
#import "AdSubCategoryTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "SubCategory.h"


@interface AdSubCategoryViewController (){
    AdSubCategory *subCatgoryDetails;
}
@property (weak, nonatomic) IBOutlet UITableView *subCategoryTableView;
@end

@implementation AdSubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Sub Catgeory";
    [self navigationCustomization];
    self.subCategoryTableView.tableFooterView = [UIView new];
    [self getAdCategoryFromServer];

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( subCatgoryDetails ){
        if(subCatgoryDetails.subCategory){
            if (subCatgoryDetails.subCategory.count > 0){
                return subCatgoryDetails.subCategory.count;
            }
            return 0;
        }else {
            return 0;
        }
    }else {
        return 0;
    }

    }



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdSubCategoryTableViewCell *subCategoryCell = [tableView dequeueReusableCellWithIdentifier:@"SubCategoryCell"];
    if (subCatgoryDetails.subCategory.count > indexPath.row){
        SubCategory *categoryObj = subCatgoryDetails.subCategory[indexPath.row];
        if (categoryObj.categoryName){
            subCategoryCell.subCategoryNameLbl.text = categoryObj.categoryName;
        }else{
            subCategoryCell.subCategoryNameLbl.text = @"";
        }

    }
    return subCategoryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([self.delegate respondsToSelector:@selector(selectedSubCategory:)]) {
        if (subCatgoryDetails.subCategory.count > indexPath.row){
            [self.delegate selectedSubCategory: subCatgoryDetails.subCategory[indexPath.row]];
            [self.navigationController popViewControllerAnimated:true];
        }
    }
    
}

-(void)getAdCategoryFromServer{
    
    if (!self.categoryId){
        return;
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
        
        NSString *URLString = [AdBaseUrl stringByAppendingString:@"subCategory"];
        //    DataClass *obj=[DataClass getInstance];
        
        NSDictionary *parameters =  @{@"category":self.categoryId,@"language":[DataClass currentLanguageString]};
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
                    subCatgoryDetails = [[AdSubCategory alloc] initWithDictionary:responseDict];
                    [self.subCategoryTableView reloadData];
                }
            } else {
                
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            }
            [hud hideAnimated:YES];
        }]resume];
    }
    
}

@end
