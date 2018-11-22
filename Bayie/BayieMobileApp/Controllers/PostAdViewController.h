//
//  PostAdViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 29/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPostAdTableViewCell.h"

@interface PostAdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *postAdTableView;


@end
