#import <UIKit/UIKit.h>
#import "SubCategory.h"
#import "ParentDetail.h"

@interface AdSubCategory : NSObject

@property (nonatomic, strong) NSArray * subCategory;
@property (nonatomic, strong) NSString * error;
@property (nonatomic, strong) NSArray * parentDetails;
@property (nonatomic, assign) NSInteger status;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end