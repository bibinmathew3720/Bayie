//
//  ChatListCell.m
//  BayieMobileApp
//
//  Created by Swati on 03/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ChatListCell.h"
@interface ChatListCell(){
    __weak IBOutlet UILabel* titleLbl;
    __weak IBOutlet UILabel* dateLbl;
    __weak IBOutlet UILabel* lastMsgLbl;
    __weak IBOutlet UIImageView* imgView;
}
@end
@implementation ChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)configureCell:(ChatModel*)modelObj{
//    titleLbl.text  = modelObj.ad_title;
//    dateLbl.text  = modelObj.last_message_date;
//    lastMsgLbl.text = modelObj.chatTitle;
    titleLbl.text  = modelObj.chatTitle;
    dateLbl.text  = modelObj.ad_title;
    lastMsgLbl.text = modelObj.last_message_date;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[modelObj.ad_image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
}

-(void)populateAdDetails:(id)adDetails{
    if(adDetails!=nil&&[adDetails isKindOfClass:[NSDictionary class]]){
        titleLbl.text  = [NSString stringWithFormat:@"%@ OMR",[adDetails valueForKey:@"price"]];
        dateLbl.text  = [NSString stringWithFormat:@"%@",[adDetails valueForKey:@"ad_title"]];
        lastMsgLbl.text = [NSString stringWithFormat:@"%@",[adDetails valueForKey:@"location"]];
        if(![[adDetails valueForKey:@"ad_image"] isEqual:[NSNull null]])
            [imgView sd_setImageWithURL:[NSURL URLWithString:[adDetails valueForKey:@"ad_image"]]];
    }
    else{
        titleLbl.text  = @"";
        dateLbl.text  = @"";
        lastMsgLbl.text = @"";
        imgView.image = nil;
    }
}

-(void)setDefaultAdImage:(NSString *)defaultAdImage{
    [imgView sd_setImageWithURL:[NSURL URLWithString:defaultAdImage]];
}

@end
