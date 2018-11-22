//
//	ImageItem.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ImageItem.h"

NSString *const kImageItemIdField = @"id";
NSString *const kImageItemImageUrl = @"image_url";
NSString *const kItemVideoUrl = @"video_url";
NSString *const kVideoThumbUrl = @"video_thumb";
NSString *const kType = @"type";
NSString *const kImageItemMediaOrder = @"media_order";


@interface ImageItem ()
@end
@implementation ImageItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kImageItemIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kImageItemIdField];
	}	
	if(![dictionary[kImageItemImageUrl] isKindOfClass:[NSNull class]]){
		self.imageUrl = dictionary[kImageItemImageUrl];
	}	
	if(![dictionary[kImageItemMediaOrder] isKindOfClass:[NSNull class]]){
		self.mediaOrder = dictionary[kImageItemMediaOrder];
	}
    if(![dictionary[kItemVideoUrl] isKindOfClass:[NSNull class]]){
        self.videoUrl = dictionary[kItemVideoUrl];
    }
    if(![dictionary[kVideoThumbUrl] isKindOfClass:[NSNull class]]){
        self.videoThumbUrl = dictionary[kVideoThumbUrl];
    }
    if(![dictionary[kType] isKindOfClass:[NSNull class]]){
        self.type = dictionary[kType];
    }
	return self;
}
@end
