//
//  MenuDelDia.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/17/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "MenuDelDia.h"

@implementation MenuDelDia


@dynamic  restaurant;
@dynamic  price;
@dynamic  updatedAt;



+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"MenuDelDia";
}




@end
