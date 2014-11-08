//
//  User.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//

#import "User.h"

@implementation User

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.name = [decoder decodeObjectForKey:@"name"];
        self.gender = [[decoder decodeObjectForKey:@"gender"] integerValue];
    }
    return self;
}

@end
