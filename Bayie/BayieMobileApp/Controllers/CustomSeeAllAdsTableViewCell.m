//
//  CustomSeeAllAdsTableViewCell.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "CustomSeeAllAdsTableViewCell.h"
#import "DataClass.h"
#import "ChatDetailViewController.h"

@implementation CustomSeeAllAdsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.chatBtn.layer setBorderWidth:1.0];
    [self.chatBtn.layer setBorderColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chatButton:(id)sender {
    
    DataClass *tknobj=[DataClass getInstance];
    NSLog(@"dataaassss %@", tknobj.datas);
    
    if(tknobj.datas != nil){
        ChatDetailViewController *chatDetailPage = [[UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chatDetail"];
        ChatModel *chatModel = [[ChatModel alloc] init];
        
        NSDictionary *addataDict = [tknobj.datas objectAtIndex:_chatBtn.tag];
        
        NSLog(@"%@ img url", [addataDict valueForKey:@"user_id"]);
        chatModel.from_user_id = [DataClass getInstance].userId;
        chatModel.to_user_id = [addataDict valueForKey:@"user_id"];
        chatModel.ad_id = [addataDict valueForKey:@"ad_Id"];
        chatModel.ad_image =  tknobj.chatimg;
        chatModel.seller_user_name = [addataDict valueForKey:@"postedBy"];
        chatModel.chatTitle = [addataDict valueForKey:@"title"];
        chatModel.last_message = [addataDict valueForKey:@"createdDate"];
        chatDetailPage.chatModel = chatModel;
        
        UITableView *tv = (UITableView *) self.superview.superview;
        UITableViewController *vc = (UITableViewController *) tv.dataSource;
        
        [vc.navigationController pushViewController:chatDetailPage animated:1];
        
    }

    
}

@end
