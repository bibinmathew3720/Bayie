//
//  WinHistoryVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/30/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "Utility.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "WinHistoryVC.h"
#import "MBProgressHUD.h"
#import "WinHistoryResponseModel.h"

#import "BidHistoryCell.h"
#import "BidHistoryHeaderView.h"

@interface WinHistoryVC ()<UITableViewDataSource,UITableViewDelegate,BidHistoryHeaderViewDelegate>{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UITableView *winHistoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *idHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *productheadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyHeadingLabel;
@property (nonatomic, assign) NSInteger selectedSectionIndex;

@property (nonatomic, strong) NSMutableArray *winHistoryResponseArray;
@end

@implementation WinHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    [self localisation];
    [self callinGetWinHistoryApi];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialisation{
    self.selectedSectionIndex = -1;
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
    self.title = NSLocalizedString(@"AUCTIONWINS", @"AUCTION WINS");
}

-(void)localisation{
    self.idHeadingLabel.text = NSLocalizedString(@"ID", @"ID");
    self.productheadingLabel.text = NSLocalizedString(@"Product", @"Product");
    self.historyHeadingLabel.text = NSLocalizedString(@"History", @"History");
}


#pragma mark - Calling Win History Api

-(void)callinGetWinHistoryApi{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"auctionWinHistory"];
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
                    if (![responseObject[@"data"] isKindOfClass:[NSNull class]]){
                        NSArray *historyArray = [responseObject valueForKey:@"data"];
                        self.winHistoryResponseArray = [[NSMutableArray alloc] init];
                        for (NSDictionary *item in historyArray){
                            [self.winHistoryResponseArray addObject:[[WinHistoryResponseModel alloc] initWithWinHistoryResponse:item]];
                        }
                        [self.winHistoryTableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.selectedSectionIndex)
        return 1;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidHistoryCell *cell = (BidHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"bidHistory"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BidHistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //        BidHistoryResponseModel *bidHistoryResponse = [self.bidHistoryResponseArray objectAtIndex:indexPath.section];
    //        cell.bidHistory = [bidHistoryResponse.bidHistoryarray objectAtIndex:(indexPath.row-1)];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BidHistoryHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BidHistoryHeaderView" owner:self options:nil] firstObject];
    headerView.winHistoryResponse = [self.winHistoryResponseArray objectAtIndex:section];
    headerView.bidHistoryHeaderDelegate = self;
    headerView.tag = section;
    headerView.pageType = PageTypeWinHistory;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Bid History Header View Delegates

-(void)viewHistoryButtonActionDelegateWithTag:(NSInteger)tag{
    if (tag == self.selectedSectionIndex){
        self.selectedSectionIndex = -1;
    }
    else{
        self.selectedSectionIndex = tag;
    }
    [self.winHistoryTableView reloadData];
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
