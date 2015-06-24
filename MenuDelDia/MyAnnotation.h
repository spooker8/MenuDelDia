//
//  RestaurantsList.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/22/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "MenuDelDia.h"



@interface MyAnnotation : NSObject <MKAnnotation>



@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) BOOL *isFav;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) MenuDelDia *menu;
@property (nonatomic) NSString *objectID;


-(id)initWithTitle:(NSString *)newTitle isFav:(BOOL *)isFav subTitle:(NSString *)subTitle location:(CLLocationCoordinate2D)location menu:(MenuDelDia*)menu;



-(MKAnnotationView *)annotationView;


@end
