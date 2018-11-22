#import <UIKit/UIKit.h>

@interface SubCategory : NSObject

@property (nonatomic, strong) NSString * categoryId;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * parentId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end