//
//  TheaterMap.h
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-19.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Theater.h"

@interface TheaterMap : UIViewController

@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) Theater *theater;

@end
