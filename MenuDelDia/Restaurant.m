//
//  Model.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

@dynamic  objectId;
@dynamic  name;
@dynamic  address;
@dynamic  city;
@dynamic  postcode;
@dynamic  telno;
@dynamic  website;
@dynamic location;



+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Restaurants";
}
    
    


@end