//
//  Theater.h
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-19.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Theater : NSObject <MKAnnotation>

@property NSString *name;
@property NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(instancetype)initWithName:(NSString*)name address:(NSString*)address;

@end
