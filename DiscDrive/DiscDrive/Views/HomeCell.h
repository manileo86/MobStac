//
//  HomeCell.h
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DVD.h"

@interface HomeCell : UITableViewCell

- (void)setMovie:(DVD*)aMovie;

-(void)anim;
-(void)backanim;

@end