//
//  ImageDownloader.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/16/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDownloader : NSObject
+ (UIImage *)downloadImage:(NSString *)imageURLString;
@end
