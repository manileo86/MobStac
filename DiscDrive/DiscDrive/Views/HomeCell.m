//
//  HomeCell.m
//  Mani
//
//  Created by Mani on 09/25/14.
//  Copyright (c) 2014 Imaginea Inc. All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+WebCache.h"
#import "RCCPeakableImageView.h"
#import "Utils.h"

#define CUSTOM_TRANSFORM            CGAffineTransformMakeScale(1.05f, 1.05f)
#define NORMAL_TRANSFORM            CGAffineTransformMakeScale(1.f, 1.f)

//UI

@interface HomeCell ()

@property (nonatomic, strong) DVD *movie;
@property (nonatomic, weak) IBOutlet RCCPeakableImageView *movieImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UIButton *cartButton;

@end

@implementation HomeCell

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
    [_movieImageView setPadding:CGPointMake(25.0f, 25.0f)];
    _cartButton.layer.cornerRadius = 15.0f;
}

#pragma mark - Set Coupons Data
- (void)setMovie:(DVD *)aMovie
{
    _movie = aMovie;
    _titleLabel.text = _movie.title;
    _categoryLabel.text = [_movie.category uppercaseString];
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:_movie.imageUrl]
                           placeholderImage:[UIImage imageNamed:@"promotion_ph"]];
}

-(IBAction)cartButtonPressed:(id)sender
{
    _cartButton.enabled = NO;
    _cartButton.alpha = 0.5f;
    [Utils addMovieToCart:_movie];
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
