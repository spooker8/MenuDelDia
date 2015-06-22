//
//  NearbyTableViewCell.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/16/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "NearbyTableViewCell.h"

@implementation NearbyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.restaurantImage.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
