//
//  CartCell.h
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DVD.h"

@interface CartCell : UITableViewCell

- (void)setMovie:(DVD*)aMovie;

-(void)anim;
-(void)backanim;

@end