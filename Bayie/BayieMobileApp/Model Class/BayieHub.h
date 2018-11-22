//
//  BayieHub.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 11/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BayieHub : NSObject

+(BayieHub*)sharedInstance;

-(void)PostrequestcallServiceWith :(NSString *)inputContent :(NSString *)methodName;


@end
