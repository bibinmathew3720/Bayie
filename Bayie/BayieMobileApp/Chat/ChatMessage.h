//
//  ChatMessage.h
//  BayieMobileApp
//
//  Created by Swati on 04/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "JSONModel.h"

@interface ChatMessage : JSONModel
@property(nonatomic,strong)NSString *chatId;
@property(nonatomic,strong)NSString *from_user_id;
@property(nonatomic,strong)NSString *to_user_id;
@property(nonatomic,strong)NSString *ad_id;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *image_url;
@property(nonatomic,strong)NSString *created_on;
@property(nonatomic,strong)NSString *read_status;
@property(nonatomic,strong)NSString *read_on;
@property(nonatomic,strong)NSString *baseImageUrl;
@property(nonatomic,assign) BOOL unread;
@property(nonatomic,assign) BOOL sentMsg;
@property(nonatomic,strong)NSString *chatTime;

@end
