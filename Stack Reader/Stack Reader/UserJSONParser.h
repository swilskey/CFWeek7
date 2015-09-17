//
//  UserJSONParser.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/17/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserJSONParser : NSObject
+ (User *)parseUserJSON:(NSDictionary *)userData;
@end
