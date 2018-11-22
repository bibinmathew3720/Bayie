//
//	SubCategory.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SubCategory.h"

NSString *const kSubCategoryCategoryId = @"category_Id";
NSString *const kSubCategoryCategoryName = @"category_name";
NSString *const kSubCategoryIdField = @"id";
NSString *const kSubCategoryParentId = @"parent_id";

@interface SubCategory ()
@end
@implementation SubCategory




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kSubCategoryCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = dictionary[kSubCategoryCategoryId];
	}	
	if(![dictionary[kSubCategoryCategoryName] isKindOfClass:[NSNull class]]){
		self.categoryName = dictionary[kSubCategoryCategoryName];
	}	
	if(![dictionary[kSubCategoryIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kSubCategoryIdField];
	}	
	if(![dictionary[kSubCategoryParentId] isKindOfClass:[NSNull class]]){
		self.parentId = dictionary[kSubCategoryParentId];
	}	
	return self;
}
@end