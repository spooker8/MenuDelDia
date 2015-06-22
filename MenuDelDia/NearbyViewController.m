//
//  NearbyViewController.m
//  
//
//  Created by Anand Kumar on 6/15/15.
//
//

#import "NearbyViewController.h"
#import "NearbyTableViewCell.h"
#import "DetailNearbyViewController.h"
#import "Restaurant.h"
#import "MenuDelDia.h"



@interface NearbyViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate, UITabBarControllerDelegate>


@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray* photos;
@property (nonatomic) PFGeoPoint *myGeopoint;
@property (strong, nonatomic) PFUser *user;



//menu del dia
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) NSMutableArray* menuPhotos;



@property (nonatomic, strong) NSIndexPath* lastSelectedIndex;
@property (weak, nonatomic) IBOutlet UITableView* tableView;



@property (strong, nonatomic) CLLocationManager *locationManager;




@end



@implementation NearbyViewController

@synthesize locationManager;




-(void)viewDidAppear:(BOOL)animated
{
 
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser]) {
   //     NSLog(@"user logged in");
    } else {
     //   NSLog(@"not logged in");
        [self performSegueWithIdentifier:@"checklogin" sender:self];
        
    }


    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self startCoreLocation];
    [self loadMenuDelDiaData];
    [self.tableView reloadData];
    [self photos];
    [self menuPhotos];
    [self refreshUIControl];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    // self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)refresh:(UIRefreshControl *)refreshControl{
    
    // Reload table data
    [self.tableView reloadData];
    [self loadMenuDelDiaData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;

    
    [self.refreshControl endRefreshing];
    
}
}

-(void)refreshUIControl{
    
    // Initialize the refresh control.
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    
    [self.refreshControl addTarget:self
                         action:@selector(refresh:)
                      forControlEvents:UIControlEventValueChanged];
    
    
    [self.tableView addSubview:self.refreshControl];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    
    [self.locationManager stopUpdatingHeading];
    
    
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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    CLLocation *location= locations.lastObject;
    
   //   NSLog(@"didUpdateLocations %@", location);
    
    
    
   // self.restaurantLatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    
   // self.restaurantLatitude = location.coordinate.latitude;
   // self.restaurantLongitude =location.coordinate.longitude;
    
     CLLocation *LocationActual = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    // self.restaurantGeopoint = LocationAtual;
    
    //converted geopoint data
    PFGeoPoint *myGeoPoint = [PFGeoPoint geoPointWithLocation:(CLLocation *)LocationActual];
    
    self.myGeopoint = myGeoPoint;
    
  //  NSLog(@"%@",restaurantGeoPoint);
    
    
    
    // calculate distance [location distance from Location : (const CLLocation *)];
    
}




-(void)getPhoto:(PFFile*)file atIndex:(NSInteger)index
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.photos[index] = image;
            
            [self.tableView reloadData];
            
            
        }
    }];
    
}

-(void)getMenuPhoto:(PFFile*)file atIndex:(NSInteger)index
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.menuPhotos[index] = image;
            [self.tableView reloadData];
            
            
        }
    }];
    
}





-(void)loadMenuDelDiaData

{
    PFQuery *query2 = [PFQuery queryWithClassName:@"MenuDelDia"];
 
    [query2 includeKey:@"restaurant"];
    
 //  [query2 whereKey:@"location" nearGeoPoint:self.restaurantGeopoint];
   
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *menus, NSError *error) {
        if (!error) {
            // The find succeeded.
            //    NSLog(@"Successfully retrieved %lu scores.", objects.count);
            // Do something with the found objects
            
            //query the latest date menu and the latest 
            
            self.menus = menus;
            [self.tableView reloadData];
            
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
        
        
     
    }];
    
    
    
}


#pragma mark - tableview section

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.menus count]) {
        return [self.menus count];
    }
    
    return 0;
    
    
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearbycell"];
    
 
    MenuDelDia *menu = self.menus[indexPath.row];

    if (self.photos.count > indexPath.row && self.photos[indexPath.row] != [NSNull null])
    {
        UIImage *image = self.photos[indexPath.row];
        cell.restaurantImage.image = image;
    }
    

    
    cell.restaurantNameLabel.text = menu.restaurant.name;
    
    PFGeoPoint *restaurantGeopoint = menu.restaurant.location;
    
  //  NSLog(@"%@",self.myGeopoint);
   // NSLog(@"%@",restaurantGeopoint);
    
    double distanceDouble  = [self.myGeopoint distanceInKilometersTo:restaurantGeopoint];
  //  NSLog(@"Distance: %.1f",distanceDouble);
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f KM",distanceDouble];

                               
    MenuDelDia *menuDelDiaModel = self.menus[indexPath.row];
    cell.priceLabel.text = menuDelDiaModel.price;
    
  
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       MenuDelDia *showMenu = self.menus[indexPath.row];
    
    DetailNearbyViewController *menuVC = [self.storyboard
                instantiateViewControllerWithIdentifier:@"pushdetailnearbyviewcontroller"];
    
   
        if (self.menuPhotos.count > indexPath.row && self.menuPhotos[indexPath.row] != [NSNull null])
        {
            UIImage *image = self.menuPhotos[indexPath.row];
            menuVC.detailMenuDelDiaImage = image;
        }
    
    
        menuVC.restaurantName = showMenu.restaurant.name;
        menuVC.addressName = showMenu.restaurant.address;
        menuVC.websiteURL = showMenu.restaurant.website;
        menuVC.phoneLabel= showMenu.restaurant.telno;
        menuVC.restaurantID = showMenu.restaurant.objectId;
        menuVC.myGeopoint = showMenu.restaurant.location;

     //   menuVC.restaurant = showMenu.restaurant;
    
        [self.navigationController pushViewController:menuVC animated:YES];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self.menus count]) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}





- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)viewController popToRootViewControllerAnimated:YES];
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
