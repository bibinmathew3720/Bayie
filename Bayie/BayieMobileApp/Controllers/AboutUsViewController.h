//
//  AboutUsViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    WebViewTypeAboutUs,
}WebViewType;
@interface AboutUsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *aboutUsWebview;
@property (nonatomic,assign) WebViewType webViewType;
@end
