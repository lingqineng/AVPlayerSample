//
//  UILabel+LabelHeight.h
//  Elight
//
//  Created by lingqineng on 17/4/10.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeight)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end

