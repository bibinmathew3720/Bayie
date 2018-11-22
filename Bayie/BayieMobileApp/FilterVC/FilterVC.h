//
//  FilterVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterVCDelegate ;

@interface FilterVC : UIViewController

@property (nonatomic,assign) BOOL isFromPostAd;
@property (nonatomic,strong) NSString * categoryName;
@property (nonatomic,strong) NSNumber * categoryID;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *attributeTextField;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomFilterButton;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel
;

@property (nonatomic, assign) BOOL isFromEditAd;
@property (nonatomic, strong) NSDictionary *selectedFilterDictionary;
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, strong) id adDetails;
@property (nonatomic,strong) id<FilterVCDelegate>filterVcDelegate;

@end

@protocol FilterVCDelegate <NSObject>

- (void)filterVcItem:(FilterVC *) viewController clickedItem:(id)item;

@end
