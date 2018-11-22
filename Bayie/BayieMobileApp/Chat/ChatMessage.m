//
//  ChatMessage.m
//  BayieMobileApp
//
//  Created by Swati on 04/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ChatMessage.h"
#import "DataClass.h"

@implementation ChatMessage
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
-(void)setRead_status:(NSString *)read_status{
    _read_status = read_status;
    _unread = [read_status isEqualToString:@"Unread"];
    
    if([read_status isEqualToString:@"Unread"])
        _unread = 1;
    if([read_status isEqualToString:@"Read"])
        _unread = 0;
}
-(void)setFrom_user_id:(NSString *)from_user_id{
    _from_user_id = from_user_id;
    NSLog(@"Response == %@",from_user_id);

    if(from_user_id.integerValue == [[[DataClass getInstance]userId]integerValue]){
        _sentMsg = 1;
    }
    else{
        _sentMsg = 0;
    }
}
@end
