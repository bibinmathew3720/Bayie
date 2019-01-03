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

#import "BidHistoryHeaderView.h"
#import "ShippingAddressTVC.h"
#import "ShippingAddressEditTVC.h"

@interface WinHistoryVC ()<UITableViewDataSource,UITableViewDelegate,BidHistoryHeaderViewDelegate,ShippingAddressTVCDelegate,ShippingAddressEditTVCDelegate>{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UITableView *winHistoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *idHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *productheadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyHeadingLabel;
@property (nonatomic, assign) NSInteger selectedSectionIndex;
@property (nonatomic, assign) NSInteger selectedEditSection;

@property (nonatomic, strong) NSMutableArray *winHistoryResponseArray;
@end

@implementation WinHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    [self localisation];
    [self tableCellRegistration];
    [self callinGetWinHistoryApi];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialisation{
    self.winHistoryTableView.estimatedRowHeight = 100;
    self.winHistoryTableView.rowHeight = UITableViewAutomaticDimension;
    self.selectedSectionIndex = -1;
    self.selectedEditSection = -1;
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

-(void)tableCellRegistration{
    [self.winHistoryTableView registerNib:[UINib nibWithNibName:@"ShippingAddressTVC" bundle:nil]
                   forCellReuseIdentifier:@"shippingAddCell"];
    [self.winHistoryTableView registerNib:[UINib nibWithNibName:@"ShippingAddressEditTVC" bundle:nil]
                   forCellReuseIdentifier:@"shippingAddresEditCell"];
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
    return self.winHistoryResponseArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.selectedSectionIndex){
        if (section == self.selectedEditSection){
            return 2;
        }
        return 1;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        ShippingAddressTVC *cell = (ShippingAddressTVC *)[tableView dequeueReusableCellWithIdentifier:@"shippingAddCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShippingAddressTVC" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.winHistoryModel = [self.winHistoryResponseArray objectAtIndex:self.selectedSectionIndex];
        cell.shippingAddressTVCDelegate = self;
        cell.tag = indexPath.section;
        return cell;
    }
    else{
        ShippingAddressEditTVC *cell = (ShippingAddressEditTVC *)[tableView dequeueReusableCellWithIdentifier:@"shippingAddresEditCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShippingAddressEditTVC" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.winHistoryModel = [self.winHistoryResponseArray objectAtIndex:self.selectedSectionIndex];
        cell.tag = indexPath.section;
        cell.delegate = self;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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

#pragma mark - Shipping Address TableViewCell Delegate

-(void)editButtonActionWithTag:(NSInteger)tag{
    self.selectedEditSection = tag;
    [self.winHistoryTableView reloadData];
}

#pragma mark - Shipping Address Edit TableViewCell Delegates

-(void)closeButtonActionDelegateWithTag:(NSInteger)tag{
    self.selectedEditSection = -1;
    [self.winHistoryTableView reloadData];
}

-(void)saveBUttonActionDelegateWithTag:(NSInteger)tag andWinHistoryModel:(WinHistoryResponseModel *)model{
    [self updateShippingAddressWithModel:model atIndex:tag];
}

#pragma mark - Update Shipping Address Api

-(void)updateShippingAddressWithModel:(WinHistoryResponseModel *)model atIndex:(NSInteger)index{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"updateShippingAddress"];
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"auction_id":[NSString stringWithFormat:@"%d",model.auctionId],@"shipping_address":model.shippingAddress,@"location":model.shippingCity,@"shipping_zipcode":model.shippingZipCode};
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
//                        NSArray *historyArray = [responseObject valueForKey:@"data"];
//                        self.winHistoryResponseArray = [[NSMutableArray alloc] init];
//                        for (NSDictionary *item in historyArray){
//                            [self.winHistoryResponseArray addObject:[[WinHistoryResponseModel alloc] initWithWinHistoryResponse:item]];
//                        }
                        WinHistoryResponseModel *winModel = [self.winHistoryResponseArray objectAtIndex:index];
                        winModel.shippingAddress = model.shippingAddress;
                        winModel.shippingCity = model.shippingCity;
                        winModel.shippingZipCode = model.shippingZipCode;
                        self.selectedEditSection = -1;
                        [self.winHistoryTableView reloadData];
                        messageString = NSLocalizedString(@"ShippingAddressUpdatedSuccessfully", @"Shipping address updated successfully");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
