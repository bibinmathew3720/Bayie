//
//  CategoryTableViewCell.h
//  BayieMobileApp
//
//  Created by Apple on 03/08/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic,assign)BOOL isFromLocation;
@property (nonatomic,strong) id category;
@property (nonatomic,strong) id locationDetails;
@property (nonatomic,strong) NSString * baseUrl;

@end
