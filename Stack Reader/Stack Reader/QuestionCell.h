//
//  QuestionCell.h
//  Stack Reader
//
//  Created by Sam Wilskey on 9/16/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@end