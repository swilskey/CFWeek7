//
//  MyProfileViewController.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverflowService.h"
#import "User.h"
#import "ImageDownloader.h"

@interface MyProfileViewController ()
@property (assign, nonatomic) IBOutlet UIImageView *userImageView;
@property (assign, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain,nonatomic) NSOperationQueue *imageQueue;
@property (retain,nonatomic) User *user;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.imageQueue = [[NSOperationQueue alloc] init];
  [StackOverflowService userAccountForAuthenticatedUser:^(User *user, NSError *error) {
    self.user = [[User alloc] init];
    self.user.username = user.username;
    self.user.profileImageURL = user.profileImageURL;
    
    self.usernameLabel.text = self.user.username;
    [self.imageQueue addOperationWithBlock:^{
      self.user.userImage = [ImageDownloader downloadImage:self.user.profileImageURL];
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.userImageView.image = self.user.userImage;
      }];
    }];
    
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [_imageQueue release];
  [_user release];
  [super dealloc];
}

@end
