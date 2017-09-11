//
//  PopView.h
//  PlayerSample
//
//  Created by lingqineng on 2017/9/8.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView

/**底部编辑弹出窗*/
+ (void)setPopupInfoViewWithState:(BOOL)isDown SubUIView:(UIView *)view UIViewFrame:(CGRect)frame;

@end
