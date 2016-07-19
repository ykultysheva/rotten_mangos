//
//  Movie.h
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-18.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKIT/UIKIT.h>

@interface Movie : NSObject

@property NSString *movieTitle;
@property NSString *movieYear;
@property UIImage *movieImage;
@property NSString *movieReview;

-(instancetype)initWithTitle:(NSString*)title year:(NSString*)year image:(UIImage*)image;


@end
