//
//  RestaurantViewController.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "MapViewController.h"
#import "NearbyTableViewCell.h"
#import "MenuDelDia.h"
#import "Restaurant.h"
#import "User.h"


@interface MapViewController ()

@property (nonatomic, strong) CLLocation *selectedLocation;

@property (nonatomic) PFGeoPoint *myGeopoint;

@property (strong, nonatomic) NSMutableArray* photos;
@property (strong, nonatomic) PFUser *user;



//menu del dia
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) NSMutableArray* menuPhotos;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self startCoreLocation];
     self.mapView.showsUserLocation = YES;
    
    [self myAnnotation];


   
}


-(void)viewDidDisappear:(BOOL)animated{
    
    
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
    
}


-(void)startCoreLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled])
        
    {
        
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            
        {
            
            
            [self.locationManager requestWhenInUseAuthorization];
            
            
            
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy =
            kCLLocationAccuracyBest;
            
            [self.locationManager startUpdatingLocation];
            
            
            if ([CLLocationManager headingAvailable]) {
                
                [self.locationManager startUpdatingHeading];
                
            }
            
            
        }
        
    }}


//LOCATION MANAGER
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    
//    
//    CLLocation *location= locations.lastObject;
//    
//  //  NSLog(@"didUpdateLocations %@", location);
//    
//    
//}


#pragma mark MK Annotations Delegate Methods


-(void)myAnnotation
{
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"MenuDelDia"];
    
    [query2 includeKey:@"restaurant"];
    
    //  [query2 whereKey:@"location" nearGeoPoint:self.restaurantGeopoint];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *menus, NSError *error) {
        if (!error) {
            // The find succeeded.
               NSLog(@"Successfully retrieved %lu scores.", menus.count);
            // Do something with the found objects
            
            //query the latest date menu and the latest
            
            self.menus = menus;
            //      [self.tableView reloadData];
            
            self.photos = [NSMutableArray array];
            self.menuPhotos = [NSMutableArray array];
            
            for (NSInteger i = 0; i < menus.count; i++)
            {
                [self.photos addObject:[NSNull null]];
                [self.menuPhotos addObject:[NSNull null]];
            }
            
            
            for (NSInteger i = 0; i < menus.count; i++)
            {
                MenuDelDia *menu = menus[i];
                
                PFFile* file = menu.restaurant[@"imageFile"];
                [self getPhoto:file atIndex:i];
                
                PFFile* file2 = menu[@"imageFile"];
                [self getMenuPhoto:file2 atIndex:i];
            }
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
       
        for (int i = 0; i < [self.menus count]; i++) {
            
            PFGeoPoint *tempGeo = self.menus [@"location"];
            NSLog(@"%@",tempGeo);
        }
        

        
    }];

    
   
    
    
 
    
    
    
    
        
        
    //    PFGeoPoint *restaurantGeopoint = menu.restaurant.location;
        
        
    //    MenuDelDia *menu = self.menus[indexPath.row];

    //    PFGeoPoint *restaurantGeopoint = menu.restaurant.location;


    
//        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(tempGeo.latitude, tempGeo.longitude);
//        MapAnnotation *annotation = [[MapAnnotation alloc] init];
//        annotation.coordinate = annotationCoordinate;
//        //        annotation.title = location[@"Name"];
//        //        annotation.subtitle = location[@"Place"];
//        [self.mapView addAnnotation:annotation];
    
    
//    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
//    myAnnotation.coordinate = CLLocationCoordinate2DMake(41.412645, 2.166501);
//    myAnnotation.title = @"Matthews Pizza";
//    myAnnotation.subtitle = @"Best Pizza in Town";
//    [self.mapView addAnnotation:myAnnotation];
    
}





-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Pizza Shop");
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"foodicon"];
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foodicon"]];
            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}




- (IBAction)myCurrentLocation:(id)sender {
    
    
    
    CLLocationCoordinate2D myCoord = self.mapView.userLocation.coordinate;
    
    
    MKCoordinateRegion viewRegion =
    
    MKCoordinateRegionMakeWithDistance(myCoord, 10, 10);
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    
}



- (IBAction)viewAllRestaurants:(id)sender {
    
    
    
}



- (IBAction)viewFavRestaurants:(id)sender {
    
    
    
    
}




-(void)loadMenuDelDiaData

{
    
}



-(void)getPhoto:(PFFile*)file atIndex:(NSInteger)index
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.photos[index] = image;
            
     //       [self.tableView reloadData];
            
            
        }
    }];
    
}

-(void)getMenuPhoto:(PFFile*)file atIndex:(NSInteger)index
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.menuPhotos[index] = image;
         //   [self.tableView reloadData];
            
            
        }
    }];
    
}




#pragma mark delegates from the map

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
  //  NSLog(@"Location changed");
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000.0f,1000.0f);
    
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
  //  NSLog(@"Region changed");
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.mapView setShowsUserLocation:YES];
    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}





- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,250,250);
    
    [mv setRegion:region animated:YES];
}





//#pragma  mark Custom Annotations
//
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    
//    MKAnnotationView *mkView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myCoolBars"];
//    
//    if (!mkView) {
//        
//        
//        mkView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myCoolBars"];
//        
//        
//    }
//    
//    
//    if (annotation == mapView.userLocation) {
//        mkView.image = [UIImage imageNamed:@"21-skull"];
//        
//    } else if ([annotation isKindOfClass:[CoolBar class]]){
//        
//        
//        CoolBar *bar = (CoolBar *)annotation;
//        
//        switch (bar.type) {
//                
//            case class_bar:
//                mkView.image = [UIImage imageNamed:@"21-skull"];
//                break;
//                
//                
//            case discoteque:
//                mkView.image = [UIImage imageNamed:@"08-chat"];
//                break;
//                
//            case piano_bar:
//                mkView.image =[UIImage imageNamed:@"10-medical"];
//                break;
//                
//            case tapas_bar:
//                mkView.image = [UIImage imageNamed:@"08-medical"];
//                break;
//                
//                
//        }
//        
//        
//        [mkView setCanShowCallout:YES];
//        mkView.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        
//        
//        
//    }
//    
//    return mkView;
//    
//}


//-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
//{
//    
//    for (MKAnnotationView *annView in annotationViews)
//    {
//        
//        CGRect endFrame = annView.frame;
//        annView.frame = CGRectOffset(endFrame, 0, 10);
//        
//        [UIView animateWithDuration:2 animations:^{
//            annView.frame = endFrame;
//        }];
//        
//    }
//    
//}



//-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    
//    NSLog(@"callout tapped");
//    
//}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
  //  NSLog(@"pin dropped ");
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
