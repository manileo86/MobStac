//
//  Collector.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//

#import "Collector.h"
#import "Utils.h"

@interface Collector ()<CLLocationManagerDelegate>
{
    Beaconstac *beaconstac;
    NSString *mediaType;
    NSString *mediaUrl;
    CLLocationManager *locationManager;
}
@end

@implementation Collector

+ (id)sharedInstance
{
    static Collector* _sharedInstance = nil;
    if (!_sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Collector *eventsCollector = [[Collector alloc] init];
            _sharedInstance = eventsCollector;
        });
    }
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        //Set SCManger Delegate
    }
    return self;
}

-(void)initialize
{
    // Setup and initialize the Beaconstac SDK
    BOOL success = [Beaconstac setupOrganizationId:89
                                         userToken:@"0c8b03d3f5342392b2a71fcbe5e58298c92feafd"
                                        beaconUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                                  beaconIdentifier:@"com.smartcues.diskdrive"];
    // Credentials end
    
    if (success) {
        NSLog(@"DemoApp:Successfully saved credentials.");
    }
    
    beaconstac = [[Beaconstac alloc]init];
    beaconstac.delegate = self;
    
    User *user = [Utils currentUser];
    [beaconstac updateFact: user.gender==Male?@"Male":@"Female" forKey:@"Gender"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
}

#pragma mark - Beaconstac delegate
// Tells the delegate a list of beacons in range.
- (void)beaconsRanged:(NSDictionary *)beaconsDictionary
{
    NSLog(@"%@", beaconsDictionary);
    
    for(NSString *key in [beaconsDictionary allKeys])
    {
        NSArray *arr = [key componentsSeparatedByString:@":"];
        NSInteger minor = [[arr objectAtIndex:2] integerValue];
        MSBeacon *b = [beaconsDictionary objectForKey:key];
        if(minor == 16530 && b.getLatestRssi > -60)
        {
            NSLog(@"key %@ %i",b.beaconKey ,b.getLatestRssi);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkout" object:[NSNumber numberWithBool:YES]];
        }
    }
    
    /*[beaconsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
     
     }];*/
}

// Tells the delegate about the camped on beacon among available beacons.
- (void)campedOnBeacon:(id)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    NSLog(@"DemoApp:Entered campedOnBeacon");
    NSLog(@"DemoApp:campedOnBeacon: %@, %@", beacon, beaconsDictionary);
    NSLog(@"DemoApp:facts Dict: %@", beaconstac.factsDictionary);
}

// Tells the delegate when the device exits from the camped on beacon range.
- (void)exitedBeacon:(id)beacon
{
    NSLog(@"DemoApp:Entered exitedBeacon");
    NSLog(@"DemoApp:exitedBeacon: %@", beacon);
    
}

// Tells the delegate that a rule is triggered with corresponding list of actions.
- (void)ruleTriggeredWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
    NSLog(@"DemoApp:Action Array: %@", actionArray);
    //
    // actionArray contains the list of actions to trigger for the rule that matched.
    //
    for (NSDictionary *actionDict in actionArray) {
        //
        // meta.action_type can be "popup", "webpage", "media", or "custom"
        //
        if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"custom"]) {
            //
            // Custom JSON converted to NSDictionary - it's up to you how you want to handle it
            //
            NSDictionary *params = [[actionDict objectForKey:@"meta"]objectForKey:@"params"];
            NSLog(@"DemoApp:Received custom action_type: %@", params);
            
            NSString *value = [params objectForKey:@"text"];
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary *values = (NSDictionary*)json;
            NSLog(@"%@", values);
            NSMutableArray *finalArray = [[NSMutableArray alloc] init];
            [values enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
                
                if([key compare:@"movies" options:NSCaseInsensitiveSearch]==NSOrderedSame)
                {
                    NSArray *categories = [obj componentsSeparatedByString:@","];
                    for(NSString *category in categories)
                    {
                        [finalArray addObjectsFromArray:[Utils dvdList:key category:category]];
                    }
                }
                else
                {
                    [finalArray addObjectsFromArray:[Utils dvdList:key]];
                }
            }];
            NSLog(@"final array: %@", finalArray);
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"beacon" object:finalArray];
        }
        else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"popup"]) {
            
            NSLog(@"DemoApp:Text Alert action type");
            
        }
        else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"webpage"]) {
            //
            // Handle webpage by popping up a WebView
            //
            NSLog(@"DemoApp:Webpage action type");
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            UIWebView *webview =[[UIWebView alloc]initWithFrame:screenRect];
            NSString *url=[[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            NSURL *nsurl=[NSURL URLWithString:url];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [webview loadRequest:nsrequest];
            
            //[self.view addSubview:webview];
            
            // Setting title of the current View Controller
            //self.title = @"Webpage action";
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"video"]) {
            //
            // Media type - video
            //
            NSLog(@"DemoApp:Media action type video");
            mediaType = @"video";
            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            //[self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"audio"]) {
            //
            // Media type - audio
            //
            NSLog(@"DemoApp:Media action type audio");
            mediaType = @"audio";
            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            
            //[self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
        }
    }
}

-(void)updateFact:(id)fact forKey:(NSString *)key
{
    [beaconstac updateFact:@"female" forKey:@"Gender"];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSLog(@"Location access granted.");
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 20;
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                        initWithProximityUUID:[[NSUUID alloc]
                                                               initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                        major:50265 minor:18026 identifier:@"com.smartcues.LocationDemo"];
        [locationManager startMonitoringForRegion:beaconRegion];
    }
    else
    {
        NSLog(@"Location access denied.");
    }
}

#pragma mark - Location Updates
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"Current Location (%f, %f)", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

#pragma mark - Region Monitoring
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;
    if(state==CLRegionStateInside)
    {
        NSLog(@"Inside Region, %@", region.identifier);
        [locationManager startRangingBeaconsInRegion:beaconRegion];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Welcome to Disk & Drive";
        notification.alertAction = NSLocalizedString(@"View details", nil);
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    else if(state==CLRegionStateOutside)
    {
        NSLog(@"Outside Region, %@", region.identifier);
        CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
    else
    {
        NSLog(@"Can't determine State Region, %@", region.identifier);
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"Ranged Beacons : %@", beacons);
    /*for(CLBeacon *beacon in beacons)
     {
     
     }*/
}

-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    
}


@end
