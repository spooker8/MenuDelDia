//
//  Model.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import <MapKit/MapKit.h>


@interface Restaurant : PFObject <PFSubclassing, MKAnnotation>

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *telno;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) PFFile *imageFile;

@property (nonatomic) BOOL *isFav;


-(CLLocationCoordinate2D)coordinate;
-(NSString*)title;
-(MKAnnotationView *)annotationView:(BOOL)isFav;


@end


