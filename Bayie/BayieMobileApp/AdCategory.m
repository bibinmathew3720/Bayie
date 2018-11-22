//
//	AdCategory.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AdCategory.h"

NSString *const kAdCategoryCategory = @"data";
NSString *const kAdCategoryBaseUrl = @"baseUrl";
NSString *const kAdCategoryCount = @"count";
NSString *const kAdCategoryDefaultImage = @"defaultImage";
NSString *const kAdCategoryError = @"error";
NSString *const kAdCategoryStatus = @"status";

@interface AdCategory ()
@end
@implementation AdCategory




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[kAdCategoryCategory] != nil && [dictionary[kAdCategoryCategory] isKindOfClass:[NSArray class]]){
		NSArray * categoryDictionaries = dictionary[kAdCategoryCategory];
		NSMutableArray * categoryItems = [NSMutableArray array];
		for(NSDictionary * categoryDictionary in categoryDictionaries){
			Category * categoryItem = [[Category alloc] initWithDictionary:categoryDictionary];
			[categoryItems addObject:categoryItem];
		}
		self.category = categoryItems;
	}
	if(![dictionary[kAdCategoryBaseUrl] isKindOfClass:[NSNull class]]){
		self.baseUrl = dictionary[kAdCategoryBaseUrl];
	}	
	if(![dictionary[kAdCategoryCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kAdCategoryCount] integerValue];
	}

	if(![dictionary[kAdCategoryDefaultImage] isKindOfClass:[NSNull class]]){
		self.defaultImage = dictionary[kAdCategoryDefaultImage];
	}	
	if(![dictionary[kAdCategoryError] isKindOfClass:[NSNull class]]){
		self.error = dictionary[kAdCategoryError];
	}	
	if(![dictionary[kAdCategoryStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kAdCategoryStatus] integerValue];
	}

	return self;
}
@end
