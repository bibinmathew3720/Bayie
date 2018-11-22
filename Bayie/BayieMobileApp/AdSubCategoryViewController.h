//
//  AdSubCategoryViewController.h
//  BayieMobileApp
//
//  Created by Ajeesh T S on 05/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdSubCategory.h"
@protocol AdSubCategoryDelegte <NSObject>
@optional
- (void)selectedSubCategory:(SubCategory *)subCategory;
@end
@interface AdSubCategoryViewController : UIViewController
@property (nonatomic, weak) id <AdSubCategoryDelegte> delegate;
@property(nonatomic,strong) NSString *categoryId;

@end
