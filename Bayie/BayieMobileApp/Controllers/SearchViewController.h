//
//  SearchViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 25/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchViewControllerDelegate;
@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
//@property (strong, nonatomic) NSMutableArray* searchdataArray;
@property (nonatomic, assign) id <SearchViewControllerDelegate>searchControllerDelegate;
@end
@protocol SearchViewControllerDelegate <NSObject>

-(void)searchDelegateWithKeyword:(NSString *)keyWordString;
@end
