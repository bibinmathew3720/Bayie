#import <UIKit/UIKit.h>

@interface ImageItem : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, strong) NSString * videoUrl;
@property (nonatomic, strong) NSString *videoThumbUrl;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * mediaOrder;
@property (nonatomic) BOOL isDefault;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
