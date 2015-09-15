//
//  BugerMenuViewController.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/14/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "BugerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyProfileViewController.h"
#import "MyQuestionsViewController.h"

@interface BugerMenuViewController () <UITableViewDelegate>

@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) NSArray *viewControllers;
@property (strong,nonatomic) UIPanGestureRecognizer *panRecognizer;

@end

@implementation BugerMenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  MyProfileViewController *myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile"];
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearch"];
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  
  self.viewControllers = @[questionSearchVC, myQuestionsVC, myProfileVC];
  
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  mainMenuVC.tableView.delegate = self;
  
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  
  [self addChildViewController:questionSearchVC];
  questionSearchVC.view.frame = self.view.frame;
  [self.view addSubview:questionSearchVC.view];
  [questionSearchVC didMoveToParentViewController:self];
  self.topViewController = questionSearchVC;
  
  self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:self.panRecognizer];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
  
}

@end
