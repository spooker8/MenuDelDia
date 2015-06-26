//
//  Model.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "Restaurant.h"
#import <ParseUI/ParseUI.h>

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

//-(NSString*)subtitle
//{
//    NSString *telno = [NSString stringWithFormat:@"Tel no %@",self.telno];
//    
//    return telno;
//}








-(MKAnnotationView *)annotationView:(BOOL)isFav
{
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyRestaurantAnnotation"];
    
    
    if (!isFav) {
        annotationView.image = [UIImage imageNamed:@"foodicon"];
        
    } else {
 
        annotationView.image = [UIImage imageNamed:@"favfoodicon"];
        
    }
    
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
  
    
     PFFile* menuPhoto = self[@"imageFile"];
    
    [menuPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:image];
            
           thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
           thumbnailImageView.frame = CGRectMake(0, 0, 40, 40);
            
            annotationView.leftCalloutAccessoryView = thumbnailImageView;
            
        }
    }];
    
    
    
    
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    
    return annotationView;
}






@end