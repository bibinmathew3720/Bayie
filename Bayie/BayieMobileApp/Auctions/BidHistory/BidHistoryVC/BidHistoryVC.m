//
//  BidHistoryVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "Constant.h"
#import "BidHistoryVC.h"

@interface BidHistoryVC ()

@end

@implementation BidHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialisation{
    UIBarButtonItem *myBackButton;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:ArabicBackArrowImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    }
    else {
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BackArrowImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
        
    }
    self.navigationItem.leftBarButtonItem = myBackButton;
    self.title = NSLocalizedString(@"AUCTIONHISTORY", @"AUCTION HISTORY");
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
