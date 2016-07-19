//
//  DetailedViewController.h
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-18.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailedViewController : UIViewController
//@property (strong, nonatomic) IBOutlet UIView *detailedImageView;
//@property (strong, nonatomic) IBOutlet UIView *detailedMovieTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *CollectionViewFlowLayout;


@property (strong, nonatomic) Movie *movie;


@end
