//
//  FavouriteViewControllerTableViewCell.h
//  MenuDelDia
//
//  Created by Anand Kumar on 6/21/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavouriteViewControllerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;

@end
