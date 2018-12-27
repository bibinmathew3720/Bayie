//
//  SortViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 11/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SortViewController.h"
#import "ListingViewController.h"
#import "DataClass.h"

@interface SortViewController ()
{
    NSArray *sortArray;
    NSString *sortTypeSelected;
}
@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.sortTableView.tableFooterView = [UIView new];
    //To show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    sortArray = @[NSLocalizedString(@"RECENT", nil),NSLocalizedString(@"LOWEST", nil),NSLocalizedString(@"HIGHEST", nil)];
    
     [_cancelButton setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
}

// showing status bar

- (BOOL)prefersStatusBarHidden {
    return NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_sortTableView setContentOffset:CGPointZero animated:YES];

    UITabBarController *tabBarController = self.tabBarController;
    tabBarController.tabBar.hidden = true;
}



//(Here three types of sorting available. 1. Recent Ads, 2. Price Low, 3.Price High)
//sort (Recent, Price Low, Price High)

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sortArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"SortCell";
    CustomSortTableViewCell *sortCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    sortCell.sortLabel.text = sortArray[indexPath.row];
    return sortCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = [indexPath row];

    if (row == 0) {
        sortTypeSelected = @"created_desc";
    }else if(row == 1){
        sortTypeSelected = @"price_asc";

    }else if(row == 2){
        sortTypeSelected = @"price_desc";

    }
    
    DataClass *obj=[DataClass getInstance];
    obj.isFromSort= true;
    obj.sortType = sortTypeSelected;
//    ListingViewController *destlist;

//    destlist.fromSort = true;
 //   destlist.sortType = sortTypeSelected;
 //   [self dismissViewControllerAnimated:YES completion:nil];
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortTypeSelectedDelegate)]){
        [self.sortDelegate sortTypeSelectedDelegate];
    }
   [self.navigationController popViewControllerAnimated:YES];
//[self performSegueWithIdentifier:@"FromSort" sender:self];

}
- (IBAction)backButton:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
// [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)cancelButton:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
//   [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FromSort"]) {
      //  ListingViewController *destlist;
        //= (ListingViewController *)segue.destinationViewController;
        
    //    UINavigationController *nav = segue.destinationViewController;
     //   ListingViewController *destlist = (ListingViewController *)nav.topViewController;
        
 

}
*/

@end
