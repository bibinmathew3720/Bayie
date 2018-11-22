//
//  ChatModel.h
//
//
//  Created by Swati on 03/06/17.
//
//

#import "JSONModel.h"

@interface ChatModel : JSONModel
@property(nonatomic,strong)NSString *chatId;
@property(nonatomic,strong)NSString *from_user_id;
@property(nonatomic,strong)NSString *to_user_id;
@property(nonatomic,strong)NSString *ad_id;
@property(nonatomic,strong)NSString *last_message;
@property(nonatomic,strong)NSString *last_message_date;
@property(nonatomic,strong)NSString *seller_user_id;
@property(nonatomic,strong)NSString *seller_user_name;
@property(nonatomic,strong)NSString *seller_profile_image;
@property(nonatomic,strong)NSString *buyer_user_id;
@property(nonatomic,strong)NSString *buyer_user_name;
@property(nonatomic,strong)NSString *buyer_profile_image;
@property(nonatomic,strong)NSString *ad_title;
@property(nonatomic,strong)NSString *ad_image;
@property(nonatomic,strong)NSString *ad_status;
@property(nonatomic,strong)NSString *message_count;

@property(nonatomic,strong)NSString *chatTitle;
@property(nonatomic,strong)NSString *lastChatMessage;
@property(nonatomic,assign)BOOL isSeller;
/*
 Chat title - name of user who is receiver (to_user_id)
 */
@end
