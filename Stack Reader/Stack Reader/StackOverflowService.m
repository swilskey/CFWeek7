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
#import <AFNetworking/AFNetworking.h>

@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler {
  //Examplesearch term
  NSString *url = @"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=swift&site=stackoverflow";
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
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
