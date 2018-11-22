//
//  SubCategoryViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 13/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "CustomSubCategoryTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "BayieHub.h"


@interface SubCategoryViewController ()
{
    NSString *categoryName;
    NSString *categoryImgUrl;
    NSArray *subcategoryDataArray;
    NSDictionary *subcategoryDataDict;
    MBProgressHUD *hud;

}
@end

@implementation SubCategoryViewController
@synthesize categoryTitle,catImageurl,catID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    
    NSLog(@"%@", categoryTitle);
    NSLog(@"%@", catImageurl);
    NSLog(@"%@", catID);
    _catName.text = categoryTitle;
    self.upButton.hidden = true;
    _catImage.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:catImageurl]]];
    [self lisSubCat];
    [self updateUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateUI];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gotBayieAPIData:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            subcategoryDataArray = responseDict[@"data"];
            NSLog(@"%@", subcategoryDataArray);
        }   else if (![errormsg isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
        }
        [self.subCatTableView reloadData];
        [hud hideAnimated:YES];
  
    }
}
-(void)updateUI{
//    int itemIndex = 2;
//    UIColor* bgColor = [UIColor colorWithRed:(0/255.f) green:(178/255.f) blue:(176/255.f) alpha:1];
    //    UITabBarController *tabBarController = self.tabBarController;
//    float itemWidth = self.tabBar.frame.size.width / 5.0f; //5 = tab bar items
//    UIView* bgView = [[UIView alloc]initWithFrame: CGRectMake(itemWidth * itemIndex , 0,itemWidth, self.tabBar.frame.size.height)];
//    bgView.backgroundColor = bgColor;
//    [self.tabBar insertSubview:bgView atIndex:itemIndex];
    self.tabBar.alpha = 3.0;
}

-(void)lisSubCat{
    
   hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSError *error;
    NSDictionary *parameters =  @{@"category":catID,@"language":@"English"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"subCategory"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return subcategoryDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SubCatCell";
    subcategoryDataDict = [subcategoryDataArray objectAtIndex:indexPath.row];
    CustomSubCategoryTableViewCell *subCatCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    subCatCell.subCatLabel.text = [subcategoryDataDict valueForKey:@"category_name"];
    
    return subCatCell;
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [hud hideAnimated:YES];
}

@end
