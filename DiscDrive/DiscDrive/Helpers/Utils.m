//
//  Utils.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import "Utils.h"
#import "DVD.h"

@implementation Utils

+(void)saveUser:(User*)user
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    [def setObject:myEncodedObject forKey:@"CurrentUser"];
    [def synchronize];
}

+(User*)currentUser
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [def objectForKey:@"CurrentUser" ];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    return user;
}

+(void)deleteCurrentUser
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"CurrentUser"];
    [def synchronize];
}

+(NSArray*)dvdList:(NSString*)type
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"movies" ofType:@"plist"]];
    
    NSArray *array = [dictionary objectForKey:type];
    
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array)
    {
        DVD *movie = [[DVD alloc] init];
        movie.title = [dict objectForKey:@"title"];
        movie.imageUrl = [dict objectForKey:@"image"];
        movie.category = [dict objectForKey:@"category"];
        movie.imdbUrl = [dict objectForKey:@"imdb"];
        [movies addObject:movie];
    }
    
    return movies;
}

+(NSArray*)dvdList:(NSString*)type category:(NSString*)category
{
    NSArray *dvds = [Utils dvdList:type];
    
    NSMutableArray *filteredDvds = [[NSMutableArray alloc] init];
    for(DVD *dvd in dvds)
    {
        if([dvd.category compare:category options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            [filteredDvds addObject:dvd];
        }
    }
    return filteredDvds;
}

+(NSArray*)cartDvdList
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [def objectForKey:@"CartMovies" ];
    NSArray *cartMovies = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    return cartMovies;
}

+(void)addMovieToCart:(DVD*)movie
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [def objectForKey:@"CartMovies" ];
    NSArray *cartMovies = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:cartMovies];
    [finalArray addObject:movie];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:finalArray];
    [def setObject:newEncodedObject forKey:@"CartMovies"];
    [def synchronize];
}

+(void)deleteMovieFromCart:(DVD*)movie
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [def objectForKey:@"CartMovies" ];
    NSArray *cartMovies = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:cartMovies];
    [finalArray removeObject:movie];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:finalArray];
    [def setObject:newEncodedObject forKey:@"CartMovies"];
    [def synchronize];
}

@end
