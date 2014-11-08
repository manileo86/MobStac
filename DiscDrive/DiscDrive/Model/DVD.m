//
//  Movie.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//

#import "DVD.h"

@implementation DVD

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.category forKey:@"category"];
    [encoder encodeObject:self.imageUrl forKey:@"image"];
    [encoder encodeObject:self.imdbUrl forKey:@"imdb"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.title = [decoder decodeObjectForKey:@"title"];
        self.category = [decoder decodeObjectForKey:@"category"];
        self.imageUrl = [decoder decodeObjectForKey:@"image"];
        self.imdbUrl = [decoder decodeObjectForKey:@"imdb"];
    }
    return self;
}

@end
