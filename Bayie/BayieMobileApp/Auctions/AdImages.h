//
//  AdImages.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/29/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdImages : NSObject
@property (nonatomic, assign) int imageId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *videoThumb;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *imageBaseUrl;
-(id)initWithImageDictionary:(NSDictionary *)imageDictionary;
@end
