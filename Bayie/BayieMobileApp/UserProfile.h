#import <UIKit/UIKit.h>

@interface UserProfile : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * createdOn;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * emailId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * language;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * profileImage;
@property (nonatomic) BOOL mobile_verified;
@property (nonatomic) BOOL email_verified;
@property (nonatomic) BOOL facebook_verified;
@property (nonatomic) BOOL google_verified;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
