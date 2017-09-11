//
//  MusicListTableViewCell.m
//  PlayerSample
//
//  Created by lingqineng on 2017/9/8.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import <Masonry.h>
@interface MusicListTableViewCell()

@property (strong,nonatomic) UIImageView * leftUIImage;
@property (strong,nonatomic) UILabel * firstLineTitleLabel;
@property (nonatomic,strong) UILabel * authorLabel;

@end

@implementation MusicListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftUIImage];
        [self.contentView addSubview:self.authorLabel];
        self.authorLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.firstLineTitleLabel];
        self.firstLineTitleLabel.textColor = [UIColor whiteColor];
        
        [_leftUIImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(38.5,38.5));
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.centerY.equalTo(self);
        }];
        [_firstLineTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.left.equalTo(_leftUIImage.mas_right).offset(15);
            make.bottom.equalTo(self.mas_centerY);
        }];
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(12);
            make.left.equalTo(_firstLineTitleLabel.mas_left);
            make.top.equalTo(_firstLineTitleLabel.mas_bottom).offset(9);
        }];
    }
    return self;
}

#pragma mark - getter Method

- (UIImageView *)leftUIImage{
    if (!_leftUIImage) {
        _leftUIImage = [[UIImageView alloc]init];
        _leftUIImage.layer.cornerRadius = 19;
        _leftUIImage.layer.masksToBounds = YES;
    }
    return _leftUIImage;
}

- (UILabel *)firstLineTitleLabel{
    if (!_firstLineTitleLabel) {
        _firstLineTitleLabel = [[UILabel alloc]init];
        _firstLineTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _firstLineTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _firstLineTitleLabel;
}

- (UILabel *)authorLabel{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc]init];
        _authorLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _authorLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _authorLabel;
}
#pragma mark --------------------------------Setter Method--------------------------------------------
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_leftUIImage setImage:[UIImage imageNamed:imageUrl]];
}

- (void)setAuthorText:(NSString *)authorText{
    _authorText = authorText;
    _authorLabel.text = _authorText;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _firstLineTitleLabel.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
