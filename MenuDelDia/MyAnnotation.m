//
//  RestaurantsList.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/22/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "MyAnnotation.h"
#import "Restaurant.h"


@implementation MyAnnotation


-(id)initWithTitle:(NSString *)newTitle isFav:(BOOL *)isFav subTitle:(NSString *)subTitle location:(CLLocationCoordinate2D)location menu:(MenuDelDia*)menu
{
   
    self = [super init];
    
    if(self)
    {
        
        _title= newTitle;
         _isFav = isFav;
        _subtitle = subTitle;
        _coordinate = location;
        _menu = menu;
        _objectID = menu.restaurant.objectId;
        
        
    
    }
    
    return self;
    
}



-(MKAnnotationView *)annotationView
{
  
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyAnnotation"];
    
   
    
    if (_isFav) {
        annotationView.image = [UIImage imageNamed:@"foodicon"];
       
    }
    
    if (!_isFav) {
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
