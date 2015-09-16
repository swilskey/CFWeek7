//
//  ImageDownloader.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/16/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "ImageDownloader.h"
#import <UIKit/UIKit.h>
@implementation ImageDownloader

+ (UIImage *)downloadImage:(NSString *)imageURLString {
  NSURL *imageURL = [NSURL URLWithString:imageURLString];
  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  UIImage *image = [UIImage imageWithData:imageData];
  return image;
}
@end
