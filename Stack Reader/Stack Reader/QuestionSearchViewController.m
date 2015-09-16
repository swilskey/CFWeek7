//
//  QuestionSearchViewController.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "ImageDownloader.h"
#import "QuestionCell.h"
#import "Question.h"

@interface QuestionSearchViewController () <UISearchBarDelegate, UITableViewDataSource>
@property (weak,nonatomic) IBOutlet UITableView *questionTableView;
@property (weak,nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *questions;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.questionTableView.dataSource = self;
  self.searchBar.delegate = self;
  [self.questionTableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QuestionCell"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSLog(@"Button Clicked");
  [searchBar resignFirstResponder];
  [StackOverflowService questionsForSearchTerm:searchBar.text completionHandler:^(NSArray *questions, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    } else {
      NSLog(@"Search Complete");
      self.questions = questions;
      [self.questionTableView reloadData];
      dispatch_group_t imageGroup = dispatch_group_create();
      dispatch_queue_t imageQueue = dispatch_queue_create("com.wilskeylabs.stackreader", DISPATCH_QUEUE_CONCURRENT);
      for (Question *question in self.questions) {
        dispatch_group_async(imageGroup, imageQueue, ^{
          question.profileImage = [ImageDownloader downloadImage:question.imageURL];
        });
      }
      dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
        [self.questionTableView reloadData];
      });
    }
  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
  Question *question = [self.questions objectAtIndex:indexPath.row];
  
  cell.questionLabel.text = question.title;
  cell.imageView.image = question.profileImage;
  
  return cell;
}
@end
