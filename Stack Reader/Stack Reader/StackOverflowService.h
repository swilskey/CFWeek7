//
//  StackOverflowService.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface StackOverflowService : NSObject

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler;
+ (void)questionsForUser:(void(^)(NSArray *questions, NSError *error))completionHandler;
+ (void)userAccountForAuthenticatedUser:(void(^)(User *data, NSError *error))completionHandler;

@end
