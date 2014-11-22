//
//  Movie.h
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVD : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *category;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *imdbUrl;

@end
