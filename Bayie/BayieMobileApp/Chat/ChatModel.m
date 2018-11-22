//
//  ChatModel.m
//
//
//  Created by Swati on 03/06/17.
//
//

#import "ChatModel.h"
#import "DataClass.h"
@implementation ChatModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"chatId",
                                                       }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
-(NSString*)chatTitle{
    if(_seller_user_id.integerValue == _to_user_id.integerValue)
        return _seller_user_name;
    return _buyer_user_name;
    // Chat title - Find out receiver -  if 'seller_user_id' is same as current 'user Id', use  buyer_user_name for 'Chat title'. Otherwise use 'seller_user_name'
    return nil;
}
-(NSString*)lastChatMessage{
    return self.chatTitle;
    //Last message -    for the time being,  just use Chat title.
}
-(void)setSeller_user_id:(NSString *)seller_user_id{
    _seller_user_id = seller_user_id;
    _isSeller = seller_user_id.integerValue == [DataClass getInstance].userId.integerValue;
}
-(void)setLast_message:(NSString *)last_message{
    _last_message = last_message;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date1 = [dateFormatter dateFromString:last_message];
    [dateFormatter setDateFormat:@"dd MMM HH:mm a"];
    _last_message_date = [dateFormatter stringFromDate:date1];
}
@end
