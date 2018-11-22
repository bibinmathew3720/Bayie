


//
//  AdCategoryViewController.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 05/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "AdCategoryViewController.h"
#import "AdCategoryTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "AdCategory.h"

@interface AdCategoryViewController (){
    AdCategory *catgoryDetails;

}
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation AdCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Catgeory";
    [self navigationCustomization];
    self.categoryTableView.tableFooterView = [UIView new];
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
    if( catgoryDetails ){
        if(catgoryDetails.category){
            if (catgoryDetails.category.count > 0){
                return catgoryDetails.category.count;
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
    AdCategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    if (catgoryDetails.category.count > indexPath.row){
        Category *categoryObj = catgoryDetails.category[indexPath.row];
        if (categoryObj.categoryName){
            categoryCell.categoryNameLbl.text = categoryObj.categoryName;
        }else{
            categoryCell.categoryNameLbl.text = @"";
        }
        if (categoryObj.mobileIcon){
            if (!catgoryDetails.baseUrl){
                catgoryDetails.baseUrl = @"";
            }
            NSString *URLString = [catgoryDetails.baseUrl stringByAppendingString:categoryObj.mobileIcon];
            URLString = [URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [categoryCell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:URLString]];
        }else{
            if (catgoryDetails.defaultImage){
                [categoryCell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:catgoryDetails.defaultImage]];
            }
        }
    }
    return categoryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([self.delegate respondsToSelector:@selector(selectedCategory:)]) {
        if (catgoryDetails.category.count > indexPath.row){
            [self.delegate selectedCategory: catgoryDetails.category[indexPath.row]];
            [self.navigationController popViewControllerAnimated:true];
        }
    }

}

-(void)getAdCategoryFromServer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [AdBaseUrl stringByAppendingString:@"category"];
    //    DataClass *obj=[DataClass getInstance];
    
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
                catgoryDetails = [[AdCategory alloc] initWithDictionary:responseDict];
                [self.categoryTableView reloadData];
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
    
}

@end
