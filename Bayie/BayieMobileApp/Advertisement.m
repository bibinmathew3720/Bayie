//
//	Advertisement.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Advertisement.h"

NSString *const kAdvertisementAdInfo = @"data";
NSString *const kAdvertisementAdAttributes = @"adAttributes";
NSString *const kAdvertisementDefaultImage = @"defaultImage";
NSString *const kAdvertisementError = @"error";
NSString *const kAdvertisementImageBaseUrl = @"imageBaseUrl";
NSString *const kAdvertisementImageItems = @"images";
NSString *const kAdvertisementStatus = @"status";

@interface Advertisement ()
@end
@implementation Advertisement




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kAdvertisementAdInfo] isKindOfClass:[NSNull class]]){
		self.adInfo = [[AdInfo alloc] initWithDictionary:dictionary[kAdvertisementAdInfo]];
	}

	if(dictionary[kAdvertisementAdAttributes] != nil && [dictionary[kAdvertisementAdAttributes] isKindOfClass:[NSArray class]]){
		NSArray * adAttributesDictionaries = dictionary[kAdvertisementAdAttributes];
		NSMutableArray * adAttributesItems = [NSMutableArray array];
		for(NSDictionary * adAttributesDictionary in adAttributesDictionaries){
			AdAttribute * adAttributesItem = [[AdAttribute alloc] initWithDictionary:adAttributesDictionary];
			[adAttributesItems addObject:adAttributesItem];
		}
		self.adAttributes = adAttributesItems;
	}
	if(![dictionary[kAdvertisementDefaultImage] isKindOfClass:[NSNull class]]){
		self.defaultImage = dictionary[kAdvertisementDefaultImage];
	}	
	if(![dictionary[kAdvertisementError] isKindOfClass:[NSNull class]]){
		self.error = dictionary[kAdvertisementError];
	}	
	if(![dictionary[kAdvertisementImageBaseUrl] isKindOfClass:[NSNull class]]){
		self.imageBaseUrl = dictionary[kAdvertisementImageBaseUrl];
	}
    if(![dictionary[@"shareUrl"] isKindOfClass:[NSNull class]]){
        self.shareUrl = dictionary[kAdvertisementImageBaseUrl];
    }
	if(dictionary[kAdvertisementImageItems] != nil && [dictionary[kAdvertisementImageItems] isKindOfClass:[NSArray class]]){
		NSArray * imageItemsDictionaries = dictionary[kAdvertisementImageItems];
		NSMutableArray * imageItemsItems = [NSMutableArray array];
		for(NSDictionary * imageItemsDictionary in imageItemsDictionaries){
			ImageItem * imageItemsItem = [[ImageItem alloc] initWithDictionary:imageItemsDictionary];
			[imageItemsItems addObject:imageItemsItem];
		}
		self.imageItems = imageItemsItems;
	}
	if(![dictionary[kAdvertisementStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kAdvertisementStatus] integerValue];
	}

	return self;
}
@end
