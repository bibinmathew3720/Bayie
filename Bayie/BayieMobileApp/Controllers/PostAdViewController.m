//
//  PostAdViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 29/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "PostAdViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SubCategoryViewController.h"
#import "BayieHub.h"

//NSString *cat_Imageurl = @"http://www.productiondemos.com/bayie";

@interface PostAdViewController (){
    NSArray *categoryDataArray;
    NSDictionary *categoryDataDict;
    NSString *cat_name;
    NSString *cat_img;
    NSString *cat_id;
    NSString *cat_Imageurl;
    NSString *defaultcat_Imageurl;
    MBProgressHUD *hud;

}

@end

@implementation PostAdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    
    [self categoryList];

    //   [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    UITabBarController *tabBarController = self.tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:2];
    tabBarItem.selectedImage = [[UIImage imageNamed:@"camera-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem.image = [[UIImage imageNamed:@"camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        UITextAttributeFont : [UIFont fontWithName:@"Lato-Regular" size:10.0f],
                                                        UITextAttributeTextColor : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],}
                                             forState:UIControlStateNormal];
    
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
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40; // customize the height
//}

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
    [self performSegueWithIdentifier:@"SubCat" sender:self];
    
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
@end
