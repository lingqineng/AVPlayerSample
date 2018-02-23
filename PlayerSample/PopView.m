//
//  PopView.m
//  PlayerSample
//
//  Created by lingqineng on 2017/9/8.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import "PopView.h"

@implementation PopView

+ (void)setPopupInfoViewWithState:(BOOL)isDown SubUIView:(UIView *)view UIViewFrame:(CGRect)frame{
    if(isDown == NO){
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [view setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  [view setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
        
    }else{
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [view setFrame:frame];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  [view setFrame:frame];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
