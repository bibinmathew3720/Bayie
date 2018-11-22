//
//  AdCategoryViewController.h
//  BayieMobileApp
//
//  Created by Ajeesh T S on 05/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
@protocol AdCategoryDelegte <NSObject>
@optional
- (void)selectedCategory:(Category *)category;
@end

@interface AdCategoryViewController : UIViewController
@property (nonatomic, weak) id <AdCategoryDelegte> delegate;

@end
