
//
//  AppDelegate.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//
#define deviceTokenKey @"deviceToken"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@import Firebase;
@import FirebaseMessaging;

#import "Utility.h"
#import "AppDelegate.h"
#import "LanguageSelectorViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DataClass.h"
#import <UserNotifications/UserNotifications.h>
#import "MyChatsViewController.h"
#import "AuctionDetailVC.h"
@import GoogleMobileAds;

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [FIRApp configure];
    [self addObserver];
    // Adding Google AD
    //[GADMobileAds configureWithApplicationID:@"ca-app-pub-3310088406325999~8779278669"];
    [self registerForFCM:application];
    [FIRMessaging messaging].remoteMessageDelegate = self;
//    [FIRMessaging messaging].delegate = self;
    
    [self initNavigationBarAppearence];
    [self initWindow];
    //[self registerPushNotification];
    return YES;
}

- (void)initNavigationBarAppearence {
    UINavigationBar * navigationBarAppearence = [UINavigationBar appearance];
    navigationBarAppearence.translucent = NO;
    navigationBarAppearence.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:LatoBold size:17],NSFontAttributeName ,AppCommonWhiteColor, NSForegroundColorAttributeName, nil];
    navigationBarAppearence.barTintColor = AppCommonBlueColor;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHome:) name:BayieShowHome object:nil];
}

-(void)showHome:(NSNotificationCenter *)notCentre{
    [self initWindow];
}

-(void)initWindow{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        NSString  *path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
        if([DataClass isiPad]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
            
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
            
        }
        [self.window makeKeyAndVisible];
    }else if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        if([DataClass isiPad]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
        }else{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
        }
        [self.window makeKeyAndVisible];
    }else{
        LanguageSelectorViewController *lanviewController = [[LanguageSelectorViewController alloc] initWithNibName:[DataClass loadXIBBasedOnDevice:@"LanguageSelector"] bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lanviewController];
        lanviewController.navigationController.navigationBarHidden=YES;
        
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
    }
}

#pragma mark - Push Notification Delegates

- (void)registerPushNotification {
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0") ){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else {
        UIUserNotificationType types = UIUserNotificationTypeAlert| UIUserNotificationTypeSound |UIUserNotificationTypeBadge;
        UIUserNotificationSettings *mySettings =[UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
}

-(void)registerForFCM:(UIApplication *)application{
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)                                                name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
   // [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - Delegate for FCM Notifications

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [[NSUserDefaults standardUserDefaults] setObject:refreshedToken forKey:deviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}

-(void)setLaunchScreen {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    // Adding Google AD
   // [GADMobileAds configureWithApplicationID:@"ca-app-pub-3310088406325999~8779278669"];
    
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        NSString  *path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
        if([DataClass isiPad]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
            
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
            
        }
        [self.window makeKeyAndVisible];
    }else if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        if([DataClass isiPad]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
        }else{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            loginViewController.navigationController.navigationBarHidden=YES;
            self.window.rootViewController = navController;
        }
        [self.window makeKeyAndVisible];
    }else{
        LanguageSelectorViewController *lanviewController = [[LanguageSelectorViewController alloc] initWithNibName:[DataClass loadXIBBasedOnDevice:@"LanguageSelector"] bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lanviewController];
        lanviewController.navigationController.navigationBarHidden=YES;
        
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
    }
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

/*
-(void) showLoginScreen:(BOOL)animated
{
    if(animated){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LanguageSelectorViewController *languageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LanguageSelectorViewController"];
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:languageViewController animated:YES completion:NULL];

    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        tbc.selectedIndex=0;
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:tbc animated:YES completion:NULL];
    }
   /// [self presentViewController:tbc animated:YES completion:nil];
    
    
  }

*/

//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSLog(@"Device Token:%@",[deviceToken description]);
//    NSString *newDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"Device Token:%@",newDeviceToken);
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    /*
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    return handled;
    */
    NSString *stringURL = [ url absoluteString];
    if([stringURL containsString:@"fb"])
    {
        
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
    [self connectToFcm];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - FCM Delegates

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:deviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // TODO: If necessary send token to application server.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
    NSString *logo;
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    logo = [pref objectForKey:@"logout"];
    if(logo ==nil ){
        if ([userInfo valueForKey:@"gcm.notification.action"]){
            if ([[userInfo valueForKey:@"gcm.notification.action"] isEqualToString:@"bid"]){
                [self handleAuctionWithUserInfo:userInfo forApplication:application];
            }
            else{
                [self handleChatWithUserInfo:userInfo forApplication:application];
            }
        }
        else{
             [self handleChatWithUserInfo:userInfo forApplication:application];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)handleChatWithUserInfo:(id)userInfo forApplication:(UIApplication *)application{
    if(application.applicationState == UIApplicationStateActive){
        [self showAlertWithTitle:NSLocalizedString(@"MyChats", @"My Chats") andMessage:NSLocalizedString(@"YouHaveANewMessage", @"You have a new message")];
    }
    else{
        [self settingChatScreenWithPushNotificationInfo:userInfo];
    }
    
}

-(void)handleAuctionWithUserInfo:(id)userInfo forApplication:(UIApplication *)application{
    if(application.applicationState == UIApplicationStateActive){
        [self showAlertWithTitle:NSLocalizedString(@"Auctions", @"Auctions") andMessage:NSLocalizedString(@"YouHaveANewBid", @"You have a new bid")];
    }
    else{
        [self settingAuctionDetailScreenWithInfo:userInfo];
    }
}


-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)messageString{
    UIAlertController *messageAlert = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [messageAlert addAction:okAction];
    UIViewController *viewController;
    if([self.window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        viewController = [[navController viewControllers] lastObject];
    }
    
    [viewController presentViewController:messageAlert animated:YES completion:nil];
}

-(void)settingChatScreenWithPushNotificationInfo:(id)userInfo{
    
    //self.window.rootViewController
     MyChatsViewController *myChats = [[UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chats"];
    myChats.isFromNotification = YES;
    UINavigationController *myChatsNavCnlr = [[UINavigationController alloc] initWithRootViewController:myChats];
    UIViewController *viewController = self.window.rootViewController;
    [viewController presentViewController:myChatsNavCnlr animated:NO completion:nil];
}

-(void)settingAuctionDetailScreenWithInfo:(id)userInfo{
    AuctionDetailVC *auctionDetailVC = [[AuctionDetailVC alloc] initWithNibName:@"AuctionDetailVC" bundle:nil];
    if ([userInfo valueForKey:@"gcm.notification.auction_slug"]){
        auctionDetailVC.adId = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"gcm.notification.auction_slug"]];
    }
    auctionDetailVC.isFromNotification = YES;
    UINavigationController *auctionDetailNavCnlr = [[UINavigationController alloc] initWithRootViewController:auctionDetailVC];
    UIViewController *viewController = self.window.rootViewController;
    [viewController presentViewController:auctionDetailNavCnlr animated:NO completion:nil];
}

- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
           // [self ServerRequestForDeviceTokenWithToken:[[FIRInstanceID instanceID] token]];
        }
    }];
}


- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage {
    
}

@end
