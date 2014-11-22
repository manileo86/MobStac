//
//  AppDelegate.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "Utils.h"
#import "Collector.h"

@interface AppDelegate ()

@property(nonatomic, strong) HomeViewController *homeVC;
@property(nonatomic, strong) LoginViewController *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    User *user = [Utils currentUser];
    if(user)
    {
        [self addHome];
    }
    else
    {
        [self addLogin];
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helpers

- (void) addLogin
{
    if(!_loginVC)
        _loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = _loginVC;
}

- (void) addHome
{
    if(!_homeVC)
        _homeVC = [[HomeViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_homeVC];
    navController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
    
    [[Collector sharedInstance] initialize];
}
@end
