//
//  MenuDelDia.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/17/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Restaurant.h"

@interface MenuDelDia :  PFObject <PFSubclassing>


@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) Restaurant *restaurant;
@property (strong, nonatomic) PFFile *imageFile;


@end
