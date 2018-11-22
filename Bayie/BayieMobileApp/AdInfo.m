//
//	AdInfo.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AdInfo.h"

NSString *const kAdInfoAdsId = @"adsId";
NSString *const kAdInfoAdId = @"id";
NSString *const kAdInfoAdTime = @"adTime";
NSString *const kAdInfoCategoryName = @"category_name";
NSString *const kAdInfoCreatedDate = @"createdDate";
NSString *const kAdInfoDescriptionField = @"description";
NSString *const kAdInfoIdField = @"id";
NSString *const kAdInfoItemCondition = @"item_condition";
NSString *const kAdInfoLatitude = @"latitude";
NSString *const kAdInfoLocation = @"location";
NSString *const kAdInfoLongitude = @"longitude";
NSString *const kAdInfoMemberSince = @"member_since";
NSString *const kAdInfoMobileNumber = @"mobile_number";
NSString *const kAdInfoPostedBy = @"postedBy";
NSString *const kAdInfoPrice = @"price";
NSString *const kAdInfoPriceType = @"price_type";
NSString *const kAdInfoStatus = @"status";
NSString *const kAdInfoTitle = @"title";
NSString *const kAdInfoUserToken = @"userToken";
NSString *const kAdInfoUserProfileImage = @"user_profile_image";
NSString *const kAdInfoViewCount = @"view_count";

@interface AdInfo ()
@end
@implementation AdInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kAdInfoAdId] isKindOfClass:[NSNull class]]){
		self.adId = dictionary[kAdInfoAdId];
	}
    if(![dictionary[kAdInfoAdsId] isKindOfClass:[NSNull class]]){
        self.adsId = dictionary[kAdInfoAdsId];
    }
	if(![dictionary[kAdInfoAdTime] isKindOfClass:[NSNull class]]){
		self.adTime = dictionary[kAdInfoAdTime];
	}	
	if(![dictionary[kAdInfoCategoryName] isKindOfClass:[NSNull class]]){
		self.categoryName = dictionary[kAdInfoCategoryName];
	}	
	if(![dictionary[kAdInfoCreatedDate] isKindOfClass:[NSNull class]]){
		self.createdDate = dictionary[kAdInfoCreatedDate];
	}	
	if(![dictionary[kAdInfoDescriptionField] isKindOfClass:[NSNull class]]){
		self.descriptionField = dictionary[kAdInfoDescriptionField];
	}	
	if(![dictionary[kAdInfoIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kAdInfoIdField];
	}	
	if(![dictionary[kAdInfoItemCondition] isKindOfClass:[NSNull class]]){
		self.itemCondition = dictionary[kAdInfoItemCondition];
	}	
	if(![dictionary[kAdInfoLatitude] isKindOfClass:[NSNull class]]){
		self.latitude = dictionary[kAdInfoLatitude];
	}	
	if(![dictionary[kAdInfoLocation] isKindOfClass:[NSNull class]]){
		self.location = dictionary[kAdInfoLocation];
	}
    if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
        self.userId = dictionary[@"user_id"];
    }
    
	if(![dictionary[kAdInfoLongitude] isKindOfClass:[NSNull class]]){
		self.longitude = dictionary[kAdInfoLongitude];
	}	
	if(![dictionary[kAdInfoMemberSince] isKindOfClass:[NSNull class]]){
		self.memberSince = dictionary[kAdInfoMemberSince];
	}	
	if(![dictionary[kAdInfoMobileNumber] isKindOfClass:[NSNull class]]){
		self.mobileNumber = dictionary[kAdInfoMobileNumber];
	}	
	if(![dictionary[kAdInfoPostedBy] isKindOfClass:[NSNull class]]){
		self.postedBy = dictionary[kAdInfoPostedBy];
	}	
	if(![dictionary[kAdInfoPrice] isKindOfClass:[NSNull class]]){
		self.price = dictionary[kAdInfoPrice];
	}	
	if(![dictionary[kAdInfoPriceType] isKindOfClass:[NSNull class]]){
		self.priceType = dictionary[kAdInfoPriceType];
	}
    if(![dictionary[@"favourite"] isKindOfClass:[NSNull class]]){
        self.isFavourite = [dictionary[@"favourite"] boolValue];
    }
	if(![dictionary[kAdInfoStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kAdInfoStatus];
	}	
	if(![dictionary[kAdInfoTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kAdInfoTitle];
	}	
	if(![dictionary[kAdInfoUserToken] isKindOfClass:[NSNull class]]){
		self.userToken = dictionary[kAdInfoUserToken];
	}	
	if(![dictionary[kAdInfoUserProfileImage] isKindOfClass:[NSNull class]]){
		self.userProfileImage = dictionary[kAdInfoUserProfileImage];
	}	
	if(![dictionary[kAdInfoViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = dictionary[kAdInfoViewCount];
	}	
	return self;
}
@end
