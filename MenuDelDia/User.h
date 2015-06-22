//
//  User.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/19/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface User : PFObject <PFSubclassing>


@property (weak,nonatomic) NSArray *favorite;

@end
