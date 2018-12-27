//
//  FilterVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 8/5/17.
//  Copyright © 2017 Abbie. All rights reserved.
//
#define AppCommonBlueColor [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:1.0];

typedef enum filterType{
    FilterTypeCategory = 0,
    FilterTypeCheckBox = 1,
    FilterTypeLocation = 2,
}FILTERTYPE;

#import "FilterVC.h"

#import "FilterLeftTVC.h"
#import "FilterRightTVC.h"
#import "FilterRightCheckBoxCell.h"

#import "BayieHub.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CLAlertHandler.h"

@interface FilterVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *hud;
    NSArray *originalCatArray;
    NSArray *categoryArray;
    
    id selectedCategory;
    id previousCategory;
    NSString *categoryString;
    
    NSArray *locationArray;
    
    NSMutableArray *attributesArray;
   // id selectedSubCategory;
    FILTERTYPE selectedType;
    
    NSArray *attributesValuesArray;
    NSMutableArray *curreSelAttrArray;
    NSString *selAttrId;
    NSIndexPath *previousIndex;
    
    id selectedLocation;
   
}
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *selctButtonCategory;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryArrowImageView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationRightArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTableViewTopConstarint;
@property (weak, nonatomic) IBOutlet UIImageView *backArrowImageView;


@end

@implementation FilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrowArabicWhite"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
        self.backArrowImageView.image = [UIImage imageNamed:ArabicBackArrowImageName];
        self.navigationItem.leftBarButtonItem = rightBarButton;
        [self settingArabicHeadings];
    }else{
        UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow-white"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
        self.navigationItem.leftBarButtonItem = rightBarButton;
        if(self.isFromPostAd)
            [self.bottomFilterButton setTitle:@"APPLY" forState:UIControlStateNormal];
    }
    [self populatingDetails];
    if(!self.isFromPostAd){
        //[self getCategories];
        [self getLocationDetails];
        self.leftTableViewTopConstarint.active = NO;
    }
    else {
        self.navigationController.navigationBarHidden = YES;
        [self callingFilterAttributesApiWithCategoryId:[NSString stringWithFormat:@"%@",self.categoryID]];
        self.leftTableViewTopConstarint.active = YES;
        self.leftTableViewTopConstarint.constant = 0;
    }
    selectedType = FilterTypeLocation;
    
    curreSelAttrArray = [[NSMutableArray alloc] init];
    self.filterDictionary = [[NSMutableDictionary alloc] init];
    if((self.selectedFilterDictionary!=nil) && self.selectedFilterDictionary.count!=0){
        [self.filterDictionary addEntriesFromDictionary:self.selectedFilterDictionary];
    }
    
}

-(void)populatingDetails{
    DataClass *data = [DataClass getInstance];
    if(data.lastKnownLoc!=nil)
        self.locationLabel.text = [NSString stringWithFormat:@"%@",data.lastKnownLoc];
    if(data.categoryTitle!=nil){
        self.categoryLabel.text = [NSString stringWithFormat:@"%@",data.categoryTitle];
    }
}

-(void)settingArabicHeadings{
   self.headingLabel.text = @"منقي";
    [self.clearButton setTitle:@"واضح" forState:UIControlStateNormal];
    [self.bottomFilterButton setTitle:@"منقي" forState:UIControlStateNormal];
    self.categoryLabel.text = @"حدد الفئات";
    self.locationLabel.text = @"اختر موقعا";
    if(self.isFromPostAd)
        [self.bottomFilterButton setTitle:@"تطبيق" forState:UIControlStateNormal];
}

-(void)initialisation{
    previousIndex = nil;
    self.leftTableView.estimatedRowHeight = 50.0;
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedRowHeight = 50.0;
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    categoryString = @"";
    attributesArray = [[NSMutableArray alloc] init];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITabBarController *tabBarController = self.tabBarController;
    tabBarController.tabBar.hidden = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Categories Api

- (void)getCategories {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=getAllCategories" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    DataClass *obj=[DataClass getInstance];
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        categoryArray = [responseObject valueForKey:@"data"];
                        originalCatArray = categoryArray;
                        [self.rightTableView reloadData];
                        DataClass *data = [DataClass getInstance];
                        if(data.categoryTitle!=nil){
                            [self callingFilterAttributesApiWithCategoryId:data.categoryId];
                        }
                    });
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:@"Bayie" inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}

- (void)getLocationDetails {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    DataClass *obj=[DataClass getInstance];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=locationList" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue:obj.userToken forHTTPHeaderField:@"Usertoken"];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                    
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    NSLog(@"Response Object:%@",responseObject);
                    locationArray = [responseObject valueForKey:@"data"];
                    [self.rightTableView reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // [self showCategoryUIWithData:[responseObject valueForKey:@"data"] withStatus:2];
                    });
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
                
            }];
        }
    }]resume];
}




// MARK: - TableView Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.leftTableView)
        return attributesArray.count;
    else if (tableView == self.rightTableView){
        if(selectedType == FilterTypeCategory)
            return categoryArray.count;
        else if (selectedType == FilterTypeLocation)
            return locationArray.count;
        else if(selectedType == FilterTypeCheckBox)
            return attributesValuesArray.count;
        else
            return 0;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        static NSString *MyIdentifier = @"filterLeftCell";
        FilterLeftTVC *leftCell = (FilterLeftTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (leftCell == nil)
        {
              leftCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterLeftTVC" owner:self options:nil] firstObject];
        }
        leftCell.backgroundColor = [UIColor clearColor];
        leftCell.leftData = [attributesArray objectAtIndex:indexPath.row];
        return leftCell;
    }else if(tableView == self.rightTableView){
        if(selectedType == FilterTypeCategory){
            static NSString *MyIdentifier = @"rightFilterCell";
            FilterRightTVC *rightCell = (FilterRightTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            if (rightCell == nil)
            {
                rightCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterRightTVC" owner:self options:nil] firstObject];
            }
            rightCell.rightData =  [categoryArray objectAtIndex:indexPath.row];
            return rightCell;
        }
        else if(selectedType == FilterTypeLocation){
            static NSString *MyIdentifier = @"rightFilterCell";
            FilterRightTVC *rightCell = (FilterRightTVC *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            if (rightCell == nil)
            {
                rightCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterRightTVC" owner:self options:nil] firstObject];
            }
            rightCell.locationData =  [locationArray objectAtIndex:indexPath.row];
            return rightCell;
        }
        else if (selectedType == FilterTypeCheckBox){
            static NSString *MyIdentifier = @"checkBoxCell";
            FilterRightCheckBoxCell *checkBoxCell = (FilterRightCheckBoxCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            if (checkBoxCell == nil)
            {
                checkBoxCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterRightCheckBoxCell" owner:self options:nil] firstObject];
            }
            id checkData = [attributesValuesArray objectAtIndex:indexPath.row];
            checkBoxCell.checkData =  checkData;
            if([curreSelAttrArray containsObject:checkData])
                checkBoxCell.checkButton.selected = YES;
            else
                checkBoxCell.checkButton.selected = NO;
            return checkBoxCell;
        }
        else
            return nil;
    }
    else
        return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

//MARK:- Table View Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.leftTableView){
        [self.view endEditing:YES];
        self.categoryArrowImageView.hidden = YES;
        self.categoryLabel.textColor = [UIColor blackColor];
        self.topView.backgroundColor = [UIColor clearColor];
        self.locationRightArrow.hidden = YES;
        self.locationLabel.textColor = [UIColor blackColor];
        self.locationView.backgroundColor = [UIColor clearColor];
        id attributeItem = [attributesArray objectAtIndex:indexPath.row];
        curreSelAttrArray = [[NSMutableArray alloc] init];
        self.categoryLabel.textColor = [UIColor blackColor];
        [self settingUnSelectedColorOfSelectedCellofLeftTableView];
        previousIndex = indexPath;
        FilterLeftTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.nameLabel.textColor = AppCommonBlueColor
        cell.backgroundColor = [UIColor whiteColor];
        cell.rightArrowIMageView.hidden = NO;
        if([[attributeItem valueForKey:@"type"] isEqualToString:@"Numerical Values"]||[[attributeItem valueForKey:@"type"] isEqualToString:@"Text fields"] || [[attributeItem valueForKey:@"type"] isEqualToString:@"Text Fields"]){
            self.attributeTextField.hidden = NO;
            self.rightTableView.hidden = YES;
            selAttrId = [NSString stringWithFormat:@"%@",[attributeItem valueForKey:@"attribId"]];
            self.attributeTextField.placeholder = [NSString stringWithFormat:@"%@",[attributeItem valueForKey:@"attribute_name"]];
            
            if([[self.filterDictionary valueForKey:selAttrId] isKindOfClass:[NSArray class]]){
                if([[self.filterDictionary valueForKey:selAttrId] count]>0){
                    NSString *atrValue = [[self.filterDictionary valueForKey:selAttrId] firstObject];
                    self.attributeTextField.text = atrValue;
                }
            }
            else if([self.filterDictionary valueForKey:selAttrId]){
                    NSString *atrValue = [self.filterDictionary valueForKey:selAttrId];
                    self.attributeTextField.text = atrValue;
            }
            else{
                 self.attributeTextField.text = @"";
            }
        }
        else{
            self.rightTableView.hidden = NO;
            self.attributeTextField.hidden = YES;
            selAttrId = [NSString stringWithFormat:@"%@",[attributeItem valueForKey:@"attribId"]];
            if([self.filterDictionary valueForKey:selAttrId]){
                NSArray *array = [self.filterDictionary valueForKey:selAttrId];
                [curreSelAttrArray addObjectsFromArray:array];
            }
            selectedType = FilterTypeCheckBox;
            attributesValuesArray = [attributeItem valueForKey:@"category_attrib_values"];
            [self.rightTableView reloadData];
        }
        NSLog(@"Attribute Item:%@",attributeItem);
    }
    else if (tableView == self.rightTableView){
        if(selectedType == FilterTypeCategory){
            id category = [categoryArray objectAtIndex:indexPath.row];
            selectedCategory = category;
            if([category valueForKey:@"sub_category"]){
                if([[category valueForKey:@"sub_category"] count]>0){
                    categoryArray = [category valueForKey:@"sub_category"];
                    [self.rightTableView reloadData];
                }
            }
            if(previousCategory!=nil){
                NSString *previousIdString = [NSString stringWithFormat:@"%@",[previousCategory valueForKey:@"parent_category"]];
                NSString *currentIdString = [NSString stringWithFormat:@"%@",[category valueForKey:@"parent_category"]];
                if([previousIdString isEqualToString:currentIdString]){
                    NSString *lastString = [[categoryString componentsSeparatedByString:@">"] lastObject];
                    categoryString = [categoryString stringByReplacingOccurrencesOfString:lastString withString:[selectedCategory valueForKey:@"category_name"]];
                }
                else{
                    if(categoryString.length == 0)
                        categoryString = [category valueForKey:@"category_name"];
                    else
                        categoryString = [NSString stringWithFormat:@"%@>%@",categoryString,[category valueForKey:@"category_name"]];
                }
            }
            else{
                if(categoryString.length == 0)
                    categoryString = [category valueForKey:@"category_name"];
                else
                    categoryString = [NSString stringWithFormat:@"%@>%@",categoryString,[category valueForKey:@"category_name"]];
            }
            self.categoryLabel.text = categoryString;
            previousCategory = selectedCategory;
            NSString *categoryIdString = [NSString stringWithFormat:@"%@",[selectedCategory valueForKey:@"id"]];
            [self callingFilterAttributesApiWithCategoryId:categoryIdString];
        }
        else if (selectedType == FilterTypeCheckBox){
            if(self.isFromPostAd){
                NSArray * tempArray = [self.filterDictionary valueForKey:selAttrId];
                if([tempArray count]>0) {
                    id item =  [tempArray objectAtIndex:0];
                    [curreSelAttrArray removeObject:item];
                    [tableView reloadData];
                }
            }
            
            id selectedItem = [attributesValuesArray objectAtIndex:indexPath.row];
            FilterRightCheckBoxCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
            if([curreSelAttrArray containsObject:selectedItem]){
                [curreSelAttrArray removeObject:selectedItem];
                selCell.checkButton.selected = NO;
            }
            else{
                [curreSelAttrArray addObject:selectedItem];
                selCell.checkButton.selected = YES;
            }
            [self.filterDictionary setValue:curreSelAttrArray forKey:selAttrId];
            NSLog(@"Dictionary:%@",self.filterDictionary);
        }
        else if (selectedType == FilterTypeLocation){
            selectedLocation = [locationArray objectAtIndex:indexPath.row];
            self.locationLabel.text = [NSString stringWithFormat:@"%@",[selectedLocation valueForKey:@"location"]];
        }
        
    }
}

#pragma mark - UITextField Delegates

- (IBAction)textFielValueChanged:(UITextField *)sender {
     [self.filterDictionary setValue:sender.text forKey:selAttrId];
}


#pragma mark - Calling Filter Attribuates Api

-(void)callingFilterAttributesApiWithCategoryId:(NSString *)categoryIdString{
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile",@"category":categoryIdString};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"filterAttributes"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) gotBayieAPIData:(NSNotification *) notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           //    [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
            
            return;
        }
        
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            [attributesArray removeAllObjects];
            [self populatingAttributesWithData:[responseDict valueForKey:@"data"]];
        }
        else if (![errormsg isEqualToString:@""]){
            [attributesArray removeAllObjects];
            [self.leftTableView reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = 1000;
            [alert show];
            [hud hideAnimated:YES];
            
        }
        [hud hideAnimated:YES];
        
    }
}

-(void)populatingAttributesWithData:(NSArray *)attributeData{
    [attributesArray addObjectsFromArray:attributeData];;
    [self.leftTableView reloadData];
    if(self.isFromEditAd){
        if(self.selectedFilterDictionary==nil){
            if([self.adDetails valueForKey:@"adAttributes"]){
                NSArray *attributesArray = [self.adDetails valueForKey:@"adAttributes"];
                for (id attribute in attributesArray) {
                    NSString *atrName = [attribute valueForKey:@"attribute"];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.attribute_name==%@",atrName];
                    id attributeDataItem = [[attributeData filteredArrayUsingPredicate:predicate] firstObject];
                    NSString *attributeId = [NSString stringWithFormat:@"%@",[attributeDataItem valueForKey:@"attribId"]];
                     NSString *valueString = [NSString stringWithFormat:@"%@",[attribute valueForKey:@"value"]];
                    valueString = [valueString stringByReplacingOccurrencesOfString:@"[" withString:@""];
                    valueString = [valueString stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    valueString = [valueString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    if([[attribute valueForKey:@"type"] isEqualToString:@"Numerical Values"]||[[attribute valueForKey:@"type"] isEqualToString:@"Text fields"]){
                        [self.filterDictionary setValue:valueString forKey:attributeId];
                    }
                    else{
                        [self.filterDictionary setValue:[NSArray arrayWithObject:valueString] forKey:attributeId];
                    }
                    
                }
            }
        }
        NSLog(@"Filter Dictionary:%@",self.filterDictionary);
    }
    if(self.isFromPostAd)
        [self populateFirstAttributeValues];
    NSLog(@"Attributes Array:%@",attributesArray);
}

-(void)populateFirstAttributeValues{
    previousIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    FilterLeftTVC *cell = [self.leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.nameLabel.textColor = AppCommonBlueColor
    cell.backgroundColor = [UIColor whiteColor];
    cell.rightArrowIMageView.hidden = NO;
    id attributeItem = [attributesArray firstObject];
    if([[attributeItem valueForKey:@"type"] isEqualToString:@"Numerical Values"]||[[attributeItem valueForKey:@"type"] isEqualToString:@"Text fields"]||[[attributeItem valueForKey:@"type"] isEqualToString:@"Text Fields"]){
        self.attributeTextField.hidden = NO;
        self.rightTableView.hidden = YES;
        selAttrId = [NSString stringWithFormat:@"%@",[attributeItem valueForKey:@"attribId"]];
        self.attributeTextField.placeholder = [NSString stringWithFormat:@"%@",[attributeItem valueForKey:@"attribute_name"]];
        if([self.filterDictionary valueForKey:selAttrId]){
            if([[self.filterDictionary valueForKey:selAttrId] isKindOfClass:[NSArray class]]){
                if([[self.filterDictionary valueForKey:selAttrId] count]>0){
                    NSString *atrValue = [[self.filterDictionary valueForKey:selAttrId] firstObject];
                    self.attributeTextField.text = atrValue;
                }
            }
            else if([self.filterDictionary valueForKey:selAttrId]){
                NSString *atrValue = [self.filterDictionary valueForKey:selAttrId];
                    self.attributeTextField.text = atrValue;
            }
            else{
                self.attributeTextField.text = @"";
            }
        }
        else{
            self.attributeTextField.text = @"";
        }
    }
    else{
        self.rightTableView.hidden = NO;
        self.attributeTextField.hidden = YES;
        selAttrId = [NSString stringWithFormat:@"%@",[attributeItem valueForKey:@"attribId"]];
        if([self.filterDictionary valueForKey:selAttrId]){
            NSArray *array = [self.filterDictionary valueForKey:selAttrId];
            [curreSelAttrArray addObjectsFromArray:array];
        }
        selectedType = FilterTypeCheckBox;
        attributesValuesArray = [attributeItem valueForKey:@"category_attrib_values"];
        [self.rightTableView reloadData];
    }
}


#pragma mark- Button Actions

- (IBAction)categoryButtonAction:(UIButton *)sender {
    self.locationView.backgroundColor = [UIColor clearColor];
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationRightArrow.hidden = YES;
    self.topView.backgroundColor = [UIColor whiteColor];
    self.categoryArrowImageView.hidden = NO;
    self.attributeTextField.hidden = YES;
    self.rightTableView.hidden = NO;
    [self settingUnSelectedColorOfSelectedCellofLeftTableView];
    self.categoryLabel.textColor = AppCommonBlueColor
    selectedType = FilterTypeCategory;
    if(categoryArray.count == 0){
        [self getCategories];
    }
    [self.rightTableView reloadData];
}
- (IBAction)locationButtonAction:(UIButton *)sender {
    self.topView.backgroundColor = [UIColor clearColor];
    self.categoryLabel.textColor = [UIColor blackColor];
    self.categoryArrowImageView.hidden = YES;
    self.locationView.backgroundColor = [UIColor whiteColor];
    self.locationRightArrow.hidden = NO;
    self.attributeTextField.hidden = YES;
    self.rightTableView.hidden = NO;
    [self settingUnSelectedColorOfSelectedCellofLeftTableView];
    self.locationLabel.textColor = AppCommonBlueColor;
    selectedType = FilterTypeLocation;
    if(locationArray.count == 0){
        [self getLocationDetails];
    }
    [self.rightTableView reloadData];
    
    
}

#pragma mark - UIView Action

- (void)rightButtonAction:(id)sender {
    if(self.isFromPostAd)
        [self.navigationController popViewControllerAnimated:YES];
    else
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)leftButtonAction:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearButtonAction:(UIButton *)sender {
    selectedCategory = nil;
    previousCategory = nil;
    categoryString = @"";
    categoryArray = originalCatArray;
    selectedLocation = nil;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        self.categoryLabel.text = @"حدد الفئات";
        self.locationLabel.text = @"اختر موقعا";
    }
    else{
        self.categoryLabel.text = @"Select Categories";
        self.locationLabel.text = @"Select Location";
    }
    self.topView.backgroundColor = [UIColor clearColor];
    self.categoryLabel.textColor = [UIColor blackColor];
    self.locationView.backgroundColor = [UIColor whiteColor];
    self.locationLabel.textColor = AppCommonBlueColor;
    
    self.categoryArrowImageView.hidden = YES;
    self.locationRightArrow.hidden = NO;
    self.attributeTextField.text = @"";
    if(!self.isFromPostAd){
        [attributesArray removeAllObjects];
        self.attributeTextField.hidden = YES;
        [self settingUnSelectedColorOfSelectedCellofLeftTableView];
        selectedType = FilterTypeLocation;
        self.rightTableView.hidden = NO;
         [self.leftTableView reloadData];
         selAttrId  =@"";
    }
    [curreSelAttrArray removeAllObjects];
    [self.filterDictionary removeAllObjects];
    [self.rightTableView reloadData];
}

- (IBAction)filterButtonAction:(UIButton *)sender {
    NSLog(@"%@",self.filterDictionary);
    if(!self.isFromPostAd) {
        
        DataClass *dataObj=[DataClass getInstance];
        dataObj.filterLoc = dataObj.lastKnownLocID;
        if(selectedCategory!=nil){
            dataObj.category  = [NSString stringWithFormat:@"%@",[selectedCategory valueForKey:@"id"]];
            dataObj.categoryId  = [NSString stringWithFormat:@"%@",[selectedCategory valueForKey:@"id"]];
            dataObj.categoryTitle  = [NSString stringWithFormat:@"%@",[selectedCategory valueForKey:@"category_name"]];
        }
        dataObj.attributeDict =  self.filterDictionary;
        if(selectedLocation !=nil){
            dataObj.lastKnownLocID = [NSString stringWithFormat:@"%@",[selectedLocation valueForKey:@"id"]];
            dataObj.lastKnownLoc = [NSString stringWithFormat:@"%@",[selectedLocation valueForKey:@"location"]];
        }
        if(self.filterVcDelegate && [self.filterVcDelegate respondsToSelector:@selector(filterVcItem:clickedItem:)]){
            [self.filterVcDelegate filterVcItem:self clickedItem:self.filterDictionary];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
//        if([json objectForKey:@"key"]) {
//            NSString *key = json[@"key"];
//            dataObj.key =  key;
//            NSLog(@"key valueee %@", dataObj.key);
//            
//        }else {
//            dataObj.key = @"";
//        }
//        if([json objectForKey:@"priceMin"]) {
//            dataObj.priceMin = json[@"priceMin"];
//            
//        }else {
//            dataObj.priceMin = @"";
//        }
//        if([json objectForKey:@"priceMax"]) {
//            dataObj.priceMax =  json[@"priceMax"];
//            
//        }else {
//            dataObj.priceMax = @"";
//        }
    }else {
        if(self.filterVcDelegate && [self.filterVcDelegate respondsToSelector:@selector(filterVcItem:clickedItem:)]){
            [self.filterVcDelegate filterVcItem:self clickedItem:self.filterDictionary];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)settingUnSelectedColorOfSelectedCellofLeftTableView{
    if(previousIndex!=nil){
        FilterLeftTVC *leftCell = [self.leftTableView cellForRowAtIndexPath:previousIndex];
        leftCell.nameLabel.textColor = [UIColor blackColor];
        leftCell.backgroundColor = [UIColor clearColor];
        leftCell.rightArrowIMageView.hidden = YES;
    }
}

#pragma mark - UIAlert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if(alertView.tag == 1000)
            [self.navigationController popViewControllerAnimated:YES];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
