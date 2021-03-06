//
//  MapViewController.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "MapViewController.h"
#import "NearbyTableViewCell.h"
#import "DetailNearbyViewController.h"
#import "MenuDelDia.h"
#import "Restaurant.h"
#import "User.h"
#import "MyAnnotation.h"



@interface MapViewController ()


@property (weak, nonatomic) IBOutlet UIButton *viewFavActionButton;
@property (weak, nonatomic) IBOutlet UIButton *viewAllActionButton;
@property (nonatomic) BOOL *isFavRestaurant;
@property(nonatomic) BOOL hasUpdateRegion;


@property(strong,nonatomic)NSArray *listOfFavoritedRestaurants;
@property (nonatomic, strong) CLLocation *selectedLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) PFGeoPoint *myGeopoint;
@property (strong, nonatomic) NSMutableArray* photos;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic) int index;


//menu del dia
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) NSMutableArray* menuPhotos;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong,nonatomic) Restaurant* restaurant;


@end



@implementation MapViewController

@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restaurants = [NSMutableArray array];
    
    self.photos = [NSMutableArray array];
    self.menuPhotos = [NSMutableArray array];
    
    [self startCoreLocation];
    
     self.mapView.showsUserLocation = YES;
  //   self.locationManager = [[CLLocationManager alloc]init];

    
    [self loadFavorites];
    [self viewAllRestaurants:self];

   
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
 //   [self.mapView removeAnnotations:self.mapView.annotations];
 //   [self.mapView addAnnotations:self.mapView.annotations];
  
    [self loadFavorites];
    [self viewAllRestaurants:self];
    

}






-(void)viewDidDisappear:(BOOL)animated{
    
    
    [self.locationManager stopUpdatingHeading];
 //   [self.locationManager stopUpdatingLocation];
    
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
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
 
  //  CLLocation *location= locations.lastObject;
   // NSLog(@"didUpdateLocations %@", location);
    
}





- (IBAction)myCurrentLocation:(id)sender {
    
    CLLocationCoordinate2D myCoord = self.mapView.userLocation.coordinate;
    
    MKCoordinateRegion viewRegion =
    
    MKCoordinateRegionMakeWithDistance(myCoord, 300, 300);
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    
}



//-----------------------------------------------------------------------------------------//


- (void)showMenus:(NSArray *)menus
{
    
    
        for (NSInteger i = 0; i < menus.count; i++)
        {
            [self.photos addObject:[NSNull null]];
            [self.menuPhotos addObject:[NSNull null]];
        }
    
    int i = 0;
    for (MenuDelDia *menu in menus) {
        i++;
        
        [self.restaurants addObject:menu.restaurant];
        [self.mapView addAnnotation:menu.restaurant];
        
        PFFile* restaurantePhoto = menu.restaurant[@"imageFile"];
        [self getPhoto:restaurantePhoto atIndex:i];
        
        PFFile* menuPhoto = menu[@"imageFile"];
        [self getMenuPhoto:menuPhoto atIndex:i];

               
    }
    
    
}



#pragma mark MK Annotations Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Restaurant class]])
    {
        
        Restaurant *myRestaurant = (Restaurant *)annotation;
        BOOL isFav = [self.listOfFavoritedRestaurants containsObject:myRestaurant.objectId];
        return [myRestaurant annotationView:isFav];
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> myAnnotation = [view annotation];
    
    if ([myAnnotation isKindOfClass:[Restaurant class]])
    {
       // NSLog(@"Show restaurant");
        
        
        DetailNearbyViewController *controller = [self.storyboard       instantiateViewControllerWithIdentifier:@"pushdetailnearbyviewcontroller"];
        Restaurant *restaurant = (id)myAnnotation;
        
        
        controller.restaurant = restaurant;
        controller.menu = self.menus[[self.restaurants indexOfObject:restaurant]];
        
        [self showViewController:controller sender:self];
        
    }
        
}





- (IBAction)viewAllRestaurants:(id)sender {
    
    
  //  [self.mapView removeAnnotations:self.mapView.annotations];
   // [self.mapView addAnnotations:self.mapView.annotations];
    [self removeAllPinsButUserLocation];

    
    PFQuery *query2 = [MenuDelDia query];
    
    [query2 includeKey:@"restaurant"];
    
    //  [query2 whereKey:@"location" nearGeoPoint:self.restaurantGeopoint];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *menus, NSError *error) {
        if (!error) {
            self.menus = menus;
            [self showMenus:menus];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];
    

    
}




- (IBAction)viewFavRestaurants:(id)sender {
    
 //   [self.mapView removeAnnotations:self.mapView.annotations];
 //   [self.mapView addAnnotations:self.mapView.annotations];
    [self removeAllPinsButUserLocation];
    
    PFQuery* query = [MenuDelDia query];
   

    [query includeKey:@"restaurant"];

    
    NSMutableArray *restaurants = [[NSMutableArray alloc] init];
    
    for (NSString *objectId in self.listOfFavoritedRestaurants) {
        
        Restaurant *restaurant = [Restaurant objectWithoutDataWithObjectId:objectId];
        [restaurants addObject:restaurant];
    }
    
    [query whereKey:@"restaurant" containedIn:restaurants];
    [query findObjectsInBackgroundWithBlock:^(NSArray *menus, NSError *error) {

        
        if (!error) {
            

            [self showMenus:menus];
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];

    
}




//----------------------------------------------------------------------------------------------------//


-(void)getPhoto:(PFFile*)file atIndex:(NSInteger)index
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.photos[index] = image;
        }
    }];
    
}

-(void)getMenuPhoto:(PFFile*)file atIndex:(NSInteger)index
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.menuPhotos[index] = image;
    
            
            
        }
    }];
    
}




#pragma mark delegates from the map

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
  // NSLog(@"Location changed");
    
    if(!_hasUpdateRegion) {
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000.0f,1000.0f);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    
        [self.mapView setRegion:adjustedRegion animated:YES];
        self.hasUpdateRegion = YES;
    }
    
    
    //have a boolean that is only done once.
}





-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
 //   NSLog(@"Region changed");
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
/*    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,250,250);
    
    [mv setRegion:region animated:YES];*/
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mv.userLocation.coordinate, 1000.0f,1000.0f);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
}




- (void)removeAllPinsButUserLocation
{
    id userLocation = [self.mapView userLocation];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    if ( userLocation != nil ) {
        [self.mapView addAnnotation:userLocation]; // will cause user location pin to blink
    }
}


-(void)loadFavorites
{
    
    [self removeAllPinsButUserLocation];
    self.listOfFavoritedRestaurants = [PFUser currentUser][@"favorite"];
    
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
