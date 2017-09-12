//
//  PlayViewController.m
//  PlayerSample
//
//  Created by lingqineng on 2017/9/6.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import "PlayViewController.h"
#import <MBProgressHUD.h>
#import <Masonry.h>
#import "UILabel+LabelHeight.h"
#import "UIView+Extension.h"
#import "MusicModel.h"
#import "AVPlayerManager.h"
#import "MusicListTableViewCell.h"
#import "PopView.h"
#import "AppDelegate.h"

#define defaultPlayer ([AVPlayerManager manager].player)

/**
 * PlayViewController with avplayer.
 *
 * This is a simple demo that include basic Features about music player
 *
 * @note basic Feature is contained in AVPlayerManager.h
 */

@interface PlayViewController ()<trackPlayEndDelegate,UITableViewDelegate,UITableViewDataSource,PlayVCDelegate>
@property (strong,nonatomic ) UIView        * playView;
@property (strong,nonatomic ) UIScrollView  * playScrollView;
@property (strong,nonatomic ) UIView        * playBottomView;
@property (strong,nonatomic ) UIView        * testView;
@property (strong,nonatomic ) UIView        * popTrackListView;
@property (strong,nonatomic ) UIView        * popView;
@property (strong,nonatomic ) UIView        * popClearView;
@property (strong,nonatomic ) UITableView   * trackListTableView;
@property (strong,nonatomic ) UIView        * subPlayView;
@property (strong,nonatomic ) UIImageView   * coverImage;
@property (strong,nonatomic ) UIImageView   * trackImage;
@property (strong,nonatomic ) UIView        * lylicsView;
@property (strong,nonatomic ) UILabel       * lylicsLabel;
@property (strong,nonatomic ) UIScrollView  * lylicsScrollView;
@property (strong,nonatomic ) UIPageControl * pageControl;
@property (strong,nonatomic ) UISlider      * progressSlider;
@property (strong,nonatomic ) UILabel       * currentTimeLabel;
@property (strong,nonatomic ) UILabel       * totalTimeLabel;
@property (strong,nonatomic ) UILabel       * popListNumLabel;
@property (strong,nonatomic ) UIButton      * playModeBtn;
@property (strong,nonatomic ) UIButton      * playBtn;
@property (strong,nonatomic ) UIButton      * rightBarItem;
@property (strong,nonatomic ) NSTimer       * progressTimer;
@property (strong,nonatomic ) UILabel       * titleLabel;
/**
 *  当前曲目的数据源
 */
@property (strong,nonatomic) MusicModel * currentModel;
/**
 *  播放器播放模式
 */
@property (nonatomic, assign) AVPlayerMode playMode;
/**
 *  是否播放的状态
 */
@property (assign,nonatomic) BOOL isPlaying;
/**
 *  播放数据源数组
 */
@property (copy,nonatomic) NSArray * trackArray;

@end

@implementation PlayViewController

# pragma mark - Life cycle
/// @name  Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"music_bg"]]];
    
    [self initPlayView];
    [self initPopTrackListView];
    [self setupPlayer];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.playMode              = AVPlayerModeListLoop;
    self.trackArray            = [self randomizedArrayWithArray:[AVPlayerManager manager].orderedTracksArray];
    AppDelegate * appdelegate  = [UIApplication sharedApplication].delegate;
    appdelegate.playVCDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

# pragma mark - Basic setup (初始化数据源、播放模式，是否收藏、UI页面的布局初始化)
/// @name  Basic setup (初始化数据源、播放模式，是否收藏、UI页面的布局初始化)

/**
 *  初始化播放页面的UI,布局采用masonry
 */
- (void)initPlayView{
    [self.view addSubview:self.rightBarItem];
    [self.view addSubview:self.titleLabel];
    [self.playView addSubview:self.playScrollView];
    [self.playView addSubview:self.playBottomView];
    //playBottomViewGroup
    [self.playBottomView addSubview:self.progressSlider];
    [self.playBottomView addSubview:self.currentTimeLabel];
    [self.playBottomView addSubview:self.totalTimeLabel];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker * make){
        make.centerX.mas_equalTo(self.playBottomView);
        make.top.mas_equalTo(self.playBottomView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 15));
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker * make){
        make.centerY.mas_equalTo(self.progressSlider);
        make.right.mas_equalTo(self.progressSlider.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker * make){
        make.centerY.mas_equalTo(self.progressSlider);
        make.left.mas_equalTo(self.progressSlider.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    UIButton * previousBtn = [[UIButton alloc]init];
    [previousBtn setImage:[UIImage imageNamed:@"music_forward"] forState:UIControlStateNormal];
    [previousBtn addTarget:self action:@selector(playPreviousMusic) forControlEvents:UIControlEventTouchUpInside];
    UIButton * nextBtn = [[UIButton alloc]init];
    [nextBtn setImage:[UIImage imageNamed:@"music_back"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(playNextMusic) forControlEvents:UIControlEventTouchUpInside];
    UIButton * musicListBtn = [[UIButton alloc]init];
    [musicListBtn setImage:[UIImage imageNamed:@"music_list"] forState:UIControlStateNormal];
    [musicListBtn addTarget:self action:@selector(showMusicList) forControlEvents:UIControlEventTouchUpInside];
    self.playModeBtn = [[UIButton alloc]init];
    [self.playModeBtn setImage:[UIImage imageNamed:@"music_loop"] forState:UIControlStateNormal];
    [self.playModeBtn addTarget:self action:@selector(didTouchMusicModeButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playBottomView addSubview:self.playBtn];
    [self.playBottomView addSubview:previousBtn];
    [self.playBottomView addSubview:nextBtn];
    [self.playBottomView addSubview:musicListBtn];
    [self.playBottomView addSubview:self.playModeBtn];
    //layout
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker * make){
        make.centerX.mas_equalTo(self.playBottomView);
        make.top.mas_equalTo(self.progressSlider).offset(25);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.playBtn);
        make.right.mas_equalTo(self.playBtn.mas_left).offset(-25);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [musicListBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.playBtn);
        make.right.mas_equalTo(previousBtn.mas_left).offset(-25);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.playBtn);
        make.left.mas_equalTo(self.playBtn.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.playModeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.playBtn);
        make.left.mas_equalTo(nextBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
}
/**
 *  初始化播放列表的弹出
 */
- (void)initPopTrackListView{
    [self.popTrackListView addSubview:self.trackListTableView];
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.popTrackListView.height - 40, SCREEN_WIDTH, 40)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.popTrackListView addSubview:closeBtn];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCloseBtn)];
    [self.popClearView addGestureRecognizer:closeTap];
}
/**
 *  初始化歌曲封面与歌词的scrollView
 *
 *  @param imageUrl 封面的imageUrl
 *  @param lylics   歌词String
 */
-(void)initPlayScrollViewWithImageUrl:(NSString *)imageUrl lyrics:(NSString *)lylics{
    [self.trackImage setImage:[UIImage imageNamed:imageUrl]];
    [self.subPlayView addSubview:self.coverImage];
    [self.subPlayView addSubview:self.trackImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(self.subPlayView);
        make.top.mas_equalTo(self.subPlayView.mas_top).offset(60);
        make.size.mas_equalTo(CGSizeMake(220, 220));
    }];
    [self.trackImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.mas_equalTo(self.coverImage);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    [self.lylicsView addSubview:self.lylicsScrollView];
    [self.lylicsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.lylicsView);
    }];
    [self.lylicsScrollView addSubview:self.lylicsLabel];
    self.lylicsLabel.text = lylics;
    CGFloat contentHeight = [UILabel getHeightByWidth:SCREEN_WIDTH title:lylics font:[UIFont systemFontOfSize:18]];
    if (contentHeight > self.lylicsView.size.height) {
        self.lylicsLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentHeight);
    }
    else
        self.lylicsLabel.frame            = CGRectMake(0, self.lylicsView.size.height / 2 - contentHeight / 2, SCREEN_WIDTH, contentHeight);
    self.lylicsScrollView.contentSize = CGSizeMake(SCREEN_WIDTH ,[UILabel getHeightByWidth:SCREEN_WIDTH title:lylics font:[UIFont systemFontOfSize:18]]);
}
/**
 *  currentModel的set方法，主要用于切换model的数据加载
 *
 *  @param currentModel 当前音乐模型
 */
-(void)setCurrentModel:(MusicModel *)currentModel{
    _currentModel        = currentModel;
    self.titleLabel.text = self.currentModel.Musicname;
    //进度条的初始化
    self.progressSlider.value = CMTimeGetSeconds(defaultPlayer.currentTime) / CMTimeGetSeconds(defaultPlayer.currentItem.asset.duration);
    [self initPlayScrollViewWithImageUrl:currentModel.CoverImage lyrics:@"无歌词"];
    [self checkMusicFavoritedIcon];
}
/**
 *  播放模式的set方法
 *
 *  @param playMode 当前传入的playMode
 */
- (void)setPlayMode:(AVPlayerMode)playMode{
    _playMode = playMode;
    [self updatePlayModeButton];
}
/**
 *  更新播放模式按钮的状态
 */
- (void)updatePlayModeButton {
    switch (_playMode) {
        case AVPlayerModeRandom:
            [_playModeBtn setImage:[UIImage imageNamed:@"music_random"] forState:UIControlStateNormal];            break;
        case AVPlayerModeListLoop:
            [_playModeBtn setImage:[UIImage imageNamed:@"music_loop"] forState:UIControlStateNormal];
            break;
        case AVPlayerModeTrackLoop:
            [_playModeBtn setImage:[UIImage imageNamed:@"music_single"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
/**
 *  检查歌曲是否收藏
 */
- (void)checkMusicFavoritedIcon {
    if (self.currentModel.isFavorite) {
        [self.rightBarItem setImage:[UIImage imageNamed:@"music_collection_y.png"] forState:UIControlStateNormal];
    } else {
        [self.rightBarItem setImage:[UIImage imageNamed:@"music_collection.png"] forState:UIControlStateNormal];
    }
}
# pragma mark - Music Action (点击播放列表，退出按钮、播放模式按钮、播放按钮的更新)
/// @name  Music Action (点击播放列表，退出按钮、播放模式按钮、播放按钮的更新)
/**
 *  弹出歌曲播放列表
 */
-(void)showMusicList{
    [PopView setPopupInfoViewWithState:YES SubUIView:self.popView UIViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

/**
 *  点击播放按钮的事件
 */
-(void)didTouchMusicModeButton{
    switch (_playMode) {
        case AVPlayerModeListLoop:
            self.playMode                         = AVPlayerModeRandom;
            [AVPlayerManager manager].tracksArray = [self.trackArray mutableCopy];//切换随机队列
            [self showMiddleTips:@"切换到随机播放"];
            break;
        case AVPlayerModeRandom:
            self.playMode                         = AVPlayerModeTrackLoop;
            [AVPlayerManager manager].tracksArray = [AVPlayerManager manager].orderedTracksArray;//恢复原来的次序
            [self showMiddleTips:@"切换到单曲循环"];
            break;
        case AVPlayerModeTrackLoop:
            self.playMode                         = AVPlayerModeListLoop;
            [AVPlayerManager manager].tracksArray = [AVPlayerManager manager].orderedTracksArray;//恢复原来的次序
            [self showMiddleTips:@"切换到列表循环"];
            break;
        default:
            break;
    }
    [self.trackListTableView reloadData];
}
/**
 *  点击收藏按钮事件
 */
-(void)clickRightBarItem{
    self.currentModel.isFavorite = !self.currentModel.isFavorite;
    NSString * tips              = self.currentModel.isFavorite ? @"已收藏" : @"取消收藏";
    [self showMiddleTips:tips];
    [self checkMusicFavoritedIcon];
}

/**
 *  isPlaying的set方法，更新播放按钮的状态
 *
 *  @param isPlaying 传入的当前isPlaying的状态
 */
-(void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (_isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"music_pause.png"] forState:UIControlStateNormal];
    } else {
        [self.playBtn setImage:[UIImage imageNamed:@"music_play.png"] forState:UIControlStateNormal];
    }
}

/**
 *  点击关闭播放列表的弹出
 */
-(void)clickCloseBtn{
    [PopView setPopupInfoViewWithState:NO SubUIView:self.popView UIViewFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
}
# pragma mark - Music Controls (播放、暂停、上一首、下一首)
/// @name  Music Controls (播放、暂停、上一首、下一首)

/**
 *  点击播放或者暂停
 */
-(void)clickPlayBtn{
    if (_isPlaying) {
        [[AVPlayerManager manager] pause];
    } else {
        [[AVPlayerManager manager] play];
    }
    self.isPlaying = [AVPlayerManager manager].isPlaying;
}

/**
 *  点击播放上一首
 */
-(void)playPreviousMusic{
    [[AVPlayerManager manager] previous];
    [self setupPlayer];
}

/**
 *  点击播放下一首
 */
-(void)playNextMusic{
    [[AVPlayerManager manager] next];
    [self setupPlayer];
}

# pragma mark - Setup streamer (初始化播放器)
/// @name  Setup streamer (初始化播放器)

/**
 *  初始化播放器
 */
-(void)setupPlayer{
    @try {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    } @catch (NSException *exception) {
    }
    
    [AVPlayerManager manager].playEndDelegate = self;
    self.currentModel                         = [[AVPlayerManager manager].tracksArray objectAtIndex:[AVPlayerManager manager].currentIndex];
    [[AVPlayerManager manager] playAudio];
    self.isPlaying = YES;
    if (!self.progressTimer) {
        [self addProgressTimer];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

# pragma mark - Music delegate
/// @name  Music delegate

/**
 *  歌曲播放结束的响应事件
 *
 *  @param notification 当前notification
 */
- (void)trackPlayDidEnd:(NSNotification *)notification {
    [[AVPlayerManager manager] resetAudio];
    [self playNextMusic];
}

#pragma mark - tableView datasource
/// @name  tableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [AVPlayerManager manager].tracksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicModel * model            = [AVPlayerManager manager].tracksArray[indexPath.row];
    MusicListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId"];
    if (!cell) {
        cell = [[MusicListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseId"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.title           = model.Musicname;
    cell.authorText      = model.Singer;
    cell.imageUrl        = model.SingerIcon;
    return cell;
    
}
# pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AVPlayerManager manager].currentIndex = indexPath.row;
    [self setupPlayer];
    [self clickCloseBtn];
}

# pragma mark - Music Handle (添加去除监听、KVO，播放响应事件打断)
/// @name  Music Handle (添加去除监听、KVO，播放响应事件打断)
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

/**
 *  播放器被打断时的响应事件
 *
 *  @param notification 当前notification
 */
- (void)handleInterruption:(NSNotification *)notification{
    NSDictionary * info                 = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    //中断开始和中断结束
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //当被电话等中断的时候，调用这个方法，停止播放
        if (self.isPlaying) {
            [[AVPlayerManager manager] pause];
        }
    } else {
        /**
         *  中断结束，userinfo中会有一个InterruptionOption属性，
         *  该属性如果为resume，则可以继续播放功能
         */
        AVAudioSessionInterruptionOptions option = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (option == AVAudioSessionInterruptionOptionShouldResume) {
            NSLog(@"可以继续播放");
            if (!self.isPlaying) {
                [[AVPlayerManager manager] play];
            }
        }
        self.isPlaying = [AVPlayerManager manager].isPlaying;
    }
}

/**
 *  线控，耳机插拔的响应事件
 *
 *  @param notification 当前notification
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    NSDictionary * info         = notification.userInfo;
    NSInteger routeChangeReason = [[info valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"耳机插入");
            [[AVPlayerManager manager] play];
            self.isPlaying = YES;
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"耳机拔出，停止播放操作");
            [[AVPlayerManager manager] pause];
            self.isPlaying = NO;
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
    
}
# pragma mark - Slider Handle
/// @name  Handle Music Slider

/**
 *  每秒更新进度条的状态
 */
- (void)updateProgressInfo
{
    self.currentTimeLabel.text = [self timeStringWithTimeInterval:CMTimeGetSeconds(defaultPlayer.currentItem.currentTime)];
    self.progressSlider.value  = CMTimeGetSeconds(defaultPlayer.currentTime) / CMTimeGetSeconds(defaultPlayer.currentItem.asset.duration);
    self.totalTimeLabel.text   = [self timeStringWithTimeInterval:CMTimeGetSeconds(defaultPlayer.currentItem.asset.duration)];
    if (self.progressSlider.value == 1){
        self.progressSlider.value  = 0;
        self.progressSlider.tag    = 100;
        defaultPlayer              = nil;
        self.isPlaying             = NO;
        [self removeProgressTimer];
        self.currentTimeLabel.text = @"00:00";
        return;
    }
}

-(void)valueChanged:(UISlider *)slider{
    if (self.progressSlider.value == 1) {
        self.progressSlider.value = 0;
    }
    
    NSTimeInterval currentTime = CMTimeGetSeconds(defaultPlayer.currentItem.asset.duration) * self.progressSlider.value;
    self.currentTimeLabel.text = [self timeStringWithTimeInterval:currentTime];
}

/**
 *  拖动到某个时间点播放
 *
 *  @param slider 传入的slider对象
 */
-(void)seekTime:(UISlider *)slider{
    NSLog(@"%f",slider.value);
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(defaultPlayer.currentItem.asset.duration) * self.progressSlider.value;
    [defaultPlayer seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}
-(void)startSlider:(UISlider *)slider{
    NSLog(@"拖动");
    [self removeProgressTimer];
}

# pragma mark - HUD
/// @name HUD

/**
 *  弹出提示框
 *
 *  @param tips 传入提示内容
 */
- (void)showMiddleTips:(NSString *)tips {
    UIView *view                  = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled    = NO;
    hud.mode                      = MBProgressHUDModeText;
    hud.label.text                = tips;
    hud.label.font                = [UIFont systemFontOfSize:15];
    hud.margin                    = 10.f;
    hud.yOffset                   = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated: YES afterDelay:2];
}

# pragma mark - helper Method
/// @name helper Method

/**
 *  秒数转成mm:ss的格式方法
 *
 *  @param time 传入的秒数
 *
 *  @return 返回 mm:ss的方法
 */
- (NSString *)timeStringWithTimeInterval:(NSTimeInterval)time
{
    NSInteger min         = time / 60;
    NSInteger sec         = (NSInteger)time % 60;
    NSString * timeString = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
    return timeString;
}

/**
 *  产生一个打乱顺序的数组
 *
 *  @param array 传入数组
 *
 *  @return 打乱顺序之后的数组
 */
-(NSArray *)randomizedArrayWithArray:(NSArray *)array{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    for(int i                = 0; i< array.count; i++){
        int m                    = (arc4random() % (array.count - i)) + i;
        [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
    }
    return [newArray copy];
}
# pragma mark - getter Method

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _playView;
}
- (UIScrollView *)playScrollView{
    if (!_playScrollView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _playScrollView                           = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 100 - 50)];
        _playScrollView.directionalLockEnabled    = YES;
        _playScrollView.pagingEnabled             = YES;
        [_playScrollView setBackgroundColor:[UIColor clearColor]];
        _playScrollView.showsHorizontalScrollIndicator = NO;
        _playScrollView.bounces                        = NO;
        _playScrollView.showsVerticalScrollIndicator   = NO;
        _playScrollView.delegate                       = self;
        _playScrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 100 - 50);
        //用于控制播放界面及控制界面歌词的scollview的滑动监听，
        _playScrollView.tag = 1025;
    }
    return _playScrollView;
}

- (UIView *)playBottomView{
    if (!_playBottomView) {
        _playBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100 - 50, SCREEN_WIDTH, 100)];
        [_playBottomView setBackgroundColor:[UIColor clearColor]];
    }
    return _playBottomView;
}

- (UIView *)popTrackListView{
    if (!_popTrackListView) {
        _popTrackListView                 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 240, SCREEN_WIDTH, 240)];
        _popTrackListView.backgroundColor = [UIColor blackColor];
        _popTrackListView.alpha           = 0.7;
        [self.popView addSubview:_popTrackListView];
    }
    return _popTrackListView;
}

- (UIView *)popClearView{
    if (!_popClearView) {
        _popClearView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 240)];
        _popClearView.backgroundColor = [UIColor clearColor];
        [self.popView addSubview:_popClearView];
    }
    return _popClearView;
}

- (UIView *)popView{
    if (!_popView) {
        _popView                 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _popView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_popView];
    }
    return _popView;
}

- (UITableView *)trackListTableView{
    if (!_trackListTableView) {
        _trackListTableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 240) style:UITableViewStylePlain];
        _trackListTableView.delegate        = self;
        _trackListTableView.dataSource      = self;
        _trackListTableView.opaque          = NO;
        _trackListTableView.backgroundColor = [UIColor clearColor];
        _trackListTableView.backgroundView  = nil;
        _trackListTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _trackListTableView.bounces         = NO;
    }
    return _trackListTableView;
}

//播放的子页面

- (UIView *)subPlayView{
    if (!_subPlayView) {
        _subPlayView                 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 100 - 50)];
        _subPlayView.backgroundColor = [UIColor clearColor];
    }
    [self.playScrollView addSubview:_subPlayView];
    return _subPlayView;
}

- (UIImageView *)coverImage{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"music_cover"]];;
    }
    return _coverImage;
}

- (UIImageView *)trackImage{
    if (!_trackImage) {
        _trackImage                     = [[UIImageView alloc]init];
        _trackImage.layer.masksToBounds = YES;
        _trackImage.layer.cornerRadius  = 55;
    }
    return _trackImage;
}

- (UIView *)lylicsView{
    if (!_lylicsView) {
        _lylicsView                 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 100 - 50)];
        _lylicsView.backgroundColor = [UIColor clearColor];
        [self.playScrollView addSubview:_lylicsView];
    }
    return _lylicsView;
}

- (UILabel *)lylicsLabel{
    if (!_lylicsLabel) {
        _lylicsLabel               = [[UILabel alloc]init];
        _lylicsLabel.textColor     = [UIColor whiteColor];
        _lylicsLabel.textAlignment = NSTextAlignmentCenter;
        _lylicsLabel.font          = [UIFont systemFontOfSize:18];
        _lylicsLabel.numberOfLines = 0;
    }
    return _lylicsLabel;
}

- (UIScrollView *)lylicsScrollView{
    if (!_lylicsScrollView) {
        _lylicsScrollView             = [[UIScrollView alloc]init];
        _lylicsScrollView.contentSize = CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT -64 - 100 - 50);
        _lylicsScrollView.delegate    = self;
    }
    return _lylicsScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl               = [[UIPageControl alloc]init];
        _pageControl.currentPage   = 0;
        _pageControl.numberOfPages = 2;
    }
    return _pageControl;
}

- (UISlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider                       = [[UISlider alloc]init];
        _progressSlider.minimumTrackTintColor = kDefaultColor;
        _progressSlider.maximumTrackTintColor = [UIColor whiteColor];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"study_listen_slider"] forState:UIControlStateNormal];
        [_progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(seekTime:) forControlEvents:UIControlEventTouchUpInside];
        [_progressSlider addTarget:self action:@selector(startSlider:) forControlEvents:UIControlEventTouchDown];
        _progressSlider.value = 0;
    }
    return _progressSlider;
}

-(UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc]init];
        _currentTimeLabel.text          = @"00:00";
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

-(UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc]init];
        _totalTimeLabel.text          = @"00:00";
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]init];
        [_playBtn setImage:[UIImage imageNamed:@"music_play.png"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)rightBarItem{
    if (!_rightBarItem) {
        _rightBarItem = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 40, 30, 24)];
        
        [_rightBarItem addTarget:self action:@selector(clickRightBarItem) forControlEvents:UIControlEventTouchUpInside];
        [_rightBarItem setImage:[UIImage imageNamed:@"music_collection.png"] forState:UIControlStateNormal];
    }
    return _rightBarItem;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel               = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 150, 40, 300, 20)];
        _titleLabel.textColor     = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
