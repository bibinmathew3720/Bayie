#import <UIKit/UIKit.h>
#import "AdInfo.h"
#import "AdAttribute.h"
#import "ImageItem.h"

@interface Advertisement : NSObject

@property (nonatomic, strong) AdInfo * adInfo;
@property (nonatomic, strong) NSArray * adAttributes;
@property (nonatomic, strong) NSString * defaultImage;
@property (nonatomic, strong) NSString * error;
@property (nonatomic, strong) NSString * imageBaseUrl;
@property (nonatomic, strong) NSArray * imageItems;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * shareUrl;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
