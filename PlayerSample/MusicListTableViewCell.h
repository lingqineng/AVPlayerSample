//
//  MusicListTableViewCell.h
//  PlayerSample
//
//  Created by lingqineng on 2017/9/8.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString * imageUrl;
@property (copy, nonatomic) NSString * title;
@property (strong,nonatomic) NSString * authorText;

@end
