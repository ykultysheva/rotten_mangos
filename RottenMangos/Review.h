//
//  Review.h
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-19.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property NSString *critic;
@property NSString *quote;

-(instancetype)initWithCritic:(NSString*)critic quote:(NSString*)quote;

@end
