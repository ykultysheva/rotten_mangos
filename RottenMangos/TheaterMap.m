//
//  TheaterMap.m
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-19.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import "TheaterMap.h"
@import CoreLocation;
@import MapKit;
#import "Theater.h"



@interface TheaterMap () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL shouldZoomIntoUser;
@property NSString* postalCode;
@property NSArray* theaters;


@end

@implementation TheaterMap

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shouldZoomIntoUser = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.MapView.delegate = self;
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addTheaters:(NSString*)postalCode {

    NSString *url1 = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", postalCode, self.movie.movieTitle];
    
    NSLog(@"%@", url1);
    
    
    NSURL *url = [NSURL URLWithString:url1];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonError;
            
            //            NSArray *movieArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
            if (!jsonError) {
                
                NSMutableArray *theaters = [NSMutableArray array];
                
                for (NSDictionary *theaterDict in responseDict[@"theatres"]) {
                 
                    
                    Theater *theater =[[Theater alloc] init];
                    theater.name = theaterDict[@"name"];
                    theater.address = theaterDict[@"address"];
                    
//                    Theater *marker = [[Theater alloc] init];

                    
                    CLLocationDegrees lat = [theaterDict[@"lat"] doubleValue];
                    CLLocationDegrees lng = [theaterDict[@"lng"] doubleValue];
                    
                    NSLog(@"Latitude: %f", lat);
                    NSLog(@"Longitude: %f", lng);
                    
                    theater.coordinate = CLLocationCoordinate2DMake(lat, lng);
                    theater.title = theaterDict[@"name"];
                    theater.subtitle = theaterDict[@"address"];
                    
                    [self.MapView addAnnotation:theater];

//                    
                    
                    
                    [theaters addObject:theater];
                }
                
                self.theaters = theaters;
                
                NSLog(@"%@", theaters);
                
                
                
                
            }
            
            
        } else {
            NSLog(@"Request error: %@", error.localizedDescription);
        }
        
    }];
    
    //    NSLog(@"A. Before request starts");
    [dataTask resume];
    //    NSLog(@"B. After request starts");
    
    
    
//    
    
    
    
    
//    NSString *jsonPath =[[NSBundle mainBundle] pathForResource:@"bikeStations" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
//    
//    NSError *error = nil;
//    NSDictionary *stationDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//    if (!error) {
//        NSArray *stations = stationDict[@"stations"][@"station"];
//        for (NSDictionary *station in stations) {
//            
//            BikeStation *marker = [[BikeStation alloc] init];
//            
//            marker.coordinate = CLLocationCoordinate2DMake([station[@"lat"] doubleValue], [station[@"long"] doubleValue]);
//            marker.title = station[@"name"];
//            marker.subtitle = station[@"terminalName"];
//            
//            [self.mapView addAnnotation:marker];
//            
//        }
//    }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization Changed to: %d", status);
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Authorized!");
        
        self.MapView.showsUserLocation = YES;
        self.MapView.showsPointsOfInterest = YES;
        
        [self.locationManager startUpdatingLocation];
        
        //[self.locationManager requestLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"New locations: %@", locations);
//    [self.locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    
    if (self.shouldZoomIntoUser) {
        self.shouldZoomIntoUser = NO;
        
        CLLocationCoordinate2D coordinate = currentLocation.coordinate;
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.001, 0.001));
        [self.MapView setRegion:region animated:YES];
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
             
             NSString *postalCode1 = [[NSString alloc]initWithString:placemark.postalCode];
             
             NSString* postalCode2 = [postalCode1 stringByReplacingOccurrencesOfString:@" " withString:@""];
             
             
             NSLog(@"%@",postalCode2);
             
             [self addTheaters:postalCode2];
            
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error); // Error handling must required
         }
         
         
         
         
         
     }];
    
    
    
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location error: %@", error.localizedDescription);
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
