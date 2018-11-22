//
//  DataClass.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 31/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass

static NSBundle *bundle = nil;

@synthesize userToken,
mobleToken,
categoryTitle,
categoryId,
lastKnownLoc,
lastKnownLocID,
filterLoc,
isIphone,
isEnglish,
isFromSort,
sortType,
//loc,
attributes,
category,
priceMax,
priceMin,
key,
datas,
chatimg,
latitude,
longitude,filterStr;

static DataClass *instance = nil;

+(DataClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DataClass new];
        }
    }
    return instance;
}

+(BOOL)isiPad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSLog(@"ipadd");
        return YES;
    }
    else
    {
        NSLog(@"iphone");
        return NO;
    }
}

+(NSString *)loadXIBBasedOnDevice:(NSString *)viewControllerName
{
    NSString *strReturn = @"";
    if([DataClass isiPad])
    {
        strReturn = [NSString stringWithFormat:@"%@˜ipad",viewControllerName];
     //   LanguageSelector˜ipad
    }
    else
    {
        strReturn = viewControllerName;
    }
    NSLog(@"%@",strReturn);
    return strReturn;
}


+ (NSBundle *)currentLanguageBundle
{
    // Default language incase an unsupported language is found
    NSString *language = @"en";
    
    if ([NSLocale preferredLanguages].count) {
        // Check first object to be of type "en","es" etc
        // Codes seen by my eyes: "en-US","en","es-US","es" etc
        
        NSString *letterCode = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if ([letterCode rangeOfString:@"en"].location != NSNotFound) {
            // English
            language = @"en";
        } else if ([letterCode rangeOfString:@"ar"].location != NSNotFound) {
            // Spanish
            language = @"es";
        }
    }
    
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]];
}

+ (NSString *)currentLanguageString{
    if ([self isCurrentLanguageEnglish]) {
        return @"English";
    } else {
        return @"Arabic";
    }
}


/// Check if preferred language is English
+ (BOOL)isCurrentLanguageEnglish
{
    if (![NSLocale preferredLanguages].count) {
        // Just incase check for no items in array
        return YES;
    }
    
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location == NSNotFound) {
        // No letter code for english found
        return NO;
    } else {
        // Tis English
        return YES;
    }
}

/*  Swap language between English & Arabic
 *  Could send a string argument to directly pass the new language
 */
+ (void)changeCurrentLanguage
{
    if ([self isCurrentLanguageEnglish]) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"ar"] forKey:@"AppleLanguages"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
    }
}

@end
