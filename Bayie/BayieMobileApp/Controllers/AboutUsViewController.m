//
//  AboutUsViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#define AbouUsArabicUrl @"https://bayie.digiora.com/ar/about-us-mob.html"
#define AboutUsEnglishUrl @"https://bayie.digiora.com/about-us-mob.html"
#define FeedbackAndSupportEnglishUrl @"https://bayie.digiora.com/contact-us-mob.html"
#define FeedbackAndSupportArabicUrl @"https://bayie.digiora.com/ar/contact-us-mob.html"

#import "AboutUsViewController.h"
#import "MBProgressHUD.h"


@interface AboutUsViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
    
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aboutUsWebview.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSString *urlString=@"";
    if(self.webViewType == WebViewTypeAboutUs){
        if ([strSelectedLanguage isEqualToString:@"en"]){
            urlString =  AboutUsEnglishUrl;
        }else{
            urlString = AbouUsArabicUrl;
        }
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_aboutUsWebview loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView {
    
    [hud hideAnimated:YES];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
      [hud hideAnimated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
