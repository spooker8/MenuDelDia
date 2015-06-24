//
//  MapViewController.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITabBarControllerDelegate, MKAnnotation>




@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIWindow *window;


-(void)startCoreLocation;


@end
