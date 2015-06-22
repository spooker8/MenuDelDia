//
//  User.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/19/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "User.h"

@implementation User


@dynamic favorite;



+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"User";
}



@end
