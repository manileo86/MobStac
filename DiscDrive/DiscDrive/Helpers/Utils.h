//
//  Utils.h
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "DVD.h"
@interface Utils : NSObject

+(void)saveUser:(User*)user;
+(User*)currentUser;
+(void)deleteCurrentUser;

+(NSArray*)dvdList:(NSString*)type;
+(NSArray*)dvdList:(NSString*)type category:(NSString*)category;
+(NSArray*)cartDvdList;

+(void)addMovieToCart:(DVD*)movie;
+(void)deleteMovieFromCart:(DVD*)movie;

@end
