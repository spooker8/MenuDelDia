//
//  DetailNearbyViewController.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/16/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "DetailNearbyViewController.h"
#import "NearbyTableViewCell.h"
#import "User.h"
#import "Restaurant.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface DetailNearbyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) BOOL clicked;
@property (nonatomic) BOOL favoriteCheck;
@property (strong, nonatomic) NSArray *checkData;

@end

@implementation DetailNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
       
    self.restaurantNameLabel.text = self.restaurant.name;
    self.addressLabel.text = self.restaurant.address;
    self.websiteLabel.text = self.restaurant.website;
    self.phoneNoLabel.text = self.restaurant.telno;
    
    self.menuDelDiaImage.image = self.detailMenuDelDiaImage;
   
    self.restaurantID = self.restaurant.objectId;
    
    
    [self getMenuPhoto:self.menu[@"imageFile"]];
    
    
   
    [self isFav];
   

}


-(void)getMenuPhoto:(PFFile*)file
{
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.menuDelDiaImage.image = image;
            
            
            
        }
    }];
    
}

-(void)isFav
{
    
  
    PFUser *currentUser = [PFUser currentUser];
   
    self.checkData = currentUser[@"favorite"];
   
   // NSLog(@"the datas are %@",checkData);
 
      
            if ([self.checkData containsObject:self.restaurantID])
            {
                NSLog(@"%@  is made favorite",self.restaurantID);
                _favoriteCheck = YES;
                
                [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_button setTitle:@"Fav On" forState:UIControlStateNormal];
                [_button setBackgroundColor:[UIColor redColor]];
                
                
            }
            
            
            else
            {
                NSLog(@"%@ is not made favorite",self.restaurantID);
                _favoriteCheck = NO;
                [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_button setTitle:@"Fav Off" forState:UIControlStateNormal];
                [_button setBackgroundColor:[UIColor whiteColor]];
                
                
            }
            
 

    }



//method to switch the favbutton
- (IBAction)switchFavState:(id)sender {
    
  
    if (!_favoriteCheck){
    
        
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitle:@"Fav On" forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor redColor]];
       
        
        _favoriteCheck = YES;
      
        [self saveFavoriteToParse];
        
        
    } else {
        
        
         [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [_button setTitle:@"Fav Off" forState:UIControlStateNormal];
         [_button setBackgroundColor:[UIColor whiteColor]];
        
        
        _favoriteCheck = NO;
        
        [self removeFromFavorite];
    }
    
    
}

- (IBAction)gotoMapAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://%@",self.myGeopoint]]];
    NSLog(@"%@",self.myGeopoint);
    
    
    
}

- (IBAction)gotoWebsiteAction:(id)sender {
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.websiteURL]];
}

- (IBAction)gotoCallAction:(id)sender {
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phoneLabel]]];
    
    
}




-(void)saveFavoriteToParse {
    
     PFUser *user = [PFUser currentUser];
    
    [user addObject:self.restaurantID forKey:@"favorite"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"save");
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
    

    
}


-(void)removeFromFavorite
{
    
    PFUser *user = [PFUser currentUser];
    
    [user removeObject:self.restaurantID forKey:@"favorite"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"remove");
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];

    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
