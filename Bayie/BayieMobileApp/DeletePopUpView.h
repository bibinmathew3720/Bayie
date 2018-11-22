//
//  DeletePopUpView.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 10/25/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeletePopUpViewDelegate;
@interface DeletePopUpView : UIView
@property (nonatomic, assign) id <DeletePopUpViewDelegate>deletePopUpViewDelegate;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;
@end
@protocol DeletePopUpViewDelegate<NSObject>
-(void)deleteChatWithComment:(NSString *)comment andReason:(NSString *)reasonString;
@end
