//
//  Errors.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStackOverflowErrorDomain;

typedef enum : NSUInteger {
  StackOverflowBadParameter,
  StackOverflowAccessTokenRequired,
  StackOverflowInvalidAccessToken,
  StackOverflowAccessDenied,
  StackOverflowNoMethod,
  StackOverflowKeyRequired,
  StackOverflowAccessTokenCompromised,
  StackOverflowWriteFailed,
  StackOverflowDuplicateRequest,
  StackOverflowInternalError,
  StackOverflowThrottleViolation,
  StackOverflowTemporarilyUnavailable,
  StackOverflowGeneralError,
  StackOverflowConnectionDown
} StackOverflowErrorCodes;