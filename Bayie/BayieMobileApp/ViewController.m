//
//  ViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationController.navigationBar.layer setBorderColor:[[UIColor clearColor] CGColor]];
    // [self updateUI];

    //  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"splash_Screen_Bg"]];
    

 //   [self.navigationController.navigationBar.layer setBorderWidth:2.0];// Just to make sure its working
   }

-(void)updateUI{
    
    CALayer *emailBorder = [CALayer layer];
    CALayer *passwordBorder = [CALayer layer];
    
    CGFloat borderWidth = 2;
    emailBorder.borderColor = [UIColor lightGrayColor].CGColor;
    emailBorder.frame = CGRectMake(0, _emailTextFiled.frame.size.height - borderWidth, _emailTextFiled.frame.size.width, _emailTextFiled.frame.size.height);
    emailBorder.borderWidth = borderWidth;
    
    passwordBorder.borderColor = [UIColor lightGrayColor].CGColor;
    passwordBorder.frame = CGRectMake(0, _emailTextFiled.frame.size.height - borderWidth, _emailTextFiled.frame.size.width, _emailTextFiled.frame.size.height);
    passwordBorder.borderWidth = borderWidth;
    
    [_emailTextFiled.layer addSublayer:emailBorder];
    _emailTextFiled.layer.masksToBounds = YES;
    [_passwordTextField.layer addSublayer:passwordBorder];
    _passwordTextField.layer.masksToBounds = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
UITableViewCell *Adcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     return Adcell;
}

@end
