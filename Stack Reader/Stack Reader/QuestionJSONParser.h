//
//  QuestionJSONParser.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionJSONParser : NSObject
+ (NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData;
@end
