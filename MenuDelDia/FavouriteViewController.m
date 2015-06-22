//
//  FavouriteViewController.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/17/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <Parse/Parse.h>
#import "Restaurant.h"
#import "MenuDelDia.h"
#import "User.h"
#import "FavouriteViewControllerTableViewCell.h"
#import "FavouriteViewController.h"
#import "DetailNearbyViewController.h"

@interface FavouriteViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong,nonatomic)NSArray *listOfFavoritedRestaurants;





@property (strong, nonatomic) PFUser *user;

//menu del dia
@property (strong, nonatomic) NSArray *listOfRestaurantsIsFav;
@property (strong, nonatomic) NSMutableArray* menuPhotos;

@property (strong, nonatomic) NSMutableArray* photos;



@property (nonatomic, strong) NSIndexPath* lastSelectedIndex;
@property (weak, nonatomic) IBOutlet UITableView* tableView;


@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // You code here to update the view.
    
    
    
    [self loadFavorites];
    [self loadMenuDelDia];


    [self.tableView reloadData];

    
    
    
}







-(void)loadFavorites
{
    
    PFQuery *query = [PFUser query];
    
    [query includeKey:@"favorite"];
    
    NSArray *listOfFavoritedRestaurants  = [query findObjects];
    
  //  [query findObjectsInBackgroundWithBlock:^(NSArray *checkData, NSError *error) {
        
    listOfFavoritedRestaurants  = [[NSArray alloc]initWithArray:[PFUser currentUser][@"favorite"]];
    
        //    NSLog(@"the datas are %@",checkData);
        
        self.listOfFavoritedRestaurants = listOfFavoritedRestaurants ;
    
}



-(void)loadMenuDelDia
{
  
         PFQuery* query = [MenuDelDia query];
        //[query whereKey:@"restaurant" containedIn:self.listOfFavoritedRestaurants];
    
    
    NSMutableArray *restaurants = [[NSMutableArray alloc] init];
    
    for (NSString *objectId in self.listOfFavoritedRestaurants){
        
        Restaurant *restaurant = [Restaurant objectWithoutDataWithObjectId:objectId];
        [restaurants addObject:restaurant];
    }
    
    self.listOfRestaurantsIsFav = @[];
    
    [query whereKey:@"restaurant" containedIn:restaurants];
    
        [query findObjectsInBackgroundWithBlock:^(NSArray *listOfRestaurantsisFav, NSError *error) {
            if (!error) {
                
                
            NSLog(@"%@",listOfRestaurantsisFav);
                
                
                
                // Do something with the found objects
                
                //query the latest date menu and the latest
                
                self.listOfRestaurantsIsFav = listOfRestaurantsisFav;
                self.photos = [NSMutableArray array];
                self.menuPhotos = [NSMutableArray array];
                
                for (NSInteger i = 0; i < listOfRestaurantsisFav.count; i++)
                {
                    [self.photos addObject:[NSNull null]];
                    [self.menuPhotos addObject:[NSNull null]];
                }
                
                
                for (NSInteger i = 0; i < listOfRestaurantsisFav.count; i++)
                {
                    MenuDelDia *menu = listOfRestaurantsisFav[i];
                    
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

    


#pragma mark - tableview section

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return [self.listOfRestaurantsIsFav count];
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    FavouriteViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoritecell"];
    
    
    MenuDelDia *menu = self.listOfRestaurantsIsFav[indexPath.row];
    
    if (self.photos.count > indexPath.row && self.photos[indexPath.row] != [NSNull null])
    {
        UIImage *image = self.photos[indexPath.row];
        cell.restaurantImage.image = image;
    }
    
  
    cell.restaurantNameLabel.text = menu.restaurant.name;
    

    
    MenuDelDia *menuDelDiaModel = self.listOfRestaurantsIsFav[indexPath.row];
    cell.priceLabel.text = menuDelDiaModel.price;
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuDelDia *showMenu = self.listOfRestaurantsIsFav[indexPath.row];
    
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
  //  menuVC.myGeopoint = showMenu.restaurant.location;
    
    //   menuVC.restaurant = showMenu.restaurant;
    
    [self.navigationController pushViewController:menuVC animated:YES];
    
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    if ([self.listOfRestaurants count]) {
//        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        return 1;
//        
//    } else {
//        
//        // Display a message when the table is empty
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
//        messageLabel.textColor = [UIColor blackColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        
//        self.tableView.backgroundView = messageLabel;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//    }
//    
//    return 0;
//}




//old find all data method.
// The find succeeded.
//      NSLog(@"Successfully retrieved %lu scores.", menus.count);



//                for (int i = 0; i < [self.listOfFavoritedRestaurants count]; i++) {
//
//                    if (![menus containsObject:self.listOfFavoritedRestaurants]) {
//                        NSLog(@"yes");
//
//                        NSMutableArray *listOfData = [[NSMutableArray alloc] initWithArray:[menus containsObject:self.listOfFavoritedRestaurants]];
//
//
//
//                    }
//                    else {
//
//                         NSLog(@"no");
//                    }
//
//
//                }

//  if([collection containsObject:tempItem])






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
