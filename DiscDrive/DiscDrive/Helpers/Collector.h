//
//  Collector.h
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Beaconstac_v_0_9_7/Beaconstac.h>

@interface Collector : NSObject<BeaconstacDelegate>

+ (id)sharedInstance;
- (void)initialize;

- (void)updateFact:(id)fact forKey:(NSString*)key;

@end
