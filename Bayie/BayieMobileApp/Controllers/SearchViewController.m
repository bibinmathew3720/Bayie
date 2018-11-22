//
//  SearchViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 25/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SearchViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "BayieHub.h"
#import "searchListViewController.h"
#import "CustomSearchTableViewCell.h"

@interface SearchViewController ()
{
    NSMutableDictionary *searchdataDict;
    NSArray *searchdataArray;
    MBProgressHUD *hud;
    NSString *searchKeyword;

}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_cancelButton setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
    [self.search becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataSearch:) name:@"BayieResponse" object:nil];
}

- (void) gotBayieAPIDataSearch:(NSNotification *) notification{
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
                NSString *errorData = responseDict[@"error"];
                if(![errorData isEqualToString:@""]){
                    searchdataArray = @[];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                    message: responseDict[@"error"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [hud hideAnimated:YES];

                }
                else{
                    searchdataArray = responseDict[@"data"];
                    NSLog(@"%@", searchdataArray);
                    [hud hideAnimated:YES];

                }
        [self.searchTableView reloadData];
        [hud hideAnimated:YES];
            }
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 if (_search.text.length > 1){
    return searchdataArray.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Search";
    
    CustomSearchTableViewCell *searchCell =(CustomSearchTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    searchdataDict = [searchdataArray objectAtIndex:indexPath.row];

   
    /*
    NSString *strTextView = [searchdataDict valueForKey:@"suggestion"];
    
    NSRange rangeBold = [strTextView rangeOfString:searchKeyword];
    
    UIFont *fontText = [UIFont boldSystemFontOfSize:10];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:fontText, NSFontAttributeName, nil];
    
    NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView];
    [[searchCell.labelText.text setAttributes:dictBoldText range:rangeBold];
    
    [searchCell.labelText.text setAttributedText:mutAttrTextViewString];
   
    */
    
    
    NSString *yourString = [searchdataDict valueForKey:@"suggestion"];
    
    NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:yourString];
    
    
    NSString *boldString = searchKeyword;
    NSRange boldRange = [yourString rangeOfString:boldString];
    [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Lato-Bold" size:16] range:boldRange];
    [yourAttributedString addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:boldRange];
    
    
  //  [yourLabel setAttributedText: yourAttributedString];
    
    searchCell.labelText.attributedText = yourAttributedString;
    
    
    
  //  searchCell.labelText.text = [searchdataDict valueForKey:@"suggestion"];
    
    return searchCell;
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if ([text length] >= 3){
        [hud hideAnimated:YES];

        [self searchList : text ];
        searchKeyword = text;
  }
 //   [self.searchTableView reloadData];

}
- (IBAction)sortButton:(id)sender {
    
    
    //  [self performSegueWithIdentifier:@"Sort" sender:self];
    
    
}

- (IBAction)filterButton:(id)sender {
    //  [self performSegueWithIdentifier:@"Filter" sender:self];
    
}

-(void)searchList : (NSString*) text{
    NSLog(@"%@", text);
    [hud hideAnimated:YES];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    
   hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];

    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"searchAutoFill"];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"keyword":text};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataSearch:) name:@"BayieResponse" object:nil];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"searchAutoFill"];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataObj = [searchdataArray objectAtIndex:indexPath.row];
    NSString *cat_id = [dataObj valueForKey:@"category_Id"];
    DataClass *dataClass = [DataClass getInstance];
    dataClass.categoryId = cat_id;
   
    
    searchListViewController *searchResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchListViewController"];
    searchResultViewController.categoryID = cat_id;
    searchResultViewController.keyword = searchKeyword;
    [self.navigationController pushViewController:searchResultViewController animated:YES];
    
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
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

// parameters ---
//ads list ---
@end
