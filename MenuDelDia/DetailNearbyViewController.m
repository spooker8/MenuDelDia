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


@end

@implementation DetailNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
       
    self.restaurantNameLabel.text = self.restaurantName;
    self.addressLabel.text = self.addressName;
    self.websiteLabel.text = self.websiteURL;
    self.phoneNoLabel.text = self.phoneLabel;
    
    self.menuDelDiaImage.image = self.detailMenuDelDiaImage;
   
    self.restaurantID = self.restaurantID;
    
    
    
    
    
   
    [self isFav];
   

}


-(void)isFav
{
    
  
    PFQuery *query = [PFUser query];
  
   [query findObjectsInBackgroundWithBlock:^(NSArray *checkData, NSError *error) {
       
   
    checkData = [[NSArray alloc]initWithArray:[PFUser currentUser][@"favorite"]];
   
   // NSLog(@"the datas are %@",checkData);
 
      
            if ([checkData containsObject:self.restaurantID])
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
            
       
        
//        for (int i = 0 ; i < [muteCheckRestID count];  i++)
//            
//        {
//            
//            if ([[muteCheckRestID objectAtIndex:i] isEqualToString:self.restaurantID])
//            {
//                NSLog(@"%@ this restaurant is made favorite",self.restaurantID);
//                [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                 [_button setTitle:@"Fav On" forState:UIControlStateSelected];
//                [_button setBackgroundColor:[UIColor redColor]];
//            }
//            
//            
//            else
//            {
//                NSLog(@"%@ this restaurant is not made favorite",self.restaurantID);
//                [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [_button setTitle:@"Fav Off" forState:UIControlStateNormal];
//                [_button setBackgroundColor:[UIColor whiteColor]];
//
//                
//            }
//            
//        }

        
        
        
        
        
    //   NSArray *checkIfExist = [NSArray alloc]initWithArray:[[PFUser currentUser][@"favorite"] ];
//                                                                                  
//        
//        
//        if ([PFUser currentUser][@"favorite"] == self.restaurantID) {
//
//        }
//        
//
//
//
    }];

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
    
    
//    
//    ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&q=%f,%f",mosqueLocation.latitude,mosqueLocation.longitude, mosqueLocation.latitude,mosqueLocation.longitude]];
//        [[UIApplication sharedApplication] openURL:url];
//    } else {
//        NSLog(@"Can't use comgooglemaps://");
//    }
    
    
    
}

- (IBAction)gotoWebsiteAction:(id)sender {
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.websiteURL]];
}

- (IBAction)gotoCallAction:(id)sender {
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phoneLabel]]];
    
    
}




//-(void)makeFavorite {
//    
//    
//
//     PFUser *user = [PFUser currentUser];
//    
//     PFQuery *query = [PFUser query];
//
//   // NSLog(@"%@",user);
//
//    // [query includeKey:@"favorite"];
//   //  [query selectKeys:@[@"favorite"]];
//    
//    
//  //  [query includeKey:@"favorite"];
// [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error) {
//     
//      if (!error) {
//  
//    NSArray *restaurantID = user[@"favorite"];
//    
//   // NSLog(@"%@",[PFUser currentUser][@"favorite"]);
//     NSLog(@"%@",restaurantID);
//     
//          NSMutableArray *muterestArray = [[NSMutableArray alloc]initWithArray:restaurantID];
//          
//          self.muteArrayRestaurantID = muterestArray;
//          
//          [self.muteArrayRestaurantID addObject:self.restaurantID];
//          
//          NSArray *nsArrayofMuteArray = [[NSArray alloc] initWithArray:self.muteArrayRestaurantID];
//          
//          self.arrayRestaurantID = nsArrayofMuteArray;
//          
//          NSLog(@"%@",self.arrayRestaurantID);
//      }
//      else {
//          NSLog(@"error");
//      }
//
//     
// }];
//    
//}


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




//PFQuery *query = [PFUser query];
//[query whereKey:@"gender" equalTo:@"female"]; // find all the women
//NSArray *girls = [query findObjects];

//    
//    self.muteArrayRestaurantID = [[NSMutableArray alloc] init];
//    [self.muteArrayRestaurantID addObject:self.restaurantID];
//    
//    NSArray *restaurantIDArray = [[NSArray alloc] initWithArray:self.muteArrayRestaurantID];
//    
//    NSLog(@"%@",restaurantIDArray);
//    
//    PFObject *user = [PFObject objectWithClassName:@"Restaurants"];
//    user.
//    

    
//    PFUser *user = [PFUser user];
//    user.username = self.usernameField.text;
//    
//     menuDelDia[@"restaurant"] = self.selRest;
//    
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // Hooray! Let them use the app now.
//                   } else {
//            NSString *errorString = [error userInfo][@"error"];
//            NSLog(@"error: %@", errorString);
//                    }
//    }];
//    
//    
//    
//}





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
