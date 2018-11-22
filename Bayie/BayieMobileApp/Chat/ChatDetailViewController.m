//
//  ChatDetailViewController.m
//  BayieMobileApp
//
//  Created by Swati on 04/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "AFNetworking.h"
#import "ChatMessage.h"
#import "ChatMessageCell.h"
#import "ChatListCell.h"
#import "DataClass.h"
#import <NextGrowingTextView/NextGrowingTextView-Swift.h>
#import "IQKeyboardManager.h"

@interface ChatDetailViewController ()
{
    __weak IBOutlet UITableView* tblView;
    __weak IBOutlet UIButton* sendBtn;
    __weak IBOutlet NextGrowingTextView* msgTxtView;
    IBOutlet NSLayoutConstraint* viewBottom;
    NSMutableArray* myChatsArr;
    NSString * imageBaseUrl;
    NSTimer *imageTimer;
    
    NSDictionary *adDetails;
    
    __weak IBOutlet UIImageView *profImageView;
    __weak IBOutlet UILabel *topNameLabel;
    
}
@property (nonatomic, strong) id responseObject;
@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populatinguserDetails];
    msgTxtView.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    msgTxtView.layer.borderWidth = 1.5;
    msgTxtView.layer.borderColor = [UIColor colorWithRed:0.92 green:0.93 blue:0.94 alpha:1].CGColor;
    msgTxtView.layer.cornerRadius = 5.0;
    sendBtn.layer.cornerRadius = 18.0;

    
    msgTxtView.textView.textColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    msgTxtView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",NSLocalizedString(@"Enter message", nil)] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    tblView.estimatedRowHeight = 100;
    myChatsArr = [NSMutableArray array];
    [self getNewMessages:nil];
    [self startTimer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = false;
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
	
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].enableAutoToolbar = true;
    [self removeTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    id paramKeyboardUserInfo = notification.userInfo;
    CGSize keyboardSize = [[paramKeyboardUserInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        viewBottom.constant = keyboardRect.size.height;
        [self.view layoutIfNeeded];
    } completion:nil];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.2 animations:^{
        viewBottom.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)populatinguserDetails{
    [profImageView sd_setImageWithURL:[NSURL URLWithString:[self.chatModel.seller_profile_image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    topNameLabel.text = [NSString stringWithFormat:@"%@",_chatModel.seller_user_name];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - New Messages
-(void)sendMessage:(NSString*)messageStr{
    
    NSString *URLString = [MessageBaseUrl stringByAppendingString:@"sendMessage"];
    DataClass *obj=[DataClass getInstance];
    NSString *messageUserId =  @"";
    if([obj.userId isEqualToString:_chatModel.to_user_id])
        messageUserId = _chatModel.from_user_id;
    else
        messageUserId = _chatModel.to_user_id;
    NSDictionary *parameters =  @{@"userToken":obj.userToken,@"language":@"English",@"toUserId":messageUserId,@"adId":_chatModel.ad_id,@"message":messageStr};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
	__weak typeof(self) weakSelf = self;
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [self removeTimer];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
                int statusVl = [responseObject[@"status"] intValue];
                if (statusVl == 200){
                    [self processData:responseObject];
                }
                else{
                        UIAlertController * alert =[UIAlertController
                                                    alertControllerWithTitle:@"Bayie" message:responseObject[@"error"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* okButton = [UIAlertAction
                                                   actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                   handler:nil];
                        [alert addAction:okButton];
                        
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                
            }
        } else {
            [self processData:responseObject];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }]resume];
    
}

-(void)processData:(id)responseObject{
    NSDictionary *responseDict = responseObject;
    NSString* sentMsgId = [responseDict[@"data"] objectForKey:@"message_id"];
    ChatMessage* chatObj = [[ChatMessage alloc] init];
    chatObj.message = msgTxtView.textView.text;
    chatObj.chatId = sentMsgId;
    chatObj.sentMsg = 1;
    [myChatsArr addObject:chatObj];
    [tblView reloadData];
    
    [self getNewMessages:^{
        if (self){
            [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.2];
            [self startTimer];
        }
    }];
    msgTxtView.textView.text = @"";
}

- (void) scrollToBottom {
	
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger count = [tblView numberOfRowsInSection:0];
		if (count > 0) {
			[tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
		}
	});
}
-(void)getNewMessages:(void (^)()) didCompleteFetching{
    
    NSString *URLString = [@"https://bayie.digiora.com/api/apiMessage.php?action=" stringByAppendingString:@"getAdsMessages"];
    //    NSDictionary *parameters =  @{@"userToken":obj.userToken,@"language":@"English",@"fromUserId":@"2",@"adId":@"20"};
    DataClass *obj=[DataClass getInstance];
    NSString *messageUserId =  @"";
    if([obj.userId isEqualToString:_chatModel.to_user_id])
        messageUserId = _chatModel.from_user_id;
    else
        messageUserId = _chatModel.to_user_id;
    
    NSDictionary *parameters =  @{@"userToken":obj.userToken,@"language":[DataClass currentLanguageString],@"fromUserId":messageUserId,@"adId":_chatModel.ad_id};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                adDetails = [[responseObject valueForKey:@"data"] valueForKey:@"adDetails"];
                self.responseObject = responseDict;
                if ([responseDict[@"baseUrl"] isKindOfClass:[NSString class]]) {
                    imageBaseUrl = [[NSString alloc] init];
                    imageBaseUrl = [responseDict objectForKey:@"baseUrl"];
                    //                    [responseDict[@"baseUrl"] stringValue];
                }
                if ([responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSArray* msgsArr = [NSArray arrayWithArray:[responseDict[@"data"] objectForKey:@"messages"]];
                    //NSArray* reversedArray = [[msgsArr reverseObjectEnumerator] allObjects];
                    [myChatsArr removeAllObjects];
                    for (NSDictionary* dict  in msgsArr) {
                        [myChatsArr addObject:[[ChatMessage alloc] initWithDictionary:dict error:nil]];
                    }
                    // myChatsArr = [NSMutableArray arrayWithArray:[responseDict[@"data"] objectForKey:@"messages"]];
                    [tblView reloadData];
									if (didCompleteFetching)
										didCompleteFetching();
                }
                else{
                    
                    NSLog(@"Response == %@",responseDict);
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }]resume];
    
}
-(IBAction)sendMessageTapped:(id)sender{
    [msgTxtView resignFirstResponder];
    if(msgTxtView.textView.text.length){
        [self sendMessage:msgTxtView.textView.text];
    }
}
#pragma mark - TableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myChatsArr.count+1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        ChatListCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [categoryCell populateAdDetails:adDetails];
        if([adDetails isKindOfClass:[NSDictionary class]]){
            if([[adDetails valueForKey:@"ad_image"] isEqual:[NSNull null]]||([[adDetails valueForKey:@"ad_image"] length]==0)){
                if(![[self.responseObject valueForKey:@"defaultAdImage"] isEqual:[NSNull null]])
                    categoryCell.defaultAdImage = [self.responseObject valueForKey:@"defaultAdImage"];
            }
        }
        return categoryCell;
    }
    ChatMessage* chatMsg = myChatsArr[indexPath.row-1];
//    chatMsg.sentMsg = indexPath.row%2==0;
    if (imageBaseUrl){
        chatMsg.baseImageUrl = imageBaseUrl;
    }
    ChatMessageCell *categoryCell;
    if (chatMsg.image_url)
    {
        categoryCell = [tableView dequeueReusableCellWithIdentifier:chatMsg.sentMsg?@"sent1":@"rec1"];
    }
    else
        categoryCell = [tableView dequeueReusableCellWithIdentifier:chatMsg.sentMsg?@"sent":@"rec"];
    [categoryCell configureCell:chatMsg];
    return categoryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}
-(void)removeTimer{
    [imageTimer invalidate];
}
-(void)startTimer{
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getNewMessages:) userInfo:nil repeats:1];
}
@end
