//
//  RestaurantsList.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/22/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@import MapKit;

@interface RestaurantsList : NSObject <MKAnnotation>



@property (nonatomic, copy) NSString *name;
@property (nonatomic) CLLocationCoordinate2D coordinate;



@end
