#import <UIKit/UIKit.h>

@interface AdAttribute : NSObject

@property (nonatomic, strong) NSString * attribute;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * value;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end