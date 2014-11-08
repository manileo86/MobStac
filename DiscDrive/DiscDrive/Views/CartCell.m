//
//  CartCell.m
//  SmartCues
//
//  Created by Mani on 09/25/14.
//  Copyright (c) 2014 Imaginea Inc. All rights reserved.
//

#import "CartCell.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"

#define CUSTOM_TRANSFORM            CGAffineTransformMakeScale(1.05f, 1.05f)
#define NORMAL_TRANSFORM            CGAffineTransformMakeScale(1.f, 1.f)

//UI

@interface CartCell ()

@property (nonatomic, strong) DVD *movie;
@property (nonatomic, weak) IBOutlet UIImageView *movieImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *cartButton;

@end

@implementation CartCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initControls];
        //    _containerView.frame = CGRectOffset(_containerView.frame, 0, CUSTOM_Y);
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self initControls];
}

- (void)initControls
{
    _movieImageView.layer.masksToBounds = YES;
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:@"http://3.bp.blogspot.com/-rdVThLxwu80/URzfi5_IxmI/AAAAAAAACO0/TRSOXs7P1-s/s1600/hollywood+movies+wallpapers+5.jpg"]
                       placeholderImage:[UIImage imageNamed:@"promotion_ph"]];
}

#pragma mark - Set Coupons Data
- (void)setMovie:(DVD *)aMovie
{
    _movie = aMovie;
    
    // merchant details
    _titleLabel.text = _movie.title;
    
    // promotion
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:_movie.imageUrl]
                           placeholderImage:[UIImage imageNamed:@"promotion_ph"]];
}

-(IBAction)closeButtonPressed:(id)sender
{
    [Utils deleteMovieFromCart:_movie];
}

-(void)anim
{
    [UIView animateWithDuration:1.25f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         //_containerView.transform = NORMAL_TRANSFORM;
                         //_promotionImageView.transform = NORMAL_TRANSFORM;
                         //_offerView.frame = CGRectOffset(_offerView.frame, 0, -5);
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)backanim
{
    //    _containerView.transform = CUSTOM_TRANSFORM;
    //_promotionImageView.transform = CUSTOM_TRANSFORM;
    //_offerView.frame = CGRectOffset(_offerView.frame, 0, 5);
}

@end
