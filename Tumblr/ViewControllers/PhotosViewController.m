//
//  PhotosViewController.m
//  Tumblr
//
//  Created by Ogo-Oluwasobomi Popoola on 6/25/20.
//  Copyright © 2020 Ogo-Oluwasobomi Popoola. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "ViewPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *posts;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 240;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updatePhotoFeeds) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
    
    [self updatePhotoFeeds];
}

-(void) updatePhotoFeeds{
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *responseDictionary = dataDictionary[@"response"];
                self.posts = responseDictionary[@"posts"];
                [self.tableView reloadData];
            }
        [self.refreshControl endRefreshing];
        }];
    [task resume];
}

/*
#pragma mark - Navigation
*/

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    NSDictionary *post = self.posts[indexPath.row];
    NSArray *photos = post[@"photos"];
        if (photos){
            NSDictionary *photo = photos[0];
            NSDictionary *originalSize =  photo[@"original_size"];
            NSString *urlString = originalSize[@"url"];
            NSURL *url = [NSURL URLWithString:urlString];
            [cell.photoImageView setImageWithURL:url];
        }
        return cell;
    }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *selectedPost = self.posts[indexPath.row];

    ViewPhotoViewController *viewPhotoViewController = [segue destinationViewController];
    viewPhotoViewController.posts = self.posts;
    viewPhotoViewController.row = indexPath.row;
}

@end
