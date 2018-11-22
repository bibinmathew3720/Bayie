#import <UIKit/UIKit.h>

@interface Category : NSObject

@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * countAds;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * mobileIcon;
@property (nonatomic, strong) NSString * parentId;
@property (nonatomic, strong) NSString * webIcon;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end