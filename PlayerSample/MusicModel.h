//
//  MusicModel.h
//  PlayerSample
//
//  Created by lingqineng on 2017/9/6.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

/** 歌名 */
@property (nonatomic, copy) NSString *Musicname;

/** 歌曲文件名 */
@property (nonatomic, copy) NSString *Filename;

/** 歌手 */
@property (nonatomic, copy) NSString *Singer;

/** 歌手头像 */
@property (nonatomic, copy) NSString *SingerIcon;

/** 专辑图片 */
@property (nonatomic, copy) NSString *CoverImage;

/** 是否是喜欢的 */
@property BOOL isFavorite;

@end
