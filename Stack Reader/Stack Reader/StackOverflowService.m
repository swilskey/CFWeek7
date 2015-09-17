//
//  StackOverflowService.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "StackOverflowService.h"
#import "Errors.h"
#import "QuestionJSONParser.h"
#import "UserJSONParser.h"
#import "User.h"
#import "Keys.h"
#import <AFNetworking/AFNetworking.h>

@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler {
  //Examplesearch term
  NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  NSString *searchURL = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@",searchTerm,clientKey,accessToken];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:searchURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
    NSArray *questions = [QuestionJSONParser questionResultsFromJSON:responseObject];
    
    completionHandler(questions,nil);
    
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      completionHandler(nil,stackOverflowError);
    } else {
      NSError *reachabilityError = [self checkReachability];
      completionHandler(nil,reachabilityError);
    }
    
  }];
}

+ (void)questionsForUser:(void(^)(NSArray *questions, NSError *error))completionHandler {
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/me/questions?order=desc&sort=activity&site=stackoverflow&key=%@&access_token=%@",clientKey,token];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    NSArray *questions = [QuestionJSONParser questionResultsFromJSON:responseObject];
    completionHandler(questions, nil);
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      completionHandler(nil,stackOverflowError);
    } else {
      NSError *reachabilityError = [self checkReachability];
      completionHandler(nil,reachabilityError);
    }
  }];
}

+ (void)userAccountForAuthenticatedUser:(void(^)(User *data, NSError *error))completionHandler {
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  NSString *userURL = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow&key=%@&access_token=%@",clientKey,token];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:userURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    User *user = [UserJSONParser parseUserJSON:responseObject];
    completionHandler(user, nil);
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      completionHandler(nil,stackOverflowError);
    } else {
      NSError *reachabilityError = [self checkReachability];
      completionHandler(nil,reachabilityError);
    }
  }];

}

+ (NSError *)errorForStatusCode:(NSInteger)statusCode {
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 400:
      errorCode = StackOverflowBadParameter;
      localizedDescription = @"Invalid Search Term. Please Try Again";
      break;
    case 401:
      errorCode = StackOverflowAccessTokenRequired;
      localizedDescription = @"Must Signin to use Stack Overflow";
      break;
    case 402:
      errorCode = StackOverflowInvalidAccessToken;
      localizedDescription = @"Access Token is Invalid. Please Login.";
      break;
    case 403:
      errorCode = StackOverflowAccessDenied;
      localizedDescription = @"Unauthorized Access.";
    case 404:
      errorCode = StackOverflowNoMethod;
      localizedDescription = @"Invalid Method. Please Check Query";
      break;
    case 405:
      errorCode = StackOverflowKeyRequired;
      localizedDescription = @"Missing Key.";
      break;
    case 406:
      errorCode = StackOverflowAccessTokenCompromised;
      localizedDescription = @"Access Token Invalidated. Please Login Again.";
      break;
    case 407:
      errorCode = StackOverflowWriteFailed;
      localizedDescription = @"Write Failed. Please Try Again.";
      break;
    case 409:
      errorCode = StackOverflowDuplicateRequest;
      localizedDescription = @"Request Already Made";
      break;
    case 500:
      errorCode = StackOverflowInternalError;
      localizedDescription = @"Internal Error. Please Try Again.";
      break;
    case 502:
      errorCode = StackOverflowThrottleViolation;
      localizedDescription = @"Rate Limiting. Please Wait to Try Again.";
      break;
    case 503:
      errorCode = StackOverflowTemporarilyUnavailable;
      localizedDescription = @"Stack Overflow Temporarily Unavailable. Try Again Later";
      break;
    default:
      errorCode = StackOverflowGeneralError;
      localizedDescription = @"Could not complete operation. Please try again later.";
      break;
  }
  NSError *error = [NSError errorWithDomain:kStackOverflowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
  return error;
}

+ (NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverflowErrorDomain code:StackOverflowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to server, Please try again when you have a connection."}];
    return error;
  }
  return nil;
}

@end
