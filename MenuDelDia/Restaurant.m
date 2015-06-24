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
@dynamic isFav;
@dynamic imageFile;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Restaurants";
}
    
-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord;
    coord.latitude = self.location.latitude;
    coord.longitude = self.location.longitude;
    return coord;
}

-(NSString*)title
{
    return self.name;
}





-(MKAnnotationView *)annotationView:(BOOL)isFav
{
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyRestaurantAnnotation"];
    
    
    
    if (!isFav) {
        annotationView.image = [UIImage imageNamed:@"foodicon"];
        
    }
    
    if (isFav) {
        annotationView.image = [UIImage imageNamed:@"favfoodicon"];
        
    }
    
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foodicon"]];
    annotationView.leftCalloutAccessoryView = iconView;
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    
    return annotationView;
}


@end