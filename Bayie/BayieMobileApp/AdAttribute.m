//
//	AdAttribute.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AdAttribute.h"

NSString *const kAdAttributeAttribute = @"attribute";
NSString *const kAdAttributeIdField = @"id";
NSString *const kAdAttributeValue = @"value";

@interface AdAttribute ()
@end
@implementation AdAttribute




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kAdAttributeAttribute] isKindOfClass:[NSNull class]]){
		self.attribute = dictionary[kAdAttributeAttribute];
	}	
	if(![dictionary[kAdAttributeIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kAdAttributeIdField];
	}	
	if(![dictionary[kAdAttributeValue] isKindOfClass:[NSNull class]]){
		self.value = dictionary[kAdAttributeValue];
	}	
	return self;
}
@end