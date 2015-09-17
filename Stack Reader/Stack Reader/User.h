//
//  User.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/17/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *profileImageURL;
@property (strong,nonatomic) UIImage *userImage;
@end
