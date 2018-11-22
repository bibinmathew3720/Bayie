//
//	Category.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Category.h"

NSString *const kCategoryCategoryName = @"category_name";
NSString *const kCategoryCountAds = @"countAds";
NSString *const kCategoryIdField = @"id";
NSString *const kCategoryMobileIcon = @"mobile_icon";
NSString *const kCategoryParentId = @"parent_id";
NSString *const kCategoryWebIcon = @"web_icon";

@interface Category ()
@end
@implementation Category




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kCategoryCategoryName] isKindOfClass:[NSNull class]]){
		self.categoryName = dictionary[kCategoryCategoryName];
	}	
	if(![dictionary[kCategoryCountAds] isKindOfClass:[NSNull class]]){
		self.countAds = dictionary[kCategoryCountAds];
	}	
	if(![dictionary[kCategoryIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kCategoryIdField];
	}	
	if(![dictionary[kCategoryMobileIcon] isKindOfClass:[NSNull class]]){
		self.mobileIcon = dictionary[kCategoryMobileIcon];
	}	
	if(![dictionary[kCategoryParentId] isKindOfClass:[NSNull class]]){
		self.parentId = dictionary[kCategoryParentId];
	}	
	if(![dictionary[kCategoryWebIcon] isKindOfClass:[NSNull class]]){
		self.webIcon = dictionary[kCategoryWebIcon];
	}	
	return self;
}
@end