//
//	UserProfile.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "UserProfile.h"

NSString *const kUserProfileAddress = @"address";
NSString *const kUserProfileCreatedOn = @"created_on";
NSString *const kUserProfileDeviceId = @"device_id";
NSString *const kUserProfileEmailId = @"email_id";
NSString *const kUserProfileIdField = @"id";
NSString *const kUserProfileLanguage = @"language";
NSString *const kUserProfileLocation = @"location";
NSString *const kUserProfileName = @"name";
NSString *const kUserProfilePhoneNumber = @"phone_number";
NSString *const kUserProfileProfileImage = @"profile_image";

@interface UserProfile ()
@end
@implementation UserProfile



/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]) {
        if(![dictionary[kUserProfileAddress] isKindOfClass:[NSNull class]]){
            self.address = dictionary[kUserProfileAddress];
        }
        if(![dictionary[kUserProfileCreatedOn] isKindOfClass:[NSNull class]]){
            self.createdOn = dictionary[kUserProfileCreatedOn];
        }
        if(![dictionary[kUserProfileDeviceId] isKindOfClass:[NSNull class]]){
            self.deviceId = dictionary[kUserProfileDeviceId];
        }
        if(![dictionary[kUserProfileEmailId] isKindOfClass:[NSNull class]]){
            self.emailId = dictionary[kUserProfileEmailId];
        }
        if(![dictionary[kUserProfileIdField] isKindOfClass:[NSNull class]]){
            self.idField = dictionary[kUserProfileIdField];
        }
        if(![dictionary[kUserProfileLanguage] isKindOfClass:[NSNull class]]){
            self.language = dictionary[kUserProfileLanguage];
        }
        if(![dictionary[kUserProfileLocation] isKindOfClass:[NSNull class]]){
            self.location = dictionary[kUserProfileLocation];
        }
        if(![dictionary[kUserProfileName] isKindOfClass:[NSNull class]]){
            self.name = dictionary[kUserProfileName];
        }
        if(![dictionary[kUserProfilePhoneNumber] isKindOfClass:[NSNull class]]){
            self.phoneNumber = dictionary[kUserProfilePhoneNumber];
        }
        if(![dictionary[kUserProfileProfileImage] isKindOfClass:[NSNull class]]){
            self.profileImage = dictionary[kUserProfileProfileImage];
        }
        
        
        
        if(![dictionary[@"email_verified"] isKindOfClass:[NSNull class]]){
            self.email_verified = [dictionary[@"email_verified"] boolValue];
        }
        
        if(![dictionary[@"facebook_verified"] isKindOfClass:[NSNull class]]){
            self.facebook_verified = [dictionary[@"facebook_verified"] boolValue];
        }
        
        if(![dictionary[@"google_verified"] isKindOfClass:[NSNull class]]){
            self.google_verified = [dictionary[@"google_verified"] boolValue];
        }
        
        if(![dictionary[@"mobile_verified"] isKindOfClass:[NSNull class]]){
            self.mobile_verified = [dictionary[@"mobile_verified"] boolValue];
        }
    }
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.address != nil){
		dictionary[kUserProfileAddress] = self.address;
	}
	if(self.createdOn != nil){
		dictionary[kUserProfileCreatedOn] = self.createdOn;
	}
	if(self.deviceId != nil){
		dictionary[kUserProfileDeviceId] = self.deviceId;
	}
	if(self.emailId != nil){
		dictionary[kUserProfileEmailId] = self.emailId;
	}
	if(self.idField != nil){
		dictionary[kUserProfileIdField] = self.idField;
	}
	if(self.language != nil){
		dictionary[kUserProfileLanguage] = self.language;
	}
	if(self.location != nil){
		dictionary[kUserProfileLocation] = self.location;
	}
	if(self.name != nil){
		dictionary[kUserProfileName] = self.name;
	}
	if(self.phoneNumber != nil){
		dictionary[kUserProfilePhoneNumber] = self.phoneNumber;
	}
	if(self.profileImage != nil){
		dictionary[kUserProfileProfileImage] = self.profileImage;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.address != nil){
		[aCoder encodeObject:self.address forKey:kUserProfileAddress];
	}
	if(self.createdOn != nil){
		[aCoder encodeObject:self.createdOn forKey:kUserProfileCreatedOn];
	}
	if(self.deviceId != nil){
		[aCoder encodeObject:self.deviceId forKey:kUserProfileDeviceId];
	}
	if(self.emailId != nil){
		[aCoder encodeObject:self.emailId forKey:kUserProfileEmailId];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kUserProfileIdField];
	}
	if(self.language != nil){
		[aCoder encodeObject:self.language forKey:kUserProfileLanguage];
	}
	if(self.location != nil){
		[aCoder encodeObject:self.location forKey:kUserProfileLocation];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kUserProfileName];
	}
	if(self.phoneNumber != nil){
		[aCoder encodeObject:self.phoneNumber forKey:kUserProfilePhoneNumber];
	}
	if(self.profileImage != nil){
		[aCoder encodeObject:self.profileImage forKey:kUserProfileProfileImage];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:kUserProfileAddress];
	self.createdOn = [aDecoder decodeObjectForKey:kUserProfileCreatedOn];
	self.deviceId = [aDecoder decodeObjectForKey:kUserProfileDeviceId];
	self.emailId = [aDecoder decodeObjectForKey:kUserProfileEmailId];
	self.idField = [aDecoder decodeObjectForKey:kUserProfileIdField];
	self.language = [aDecoder decodeObjectForKey:kUserProfileLanguage];
	self.location = [aDecoder decodeObjectForKey:kUserProfileLocation];
	self.name = [aDecoder decodeObjectForKey:kUserProfileName];
	self.phoneNumber = [aDecoder decodeObjectForKey:kUserProfilePhoneNumber];
	self.profileImage = [aDecoder decodeObjectForKey:kUserProfileProfileImage];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	UserProfile *copy = [UserProfile new];

	copy.address = [self.address copy];
	copy.createdOn = [self.createdOn copy];
	copy.deviceId = [self.deviceId copy];
	copy.emailId = [self.emailId copy];
	copy.idField = [self.idField copy];
	copy.language = [self.language copy];
	copy.location = [self.location copy];
	copy.name = [self.name copy];
	copy.phoneNumber = [self.phoneNumber copy];
	copy.profileImage = [self.profileImage copy];

	return copy;
}
@end
