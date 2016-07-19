//
//  DetailedViewController.m
//  RottenMangos
//
//  Created by Yana Kultysheva on 2016-07-18.
//  Copyright © 2016 Yana Kultysheva. All rights reserved.
//

#import "DetailedViewController.h"
#import "Review.h"
#import "CustomCell2.h"

@interface DetailedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSMutableArray *reviews;
@property UICollectionViewFlowLayout *firstLayout;

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstLayout = [[UICollectionViewFlowLayout alloc] init];
    self.firstLayout.itemSize = CGSizeMake(400, 200);
    self.firstLayout.minimumLineSpacing = 50;
    self.firstLayout.minimumInteritemSpacing = 25;
    self.firstLayout.sectionInset = UIEdgeInsetsMake(10, 100, 15, 50);
    self.firstLayout.headerReferenceSize = CGSizeMake(0, 100);
    self.firstLayout.footerReferenceSize = CGSizeMake(0, 75);
    
    
    self.CollectionView.collectionViewLayout = self.firstLayout;
    
    
    NSString *url1 = [NSString stringWithFormat:@"%@?apikey=%@", _movie.movieReview, @"2ckft9dtnazuw4ks5qq3uhzu"];
    
    NSString* url2 = [url1 stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    NSLog(@"%@", url2);
    
    
    NSURL *url = [NSURL URLWithString:url2];
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
                
//                NSLog(@"JSON: %@", responseDict);
                
                NSMutableArray *reviews = [NSMutableArray array];
                
                for (NSDictionary *reviewDict in responseDict[@"reviews"]) {
                    NSLog(@"Movie review %@", reviewDict[@"quote"]);
                    Review *review =[[Review alloc] init];
                    review.critic = reviewDict[@"critic"];
                    review.quote = reviewDict[@"quote"];
                
                    
                    
                    [reviews addObject:review];
                }
                
                self.reviews = reviews;
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = [NSString stringWithFormat:@"%ld reviews", reviews.count];
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

    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
    
    
//    self.detailedTitleMovieF.text = self.movie.movieTitle;
//    self.detailedMovieReview.text = self.movie.movieReview;
    
    
    
    
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.reviews.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell2" forIndexPath:indexPath];
    
    
    Review *review = self.reviews[indexPath.row];
    cell.detailedCritic.text = review.critic;
    cell.detailedQuote.text = review.quote;
        
    
    return cell;
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
