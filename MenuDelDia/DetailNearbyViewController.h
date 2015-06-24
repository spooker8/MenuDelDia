//
//  DetailNearbyViewController.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/16/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Restaurant.h"
#import "MenuDelDia.h"


@interface DetailNearbyViewController : UIViewController



@property (strong, nonatomic) UIImage *detailMenuDelDiaImage;
@property (weak, nonatomic) IBOutlet UIImageView *menuDelDiaImage;

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;


@property (strong,nonatomic) NSString *restaurantID;
@property (strong,nonatomic) NSString *restaurantName;
@property (strong,nonatomic) NSString *addressName;
@property (strong,nonatomic) NSString *websiteURL;
@property (strong,nonatomic) NSString *phoneLabel;
@property (nonatomic) PFGeoPoint *myGeopoint;

@property (strong,nonatomic) Restaurant* restaurant;
@property (strong,nonatomic) MenuDelDia* menu;



//@property (strong, nonatomic) NSArray *selectedRestaurantMenuDelDia;
@property (strong, nonatomic) NSArray *arrayRestaurantID;
@property (strong, nonatomic) NSMutableArray *muteArrayRestaurantID;
@property (strong, nonatomic) NSArray *checkRestaurantIDArray;



@end
