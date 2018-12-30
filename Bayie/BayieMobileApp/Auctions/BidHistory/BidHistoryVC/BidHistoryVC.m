//
//  BidHistoryVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//
#import "Utility.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "BidHistoryVC.h"
#import "MBProgressHUD.h"
#import "BidHistoryResponseModel.h"

@interface BidHistoryVC (){
    MBProgressHUD *hud;
}
@property (nonatomic, strong) NSMutableArray *bidHistoryResponseArray;


@property (weak, nonatomic) IBOutlet UITableView *bidHistoryTableView;
@end

@implementation BidHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    [self callinGetBidHistoryApi];
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
    [myBackButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = myBackButton;
    self.title = NSLocalizedString(@"AUCTIONHISTORY", @"AUCTION HISTORY");
}

-(void)callinGetBidHistoryApi{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"auctionHistory"];
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString]};
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
                NSLog(@"Response:%@",responseObject);
                int statusCode = [[responseObject valueForKey:@"status"] intValue];
                NSString *messageString = @"";
                if (statusCode == 200){
                    NSLog(@"Response:%@",responseObject);
                    if (![responseObject[@"data"] isKindOfClass:[NSNull class]]){
                        NSArray *historyArray = [responseObject valueForKey:@"data"];
                        self.bidHistoryResponseArray = [[NSMutableArray alloc] init];
                        for (NSDictionary *item in historyArray){
                            [self.bidHistoryResponseArray addObject:[[BidHistoryResponseModel alloc] initWithBidHistoryResponse:item]];
                        }
                    }
                }
                else if(statusCode == 204){
                    messageString = [responseObject valueForKey:@"error"];
                }
                if (messageString.length>0){
                    [Utility showAlertInController:self withMessageString:messageString withCompletion:^(BOOL isCompleted) {
                        
                    }];
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Datasources and Delegates



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
