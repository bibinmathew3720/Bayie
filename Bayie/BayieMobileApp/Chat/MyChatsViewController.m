//
//  MyChatsViewController.m
//  BayieMobileApp
//
//  Created by Swati on 03/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "MyChatsViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "ChatModel.h"
#import "ChatListCell.h"
#import "ChatDetailViewController.h"
@interface MyChatsViewController ()
{
    __weak IBOutlet UITableView* tblView;
    __weak IBOutlet UISegmentedControl* segControl;
    NSMutableArray* filteredChatArr;
    NSArray* allChatArr;
}
@end

@implementation MyChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    tblView.estimatedRowHeight = 100;
    //[self navigationCustomization];
    [self getMyChatList];
    tblView.rowHeight = UITableViewAutomaticDimension;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(UIButton *)sender {
    if(self.isFromNotification)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)segmentChanged:(UISegmentedControl*)sender{
    [filteredChatArr removeAllObjects];
    switch (sender.selectedSegmentIndex) {
        case 0:
            [filteredChatArr addObjectsFromArray:allChatArr];
            break;
        case 1:
            [filteredChatArr addObjectsFromArray:[allChatArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSeller == YES"]]];
            break;
        case 2:
            [filteredChatArr addObjectsFromArray:[allChatArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSeller == NO"]]];
            break;
            
        default:
            break;
    }
    [tblView reloadData];
}
-(void)getMyChatList{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [MessageBaseUrl stringByAppendingString:@"messageGroupLists"];
    DataClass *obj=[DataClass getInstance];
    //obj.userToken = @"b48641eb7cd3c4a6c3f874991488f780ce193aa9"; //b4b584cd2469f224e8499cfbfa96b180715e2dba
    NSDictionary *parameters =  @{@"userToken":obj.userToken,@"language":[DataClass currentLanguageString]};
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
                
                if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    filteredChatArr = [NSMutableArray new];
                    for (NSDictionary* dict in responseDict[@"data"]) {
                        [filteredChatArr addObject:[[ChatModel alloc] initWithDictionary:dict error:nil]];
                    }
                    allChatArr = [NSArray arrayWithArray:filteredChatArr];
                    [tblView reloadData];
                }
                else{
                    
                    NSLog(@"Response == %@",responseDict);
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


#pragma mark - TableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredChatArr.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [categoryCell configureCell:filteredChatArr[indexPath.row]];
    return categoryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ChatDetailViewController* chatDetailPage = [self.storyboard instantiateViewControllerWithIdentifier:@"chatDetail"];
    chatDetailPage.chatModel = filteredChatArr[indexPath.row];
		chatDetailPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatDetailPage animated:1];
    
}
@end
