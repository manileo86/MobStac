//
//  User.h
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GENDER
{
    Male=0,
    Female
}Gender;

@interface User : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) Gender gender;

@end
