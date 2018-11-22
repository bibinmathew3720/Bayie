#import <UIKit/UIKit.h>

@interface AdInfo : NSObject

@property (nonatomic, strong) NSString * adId;
@property (nonatomic, strong) NSString * adsId;
@property (nonatomic, strong) NSString * adTime;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * createdDate;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * itemCondition;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * memberSince;
@property (nonatomic, strong) NSString * mobileNumber;
@property (nonatomic, strong) NSString * postedBy;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * priceType;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, strong) NSString * userProfileImage;
@property (nonatomic, strong) NSString * viewCount;
@property (nonatomic) BOOL isFavourite;
@property (nonatomic, strong) NSString * userId;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
