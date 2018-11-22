//
//  DataClass.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 31/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject
{
    NSString *userToken;
    NSString *mobleToken;
    NSString *categoryTitle;
    NSString *categoryId;
    NSString *lastKnownLoc;
    NSString *lastKnownLocID;
    
    NSString *filterLoc;
    

    NSString *isIphone;
    BOOL isEnglish;
    BOOL isFromSort;
    NSString *sortType;
  //  NSString *loc;
   NSString *category;
   NSString *attributes;
    NSString *key;
    NSString *priceMin;
    NSString *priceMax;
    NSString *chatimg;
    NSArray *datas;
    
    NSString *latitude;
    NSString *longitude;


}

@property(nonatomic,retain)NSString *userToken;
@property(nonatomic,retain)NSString *mobleToken;
@property(nonatomic,retain)NSString *categoryTitle;
@property(nonatomic,retain)NSString *categoryId;
@property(nonatomic,retain)NSString *lastKnownLoc;
@property(nonatomic,retain)NSString *lastKnownLocID;
@property(nonatomic,retain)NSString *filterLoc;

@property(nonatomic,retain)NSString *isIphone;
@property(nonatomic,assign)BOOL isEnglish;
@property(nonatomic,retain)NSString *userId;
@property(nonatomic,retain)NSString *sortType;
@property(assign) BOOL isFromSort;

//@property(nonatomic,retain)NSString *loc;
@property(nonatomic,retain)NSString *category;
@property(nonatomic,retain)NSString *attributes;
@property(nonatomic,retain)NSString *key;
@property(nonatomic,retain)NSString *priceMin;
@property(nonatomic,retain)NSString *priceMax;
@property(nonatomic,retain)NSString *chatimg;

@property(nonatomic,retain)NSArray *datas;

@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;

@property(nonatomic,retain) NSString *filterStr;
@property (nonatomic, strong) id attributeDict;

//User Details

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userMobile;
@property (nonatomic, strong) NSString *userEmail;

+ (NSString *)currentLanguageString;
+(DataClass*)getInstance;
+(NSString *)loadXIBBasedOnDevice:(NSString *)viewControllerName;
+(BOOL)isiPad;

@end
