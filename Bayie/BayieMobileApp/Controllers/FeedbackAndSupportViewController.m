//
//  FeedbackAndSupportViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 15/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "FeedbackAndSupportViewController.h"
#import "MBProgressHUD.h"

@interface FeedbackAndSupportViewController ()
{
    MBProgressHUD *hud;
    
}

@end

@implementation FeedbackAndSupportViewController

- (void)viewDidLoad {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];

    [super viewDidLoad];
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    NSString *urlString=@"https://bayie.digiora.com/contact-us-mob.html";
    
    if ([strSelectedLanguage isEqualToString:@"en"]){
        urlString =  @"https://bayie.digiora.com/contact-us-mob.html";
    }else{
        urlString = @"https://bayie.digiora.com/ar/contact-us-mob.html";
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _feedBackWebview.delegate = self;
    [_feedBackWebview loadRequest:urlRequest];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *currentURL = [[request URL] absoluteString];
    NSLog(@"URL:%@",currentURL);
    if(currentURL != nil){
        NSArray *parts =[currentURL componentsSeparatedByString:@"response="];
        
        if([currentURL rangeOfString:@"bayie:"].location != NSNotFound){
            
            if ([parts count] > 1){
                NSString *jsonStr = [parts objectAtIndex:1];
                jsonStr = [jsonStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *e;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
                [self showAlert:[dict valueForKey:@"data"]];
                return NO;
                
            }
        }
        
    }
    
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView*)theWebView {
    
     [hud hideAnimated:YES];
}

-(void) showAlert:(NSString *) str{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Success"
                                 message:str
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                   
                                }];
    
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hideAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButton:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];

}

@end
