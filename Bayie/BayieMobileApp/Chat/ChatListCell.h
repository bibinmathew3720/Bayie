//
//  ChatListCell.h
//  BayieMobileApp
//
//  Created by Swati on 03/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface ChatListCell : UITableViewCell
-(void)configureCell:(ChatModel*)modelObj;
-(void)populateAdDetails:(id)adDetails;
@property (nonatomic, strong) NSString *defaultAdImage;
@end
