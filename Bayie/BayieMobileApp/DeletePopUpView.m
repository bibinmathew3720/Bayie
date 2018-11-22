//
//  DeletePopUpView.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 10/25/17.
//  Copyright © 2017 Abbie. All rights reserved.
//
#import "TeasonTVC.h"
#import "DeletePopUpView.h"

@interface DeletePopUpView()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;
@property (weak, nonatomic) IBOutlet UITableView *reasonTableView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;


@property (weak, nonatomic) CALayer *layerS;
@property (nonatomic, strong) NSArray *reasonsArray;
@end
@implementation DeletePopUpView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialisation];
    [self customisation];
}

-(void)initialisation{
    UINib *cellNib = [UINib nibWithNibName:@"TeasonTVC" bundle:nil];
    [self.reasonTableView registerNib:cellNib forCellReuseIdentifier:@"reasonCell"];
}

-(void)customisation{
    [self.deleteButton.layer setBorderWidth:1.0];
    [self.deleteButton.layer setBorderColor:[UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor];
    [self.deleteButton setTitle:NSLocalizedString(@"DELETE", @"delete") forState:UIControlStateNormal];
    self.headingLabel.text = NSLocalizedString(@"DELETEPOPUPHEADING", @"Heading");
    self.reasonTextView.delegate  =self;
    
    self.reasonsArray = @[NSLocalizedString(@"SOLDINBAYIE", @""),NSLocalizedString(@"SOLDINOTHERSITE", @""),NSLocalizedString(@"NOTSELLING", @""),NSLocalizedString(@"ADOUTDATE", @""),NSLocalizedString(@"OTHER", @"")];
    self.reasonTableView.dataSource = self;
    self.reasonTableView.delegate = self;
    [self.reasonButton setTitle:[self.reasonsArray firstObject] forState:UIControlStateNormal];
    [self settingShadowToAView:self];
    self.reasonTableView.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1].CGColor;
    self.reasonTableView.layer.borderWidth = 1;
}

-(void)settingShadowToAView:(UIView *)view{
    self.layerS = view.layer;
    view.layer.cornerRadius = 5;
    self.layerS.shadowOffset = CGSizeMake(.5,.5);
    self.layerS.shadowColor = [[UIColor blackColor] CGColor];
    self.layerS.shadowRadius = 2.0f;
    self.layerS.shadowOpacity = 0.40f;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor clearColor].CGColor;
}

#pragma mark - Button Actions

- (IBAction)reasonButtonAction:(UIButton *)sender {
    self.reasonTableView.hidden = NO;
}
- (IBAction)deleteButtonAction:(UIButton *)sender {
    if(self.deletePopUpViewDelegate && [self.deletePopUpViewDelegate respondsToSelector:@selector(deleteChatWithComment:andReason:)]){
        [self.deletePopUpViewDelegate deleteChatWithComment:self.reasonTextView.text andReason:self.reasonButton.titleLabel.text];
    }
}

#pragma mark - UITable View Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reasonsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeasonTVC *reasonCell = [tableView dequeueReusableCellWithIdentifier:@"reasonCell" forIndexPath:indexPath];
    if(reasonCell == nil){
        reasonCell = [[[NSBundle mainBundle] loadNibNamed:@"TeasonTVC" owner:self options:nil] firstObject];
    }
    reasonCell.reasonLabel.text = [self.reasonsArray objectAtIndex:indexPath.row];
    return reasonCell;
}

#pragma mark - UITableView Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reasonString = [self.reasonsArray objectAtIndex:indexPath.row];
    [self.reasonButton setTitle:reasonString forState:UIControlStateNormal];
    self.reasonTableView.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - TextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGFloat yPosition = self.frame.origin.y-120;
    self.frame = CGRectMake(self.frame.origin.x, yPosition, self.frame.size.width, self.frame.size.height);
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    CGFloat yPosition = self.frame.origin.y+120;
    self.frame = CGRectMake(self.frame.origin.x, yPosition, self.frame.size.width, self.frame.size.height);
}

@end
