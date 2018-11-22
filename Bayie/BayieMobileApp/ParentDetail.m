//
//	ParentDetail.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ParentDetail.h"

NSString *const kParentDetailCategoryName = @"category_name";
NSString *const kParentDetailIdField = @"id";
NSString *const kParentDetailParentId = @"parent_id";

@interface ParentDetail ()
@end
@implementation ParentDetail




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kParentDetailCategoryName] isKindOfClass:[NSNull class]]){
		self.categoryName = dictionary[kParentDetailCategoryName];
	}	
	if(![dictionary[kParentDetailIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kParentDetailIdField];
	}	
	if(![dictionary[kParentDetailParentId] isKindOfClass:[NSNull class]]){
		self.parentId = dictionary[kParentDetailParentId];
	}	
	return self;
}
@end