//
//  SortViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 11/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSortTableViewCell.h"

@interface SortViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
//@property (weak, nonatomic)NSArray *sortArray;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
