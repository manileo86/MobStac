//
//  NotifyViewController.h.h
//  BeaconSampling
//
//  Created by Mani on 19/03/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DVD.h"

@interface NotifyViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate>

@property(nonatomic, retain) NSArray *dvds;

@end
