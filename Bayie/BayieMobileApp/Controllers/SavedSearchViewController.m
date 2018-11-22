//
//  SavedSearchViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SavedSearchViewController.h"
#import "CustomSavedSearchTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "BayieHub.h"
#import "SavedSearchesAdDetailViewController.h"

@interface SavedSearchViewController ()
{
    NSDictionary *savedSearchdataDict;
    NSArray *savedSearchdataArray;
    MBProgressHUD *hud;
}
@end

@implementation SavedSearchViewController

@synthesize lastCall;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.savedSearchTableView.allowsMultipleSelectionDuringEditing = NO;
    self.savedSearchTableView.tableFooterView = [UIView new];

    self.lastCall = @"loadSaveSearch";

    _savedSearchTitle
    .text = [NSString stringWithFormat:NSLocalizedString(@"SAVED_SEARCH", nil), @(1000000)];
    self.savedSearchTableView.estimatedRowHeight = 77;
    self.savedSearchTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.lastCall = @"loadSaveSearch";

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataSaved:) name:@"BayieResponse" object:nil];
    [self listSavedSearch];
}

- (void) gotBayieAPIDataSaved:(NSNotification *) notification{
    //if at any time notfi.object is error or null hide the HUD
    if([lastCall isEqualToString:@"loadSaveSearch"]){
        [self gotBayieAPIDataLoadSave:notification];
    }else if([lastCall isEqualToString:@"deleteAll"] ){
        [self gotBayieAPIDataDeleteAll:notification];
    }
}

- (void) gotBayieAPIDataDeleteAll:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           //    [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
            
            return;
        }
        
        NSDictionary *responseDict = notification.object;
        NSLog(@"%@", responseDict);
        NSString *errormsg = responseDict[@"error"];
        if ([errormsg isEqualToString:@""]) {
            NSArray *dataArray = responseDict[@"data"];
            if (nil != dataArray) {
               // savedSearchdataArray = dataArray;
                UIAlertController * alert =[UIAlertController
                                            alertControllerWithTitle:@"Bayie" message: responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               
                                               //    [self.navigationController popViewControllerAnimated:YES];
                                               
                                               self.lastCall = @"loadSaveSearch";
                                               
                                               [self listSavedSearch];
                                               
                                           }];
                [alert addAction:okButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                [hud hideAnimated:YES];
                
                return;

            }
            [hud hideAnimated:YES];

           // savedSearchdataArray = responseDict[@"data"];
            
            
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
        }
       // [self.savedSearchTableView reloadData];
        [hud hideAnimated:YES];
    }
}


- (void) gotBayieAPIDataLoadSave:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           //    [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
            
            return;
        }
        
        
        
        NSDictionary *responseDict = notification.object;
        NSLog(@"%@", responseDict);
        NSString *errormsg = responseDict[@"error"];
        if ([errormsg isEqualToString:@""]) {
            
            NSArray *dataArray = responseDict[@"data"];
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
                savedSearchdataArray = dataArray;
            }
            [hud hideAnimated:YES];
            NSLog(@"%@", savedSearchdataArray);
            [self.savedSearchTableView reloadData];

            
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self.savedSearchTableView reloadData];

            [hud hideAnimated:YES];
        }
       // [self.savedSearchTableView reloadData];
        [hud hideAnimated:YES];
    }
}

-(void)listSavedSearch{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *tokenobj=[DataClass getInstance];
    NSLog(@"%@",tokenobj.userToken);

    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"userToken":tokenobj.userToken};
     NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"savedSearchList"];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return savedSearchdataArray.count;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        SavedSearchesAdDetailViewController *savViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedSearchesAdDetailViewController"];
        NSDictionary *dataObj = [savedSearchdataArray objectAtIndex:indexPath.row];
        NSString *sav_id = [dataObj valueForKey:@"id"];
        
        savViewController.savid = sav_id;
       // savViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:savViewController animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SavedSearch";
    
    CustomSavedSearchTableViewCell *savedSaerchcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    savedSearchdataDict = [savedSearchdataArray objectAtIndex:indexPath.row];
    
    NSString *dateStr = [savedSearchdataDict valueForKey:@"created_on"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString* newDateFormat = [dateFormat stringFromDate:date];
    dateFormat.doesRelativeDateFormatting = YES;
    
    NSString *keyword = [savedSearchdataDict valueForKey:@"keywords"];
    
    if (![keyword  isEqual: @""]){
        savedSaerchcell.title.text = [savedSearchdataDict valueForKey:@"keywords"];
        savedSaerchcell.titleLabelHeightConstraint.constant = 20;
    }
    else{
        savedSaerchcell.titleLabelHeightConstraint.constant = 0;
        savedSaerchcell.title.text = @"";
    }

    id catName =[savedSearchdataDict valueForKey:@"category_name"];
    
    if([[NSNull null] isEqual:catName])
    catName = @"";
 NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if (![catName isEqual: @""])
    {
    savedSaerchcell.category.text = [savedSearchdataDict valueForKey:@"category_name"];
    }else{
        if(![strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]])
            savedSaerchcell.category.text = @"Search on";
        else
             savedSaerchcell.category.text = @"البحث في";
    }
    
   
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]])
        savedSaerchcell.dateLabel.text = [newDateFormat stringByAppendingString:@", "];
    else
        savedSaerchcell.dateLabel.text = [@", " stringByAppendingString:newDateFormat];
    
    return savedSaerchcell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        NSDictionary *dataObj = [savedSearchdataArray objectAtIndex:indexPath.row];
        NSString *sav_id = [dataObj valueForKey:@"id"];
        
        self.lastCall = @"deleteAll";
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
        
        NSDictionary *parameters =  @{@"saveId":sav_id};
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"deleteSavedSearch"];
        
        //  [self.self.savedSearchTableView reloadData];
        
        //  [dataObj removeObjectAtIndex:indexPath.row];
        //  [_savedSearchTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - 

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [hud hideAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [hud hideAnimated:YES];
    
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteAllButton:(id)sender {
    UIAlertController * alert =[UIAlertController
                                alertControllerWithTitle:@"Bayie" message: @"Api not implemented" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   //    [self.navigationController popViewControllerAnimated:YES];
                                   
                               }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
/*
    self.lastCall = @"deleteAll";
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
   
    NSDictionary *parameters =  @{@"saveId":@"1"};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"deleteSavedSearch"];
 */
}


@end
