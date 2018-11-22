//
//  ChatMessageCell.h
//  BayieMobileApp
//
//  Created by Swati on 04/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface ChatMessageCell : UITableViewCell
-(void)configureCell:(ChatMessage*)modelObj;
@end
