//
//  BayieHub.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 11/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "BayieHub.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"

@implementation BayieHub

+(BayieHub*) sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        //   [_sharedObject initDefaults];
    });
    return _sharedObject;
}
-(void)PostrequestcallServiceWith :(NSString *)inputContent :(NSString *)methodName{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    
    NSLog(@"**\nRequest to call Method Name::%@\n**",methodName);
    
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        
        //    [[UIApplication sharedApplication].keyWindow makeToast:@"Please check your internet connection!" duration:2.6 position:CSToastPositionTop];
        NSError *error = [NSError errorWithDomain:@"No Internet" code:400 userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:error];
        return;
        
    }else
    {
        if([methodName isEqualToString:@"updateDeviceToken"]){
            [self updateDeviceTokenWithParameters:inputContent];
        }
        else if([methodName isEqualToString:@"userLogin"]){
            //      NSString *post =[NSString stringWithFormat:@"username:%@","password:%@","deviceId:%@",[inputContent objectAtIndex:0],[inputContent objectAtIndex:1],[inputContent objectAtIndex:2]];
            
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self loginUser:inputContent];
            
        }else if([methodName isEqualToString:@"regCustomer"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self userRegistraion:inputContent];
            
        }else if([methodName isEqualToString:@"socialLogin"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self socialLogin:inputContent];
            
        }else if([methodName isEqualToString:@"verifyOtp"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self verifyOTP:inputContent];
            
        }
        else if([methodName isEqualToString:@"otpVerification"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self verifyAdOtp:inputContent];
            
        }else if([methodName isEqualToString:@"category"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self category:inputContent];
        }else if([methodName isEqualToString:@"subCategory"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self subCategory:inputContent];
            
        }else if([methodName isEqualToString:@"popularAds"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self popularAds:inputContent];
            
        }else if([methodName isEqualToString:@"nearByAds"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self nearByAds:inputContent];
            
        }else if([methodName isEqualToString:@"profileUpdate"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self profileUpdate:inputContent];
            
        }else if([methodName isEqualToString:@"listAds"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self listAds:inputContent];
            
        }else if([methodName isEqualToString:@"savedSearchList"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self savedSearchList:inputContent];
            
        }else if([methodName isEqualToString:@"locationList"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self locationList:inputContent];
            
        }else if([methodName isEqualToString:@"locationAutoFill"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self locationAutoFill:inputContent];
            
        }else if([methodName isEqualToString:@"searchAutoFill"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self searchAutoFill:inputContent];
            
        }else if([methodName isEqualToString:@"changePassword"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self changePassword:inputContent];
            
        }else if([methodName isEqualToString:@"resendOtp"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self resendOtp:inputContent];
            
        }else if([methodName isEqualToString:@"profileData"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self profileData:inputContent];
            
        }else if([methodName isEqualToString:@"changeProfileImage"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self changeProfileImage:inputContent];
            
        }else if([methodName isEqualToString:@"myAds"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self myAds:inputContent];
            
        }else if([methodName isEqualToString:@"myFavouriteList"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self myFavouriteList:inputContent];
            
        }else if([methodName isEqualToString:@"deleteSavedSearch"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self deleteSavedSearch:inputContent];
            
        }else if([methodName isEqualToString:@"saveSearch"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self saveSearch:inputContent];
            
        }
        else if([methodName isEqualToString:@"filterAttributes"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self filterAttributes:inputContent];
        }
        else if([methodName isEqualToString:@"deleteMyAd"]){
            if(inputContent == nil ){
                inputContent =@"";// sanity
            }
            [self deleteMyAdWithAttributes:inputContent];
        }
    }
}

-(void) loginUser:(NSString *)post{
    
    //  NSString *endPoint = [self generateEndPoint:@"userLogin"];
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"userLogin"];
    //    NSURLComponents *components = [NSURLComponents componentsWithString:post];
    
    [self sendData:post :URLString]; //AFHTTP POST - Suita to pull from her code
    //    [self sendData:post];
}

-(void)updateDeviceTokenWithParameters:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"updateGcmID"];
    [self sendDataWithUsertoken:post :URLString];
}

-(void) userRegistraion:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"regCustomer"];
    [self sendData:post :URLString];
}
-(void) socialLogin:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"socialLogin"];
    [self sendData:post :URLString];
}

-(void) verifyOTP:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"verifyOtp"];
    [self sendData:post :URLString];
}

-(void)verifyAdOtp:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"otpVerification"];
    [self sendData:post :URLString];
}

-(void) category:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"category"];
    [self sendData:post :URLString];
}

-(void) subCategory:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"subCategory"];
    [self sendData:post :URLString];
}
-(void) popularAds:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"popularAds"];
    [self sendData:post :URLString];
}
-(void) nearByAds:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"nearByAds"];
    [self sendData:post :URLString];
}
-(void) profileUpdate:(NSString *)post{
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"profileUpdate"];
    [self sendData:post :URLString];
}

-(void) listAds:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"listAds"];
    [self sendDataWithUsertoken:post :URLString];
}
-(void) myAds:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"myAds"];
    [self sendData:post :URLString];
}
-(void) myFavouriteList:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"myFavouriteList"];
    [self sendData:post :URLString];
}
-(void) saveSearch:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"saveSearch"];
    [self sendData:post :URLString];
}

-(void) filterAttributes:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"attributes"];
    [self sendData:post :URLString];
}

-(void)deleteMyAdWithAttributes:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"deleteMyAds"];
    [self sendData:post :URLString];
}

-(void) deleteSavedSearch:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"deleteSavedSearch"];
    [self sendDataWithUsertoken :post :URLString];
}

-(void) savedSearchList:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"savedSearchList"];
    [self sendData:post :URLString];
}

-(void) locationAutoFill:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"locationAutoFill"];
    [self sendData:post :URLString];
}
-(void) searchAutoFill:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"searchAutoFill"];
    [self sendData:post :URLString];
}


-(void) locationList:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"locationList"];
    [self sendData:post :URLString];
}
-(void) changePassword:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"changePassword"];
    [self sendDataWithUsertoken:post :URLString];
}

-(void) resendOtp:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"resendOtp"];
    [self sendData:post :URLString];
}
-(void) profileData:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"profileData"];
    [self sendData:post :URLString];
}

-(void) changeProfileImage:(NSString *)post{
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"changeProfileImage"];
    [self imageUploa:post :URLString];
}


/*
 -(void) sendData:(NSString *)post :(NSString *)endPpoint{
 NSLog(@"%@", endPpoint);
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];  // allocate AFHTTPManager
 [manager.requestSerializer setTimeoutInterval:25];  //Time out after 25 seconds
 
 [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [manager.requestSerializer setValue:AuthValue forHTTPHeaderField:@"Authentication"];
 
 [manager POST:endPpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
 
 //Success call back bock
 NSLog(@"Request completed with response: %@", responseObject);
 if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
 //     NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
 //     if ([r statusCode] == 200) {
 NSLog(@"Request completed with response: %@", responseObject);
 //do success stuff
 NSLog(@"Reply JSON: %@", responseObject);
 if ([responseObject isKindOfClass:[NSArray class]]) {
 NSLog(@"Response == %@",responseObject);
 }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
 NSDictionary *responseDict = responseObject;
 NSLog(@"Reply JSON insdeeeeee: %@", responseObject);
 if (![responseDict[@"error"] isEqualToString:@""]) {
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
 }else if([responseDict[@"error"] isEqualToString:@""]) {
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
 }
 
 
 }
 //  }
 }} failure:^(NSURLSessionDataTask *task, NSError *error) {
 //Failure callback block. This block may be called due to time out or any other failure reason
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
 [alertView show];
 }];
 }
 
 */
-(void) sendData:(NSString *)post :(NSString *)endPpoint{
    
    NSLog(@"%@", endPpoint);
    @try{
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:endPpoint parameters:nil error:nil];
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
        
        [req setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (!error) {
                
                
                NSLog(@"Reply JSON: %@", responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSLog(@"Response == %@",responseObject);
                }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *responseDict = responseObject;
                    if (![responseDict[@"error"] isEqualToString:@""]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                    }else if([responseDict[@"error"] isEqualToString:@""]) {
                        //  no error, der s data
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                    }
                }
            } else {
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                if (error.code == NSURLErrorTimedOut) {
                    //             //time out error here
                    NSLog(@"Trigger TIME OUT");
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                message:@"An error occured. Please try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:error];
                
            }
        }]resume];
    }@catch(NSException *exception){
        NSLog(@"%@ ",exception.name);
    }
}

-(void) sendDataWithUsertoken:(NSString *)post :(NSString *)endPpoint{
    
    NSLog(@"%@", endPpoint);
    
    DataClass *dataObj=[DataClass getInstance];
    NSLog(@"%@", dataObj.userToken);
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:endPpoint parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue: dataObj.userToken forHTTPHeaderField:@"userToken"];
    
    @try{
        [req setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (!error) {
                NSLog(@"Reply JSON: %@", responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSLog(@"Response == %@",responseObject);
                }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *responseDict = responseObject;
                    
                    if (![responseDict[@"error"] isEqualToString:@""]) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                    }else if([responseDict[@"error"] isEqualToString:@""]) {
                        // no error der s data
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                    }
                }
            } else {
                if (error.code == NSURLErrorTimedOut) {
                    //time out error here
                    NSLog(@"Trigger TIME OUT");
                }
                
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                message:@"Unable to Complete request"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:error];
                
            }
        }]resume];
    }@catch(NSException *exception){
        NSLog(@"%@ ",exception.name);
    }
}

-(void) imageUploa:(NSString *)post :(NSString *)endPpoint{
    DataClass *dataObj=[DataClass getInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    
    NSData *imageData =   UIImageJPEGRepresentation (img,1.0);  // convert your image into data
    [params setObject:@"sdsd" forKey:@"filename"];
    
    //NSLog(@"Image data valuee %@", imageData);
    NSString *urlString = [NSString stringWithFormat:@"%@", endPpoint];  // enter your url to upload
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];  // allocate AFHTTPManager
    
    
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [manager.requestSerializer setValue:dataObj.userToken forHTTPHeaderField:@"userToken"];
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {  // POST DATA USING MULTIPART CONTENT TYPE
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:@"savedimage.jpg" mimeType:@"image/jpg"];
        
        
        
        // add your other keys !!!
        
        //       [formData appendPartWithFormData:[@"sdsd" dataUsingEncoding:NSUTF8StringEncoding]
        //                                  name:@"filename"];    // add your other keys !!!
        
        
        //      [formData appendPartWithHeaders:jsonHeaders body:jsonData];
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);    // Get response from the server
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);   // Gives Error
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:error];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
    }];
    
}


-(void) imageUpload:(NSData *)post :(NSString *)endPpoint{
    
    NSLog(@"%@", endPpoint);
    
    //    NSDictionary *gistDict = @{@"body":post};
    // NSError *jsonError;
    //  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:gistDict options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    DataClass *dataObj1=[DataClass getInstance];
    NSLog(@"dict valueeee %@", dataObj1.userToken);
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:endPpoint parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue: dataObj1.userToken forHTTPHeaderField:@"userToken"];
    
    //  [req setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:post];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                
                if (![responseDict[@"error"] isEqualToString:@""]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                    
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    // no error der s data
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BayieResponse" object:responseObject];
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message:error
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }]resume];
    
}


@end
