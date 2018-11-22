//
//  CustomFavoritesTableViewCell.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 25/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "CustomFavoritesTableViewCell.h"
#import "ChatDetailViewController.h"
#import "DataClass.h"
#import "FavoritesViewController.h"

@implementation CustomFavoritesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.favChat.layer setBorderWidth:1.0];
    [self.favChat.layer setBorderColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor];
    [_favTitle sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
/*
- (IBAction)favChatBtn:(id)sender {
    
    DataClass *tknobj=[DataClass getInstance];
    NSLog(@"dataaassss %@", tknobj.datas);
    
    if(tknobj.datas != nil){
        ChatDetailViewController *chatDetailPage = [[UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chatDetail"];
        ChatModel *chatModel = [[ChatModel alloc] init];
        
        NSDictionary *favdataDict = [tknobj.datas objectAtIndex:_favChat.tag];
        
        NSLog(@"%@ img url", [favdataDict valueForKey:@"user_id"]);
        chatModel.from_user_id = [DataClass getInstance].userId;
        chatModel.to_user_id = [favdataDict valueForKey:@"user_id"];
        chatModel.ad_id = [favdataDict valueForKey:@"ad_Id"];
        chatModel.ad_image =  tknobj.chatimg;
        chatModel.seller_user_name = [favdataDict valueForKey:@"postedBy"];
        chatModel.chatTitle = [favdataDict valueForKey:@"title"];
        chatModel.last_message = [favdataDict valueForKey:@"createdDate"];
        chatDetailPage.chatModel = chatModel;
        
        UITableView *tv = (UITableView *) self.superview.superview;
        UITableViewController *vc = (UITableViewController *) tv.dataSource;
        
        [vc.navigationController pushViewController:chatDetailPage animated:1];
        
    }

}
*/
@end
