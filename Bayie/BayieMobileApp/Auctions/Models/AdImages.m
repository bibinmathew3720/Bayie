//
//  AdImages.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/29/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "AdImages.h"
NSString *const kImageId = @"id";
NSString *const kImageUrl = @"image_url";
NSString *const kMediaType = @"type";
NSString *const kVideoThumb = @"video_thumb";
NSString *const kVideoUrl = @"video_url";

@implementation AdImages
-(id)initWithImageDictionary:(NSDictionary *)imageDictionary{
    self = [super init];
    if (self) {
        self.imageId = 0;
        self.imageUrl = @"";
        self.type = @"";
        self.videoThumb = @"";
        self.videoUrl = @"";
    }
    if (![imageDictionary[kImageId] isKindOfClass:[NSNull class]]){
        self.imageId = [imageDictionary[kImageId] intValue];
    }
    if (![imageDictionary[kImageUrl] isKindOfClass:[NSNull class]]){
        self.imageUrl = imageDictionary[kImageUrl];
    }
    if (![imageDictionary[kMediaType] isKindOfClass:[NSNull class]]){
        self.type = imageDictionary[kMediaType];
    }
    if (![imageDictionary[kVideoThumb] isKindOfClass:[NSNull class]]){
        self.videoThumb = imageDictionary[kVideoThumb];
    }
    if (![imageDictionary[kVideoUrl] isKindOfClass:[NSNull class]]){
        self.videoUrl = imageDictionary[kVideoUrl];
    }
    return self;
}
@end
