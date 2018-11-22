#import <UIKit/UIKit.h>
#import "Category.h"

@interface AdCategory : NSObject

@property (nonatomic, strong) NSArray * category;
@property (nonatomic, strong) NSString * baseUrl;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString * defaultImage;
@property (nonatomic, strong) NSString * error;
@property (nonatomic, assign) NSInteger status;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end