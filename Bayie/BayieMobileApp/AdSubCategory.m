//
//	AdSubCategory.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AdSubCategory.h"

NSString *const kAdSubCategorySubCategory = @"data";
NSString *const kAdSubCategoryError = @"error";
NSString *const kAdSubCategoryParentDetails = @"parentDetails";
NSString *const kAdSubCategoryStatus = @"status";

@interface AdSubCategory ()
@end
@implementation AdSubCategory




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[kAdSubCategorySubCategory] != nil && [dictionary[kAdSubCategorySubCategory] isKindOfClass:[NSArray class]]){
		NSArray * subCategoryDictionaries = dictionary[kAdSubCategorySubCategory];
		NSMutableArray * subCategoryItems = [NSMutableArray array];
		for(NSDictionary * subCategoryDictionary in subCategoryDictionaries){
			SubCategory * subCategoryItem = [[SubCategory alloc] initWithDictionary:subCategoryDictionary];
			[subCategoryItems addObject:subCategoryItem];
		}
		self.subCategory = subCategoryItems;
	}
	if(![dictionary[kAdSubCategoryError] isKindOfClass:[NSNull class]]){
		self.error = dictionary[kAdSubCategoryError];
	}	
	if(dictionary[kAdSubCategoryParentDetails] != nil && [dictionary[kAdSubCategoryParentDetails] isKindOfClass:[NSArray class]]){
		NSArray * parentDetailsDictionaries = dictionary[kAdSubCategoryParentDetails];
		NSMutableArray * parentDetailsItems = [NSMutableArray array];
		for(NSDictionary * parentDetailsDictionary in parentDetailsDictionaries){
			ParentDetail * parentDetailsItem = [[ParentDetail alloc] initWithDictionary:parentDetailsDictionary];
			[parentDetailsItems addObject:parentDetailsItem];
		}
		self.parentDetails = parentDetailsItems;
	}
	if(![dictionary[kAdSubCategoryStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kAdSubCategoryStatus] integerValue];
	}

	return self;
}
@end
