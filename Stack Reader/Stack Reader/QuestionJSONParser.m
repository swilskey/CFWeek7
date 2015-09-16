//
//  QuestionJSONParser.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "QuestionJSONParser.h"
#import "Question.h"

@implementation QuestionJSONParser

+ (NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData {
  NSMutableArray *questions = [[NSMutableArray alloc] init];
  
  NSArray *items = jsonData[@"items"];
  for (NSDictionary *item in items) {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    question.isAnswered = item[@"is_answered"];
    NSDictionary *owner = item[@"owner"];
    question.profileName = owner[@"display_name"];
    question.imageURL = owner[@"profile_image"];
    
    [questions addObject:question];
    
  }
  
  return questions;
}

@end
