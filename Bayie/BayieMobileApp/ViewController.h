//
//  ViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextFiled;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

