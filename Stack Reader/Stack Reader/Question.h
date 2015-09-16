//
//  Question.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *profileName;
@property (nonatomic) BOOL isAnswered;
@property (strong,nonatomic) NSString *imageURL;
@property (strong,nonatomic) UIImage *profileImage;

@end
