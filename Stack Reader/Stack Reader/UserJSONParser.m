//
//  UserJSONParser.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/17/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "UserJSONParser.h"
#import "User.h"

@implementation UserJSONParser

+ (User *)parseUserJSON:(NSDictionary *)userData {
  NSArray *userArray = userData[@"items"];
  NSDictionary *userInfo = [userArray firstObject];
  User *user = [[User alloc] init];
  user.username = userInfo[@"display_name"];
  user.profileImageURL = userInfo[@"profile_image"];
  return user;
}

@end
