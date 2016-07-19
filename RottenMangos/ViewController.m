//
//  ViewController.m
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-18.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "CustomCell.h"
#import "DetailedViewController.h"
@import MapKit;
@import CoreLocation;


@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *CollectionViewFlowLayout;
@property UICollectionViewFlowLayout *firstLayout;
@property NSMutableArray *movies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.firstLayout = [[UICollectionViewFlowLayout alloc] init];
    self.firstLayout.itemSize = CGSizeMake(400, 200);
    self.firstLayout.minimumLineSpacing = 50;
    self.firstLayout.minimumInteritemSpacing = 25;
    self.firstLayout.sectionInset = UIEdgeInsetsMake(10, 100, 15, 50);
    self.firstLayout.headerReferenceSize = CGSizeMake(0, 100);
    self.firstLayout.footerReferenceSize = CGSizeMake(0, 75);
    
    
    self.CollectionView.collectionViewLayout = self.firstLayout;

    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=2ckft9dtnazuw4ks5qq3uhzu&page_limit=50"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSLog(@"C. Request Done");
        
        if (!error) {
//             NSLog(@"Data: %@", data);
            
            NSError *jsonError;
            
//            NSArray *movieArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            
            
            
            if (!jsonError) {
                
                NSLog(@"JSON: %@", responseDict);
                
                NSMutableArray *movies = [NSMutableArray array];

                for (NSDictionary *movieDict in responseDict[@"movies"]) {
                    NSLog(@"Movie title %@", movieDict[@"title"]);
                    Movie *movie =[[Movie alloc] init];
                    movie.movieTitle = movieDict[@"title"];
                    movie.movieYear = movieDict[@"year"];
                    
                    NSString *imageString = movieDict[@"posters"][@"thumbnail"];
                    NSURL *aURL = [NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                    UIImage *aImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
                    movie.movieImage = aImage;
                    movie.movieReview = movieDict[@"links"][@"reviews"];
                    
                    
                    [movies addObject:movie];
                }
                
                self.movies = movies;

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = [NSString stringWithFormat:@"%ld movies", movies.count];
                    [self.CollectionView reloadData];
                });
                
            }

            
        } else {
            NSLog(@"Request error: %@", error.localizedDescription);
        }
        
    }];
    
    NSLog(@"A. Before request starts");
    [dataTask resume];
    NSLog(@"B. After request starts");
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return self.responseDict.allKeys.count;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
    

    Movie *movie = self.movies[indexPath.row];
    cell.detailsLabel.text = movie.movieTitle;
    cell.imageView.image = movie.movieImage;
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ToDetailed"]) {
        NSIndexPath *indexPath = [self.CollectionView indexPathForCell:sender];
        
        
//        NSString *key = self.currentKeys[indexPath.item];
//        NSArray *arr = self.currentDictionary[key];
        
        Movie *detailedMovie = self.movies[indexPath.item];
        
        DetailedViewController *dvc = (DetailedViewController *)[segue destinationViewController];
        
        dvc.movie = detailedMovie;
        
    }
}



@end
