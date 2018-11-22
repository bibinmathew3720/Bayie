//
//  ChatMessageCell.m
//  BayieMobileApp
//
//  Created by Swati on 04/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ChatMessageCell.h"
@interface ChatMessageCell(){
    __weak IBOutlet UILabel* messageLbl;
    __weak IBOutlet UILabel* dateLbl;
    __weak IBOutlet UIImageView* imgView;
    __weak IBOutlet UIImageView* msgImageView;
    __weak IBOutlet NSLayoutConstraint* imgViewHeight;
}
@end

@implementation ChatMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)configureCell:(ChatMessage*)modelObj{
    messageLbl.text = modelObj.message;
    if(modelObj.unread){
        //dateLbl.text = modelObj.created_on;
        dateLbl.text = modelObj.chatTime;
        imgView.image = [UIImage imageNamed:@"tickBlue"];
    }
    else
    {
       // dateLbl.text = modelObj.read_on;
        dateLbl.text = modelObj.chatTime;
        imgView.image = [UIImage imageNamed:@"tickGray"];
    }
    if(modelObj.image_url)
    {
        imgViewHeight.constant = 100;
        NSString *imageUrl = [modelObj.baseImageUrl stringByAppendingString:modelObj.image_url];
        [msgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }
    else{
        imgViewHeight.constant = 0;
    }
}
@end
