//
//  SubCategoryViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 13/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCategoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *catName;
@property (weak, nonatomic) IBOutlet UIImageView *catImage;
@property (weak, nonatomic) IBOutlet UITableView *subCatTableView;
@property (strong, nonatomic) NSString *categoryTitle;
@property (strong, nonatomic) NSString *catImageurl;
@property (strong, nonatomic) NSString *catID;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *upButton;

@end
