//
//  CustomFavoritesTableViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 25/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomFavoritesTableViewCell : UITableViewCell
{
    
}
- (IBAction)favChatBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *favImage;
@property (weak, nonatomic) IBOutlet UILabel *favTitle;
@property (weak, nonatomic) IBOutlet UILabel *favLocation;
@property (weak, nonatomic) IBOutlet UILabel *favPrice;
@property (weak, nonatomic) IBOutlet UIButton *favChat;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property(nonatomic,retain)NSArray *datas;
@property(nonatomic,retain)NSString *imgurl;
@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@property (weak, nonatomic) IBOutlet UILabel *featuredLabel;

@end
