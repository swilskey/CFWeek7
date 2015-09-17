//
//  MyQuestionsViewController.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "QuestionCell.h"
#import "Question.h"
#import "StackOverflowService.h"

@interface MyQuestionsViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myQuestionsTableView;
@property (strong,nonatomic) NSArray *questions;
@end

@implementation MyQuestionsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.myQuestionsTableView.dataSource = self;
  [self.myQuestionsTableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QuestionCell"];
  
  [StackOverflowService questionsForUser:^(NSArray *questions, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    } else {
      self.questions = questions;
      [self.myQuestionsTableView reloadData];
    }
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
  Question *question = [self.questions objectAtIndex:indexPath.row];
  
  cell.questionLabel.text = question.title;
  return cell;
}
@end
