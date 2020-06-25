//
//  ViewPhotoViewController.m
//  Tumblr
//
//  Created by Ogo-Oluwasobomi Popoola on 6/25/20.
//  Copyright © 2020 Ogo-Oluwasobomi Popoola. All rights reserved.
//

#import "ViewPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ViewPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end

@implementation ViewPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showPhoto];
}

- (void) showPhoto{
    NSInteger row_number = self.row;
    NSLog(@"%f", row_number);
    NSDictionary *post = self.posts[row_number];
    NSArray *photos = post[@"photos"];
    if (photos){
        NSDictionary *photo = photos[0];
        NSDictionary *originalSize =  photo[@"original_size"];
        NSString *urlString = originalSize[@"url"];
        NSURL *url = [NSURL URLWithString:urlString];
        [self.photoImage setImageWithURL:url];
    }
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
