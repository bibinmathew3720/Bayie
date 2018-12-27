//
//  CategoryViewController.h
//  BayieMobileApp
//
//  Created by Apple on 03/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseViewController.h"

@protocol CategoryViewControllerDelegate ;

@interface CategoryViewController : UIViewController

@property (nonatomic,assign) BOOL isLocation;
@property (nonatomic,assign) BOOL isSubCategory;
@property (nonatomic, assign) BOOL isFromBrowseCategory;
@property (nonatomic,strong) NSString * baseUrl;
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) id<CategoryViewControllerDelegate>categoryDelegate;
@property (nonatomic, assign) PAGETYPE pageType;


@end


@protocol CategoryViewControllerDelegate <NSObject>

- (void)categoryViewControllerItem:(CategoryViewController *)viewController clickedItem:(id)item;
- (void)categoryViewControllerItem:(CategoryViewController *)viewController clickedsubCategoryItem:(id)item andSubCAtegoryElement:(id)subCategoryElement;
- (void)categoryViewControllerItem:(CategoryViewController *)viewController clickedLocationItem:(id)item;

@end
