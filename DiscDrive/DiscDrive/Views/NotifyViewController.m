//
//  NotifyViewController.m
//  BeaconSampling
//
//  Created by Mani on 19/03/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import "NotifyViewController.h"
#import "Utils.h"
#import "User.h"
#import "UIImageView+WebCache.h"

@interface NotifyViewController ()
{
    BOOL bShouldShowGuide;
    BOOL bShouldShowRSS;
}

@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet iCarousel *carousel;

@property(nonatomic, strong) IBOutlet UIView *guideView;
@property(nonatomic, strong) IBOutlet UIImageView *sectionImageview;
@property(nonatomic, strong) IBOutlet UIImageView *guideImageview;
@property(nonatomic, strong) IBOutlet UIButton *option1Button;
@property(nonatomic, strong) IBOutlet UIButton *option2Button;

@property(nonatomic, strong) IBOutlet UIView *rssView;
@property(nonatomic, strong) IBOutlet UITextField *emailField;

@end

@implementation NotifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    User *user = [Utils currentUser];
    _nameLabel.text = [NSString stringWithFormat:@"Hi %@, Check out these new arrivals. You might like it!", user.name];
    _carousel.type = iCarouselTypeCoverFlow;
    
    _sectionImageview.image = [UIImage imageNamed:@"dvd.png"];
    
    bShouldShowGuide = YES;
    bShouldShowRSS = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    
    [super viewWillDisappear:animated];
}

-(void)keyboardWillShow
{
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = _rssView.frame;
        frame.origin.y = 180.0f;
        _rssView.frame = frame;
    }];
}

-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = _rssView.frame;
        frame.origin.y = 248.0f;
        _rssView.frame = frame;
    }];
}

-(IBAction)closePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)showGuide:(id)sender
{
    bShouldShowGuide = YES;
    [self showGuideView:YES];
}

-(IBAction)closeGuide:(id)sender
{
    bShouldShowGuide = NO;
    [self showGuideView:NO];
}

-(void)showGuideView:(BOOL)bShow
{
    if(bShow)
    {
        if(bShouldShowGuide)
        {
            [UIView animateWithDuration:0.25f animations:^{
                CGRect frame = _guideView.frame;
                frame.origin.y = 248.0f;
                _guideView.frame = frame;
            }];
            bShouldShowGuide = NO;
        };
    }
    else
    {
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = _guideView.frame;
            frame.origin.y = 568.0f;
            _guideView.frame = frame;
        }];
    }
}

-(void)showRSSView:(BOOL)bShow
{
    if(bShow)
    {
        if(bShouldShowRSS)
        {
            [UIView animateWithDuration:0.25f animations:^{
                CGRect frame = _rssView.frame;
                frame.origin.y = 248.0f;
                _rssView.frame = frame;
            }];
            bShouldShowRSS = NO;
        };
    }
    else
    {
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = _rssView.frame;
            frame.origin.y = 568.0f;
            _rssView.frame = frame;
        }];
    }
}

-(IBAction)closeRSS:(id)sender
{
    bShouldShowRSS = NO;
    [self showRSSView:NO];
}

-(IBAction)subscribePressed:(id)sender
{
    NSString *search = [_emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(![search isEqualToString:@""])
    {
        [_emailField resignFirstResponder];
        [self showRSSView:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *search = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(![search isEqualToString:@""])
    {
        [textField resignFirstResponder];
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_dvds count];
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSUInteger)index
         reusingView:(UIView *)view
{
    DVD *dvd = [_dvds objectAtIndex:index];
    
    if(!view)
    {
        // Individual Offer view
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        aView.tag = index;
        aView.backgroundColor = [UIColor whiteColor];
        aView.layer.cornerRadius = 10.0f;
        aView.layer.borderColor = [UIColor blackColor].CGColor;
        aView.layer.borderWidth = 1.0f;
        aView.layer.masksToBounds = YES;
        
        // Offer Image View
        UIImageView *offerImageView = [[UIImageView alloc] initWithFrame:aView.bounds];
        offerImageView.tag = 50;
        offerImageView.contentMode = UIViewContentModeScaleToFill;
        offerImageView.backgroundColor = [UIColor clearColor];
        [offerImageView sd_setImageWithURL:[NSURL URLWithString:dvd.imageUrl]];
        [aView addSubview:offerImageView];
        
        return aView;
    }
    else
    {
        UIImageView *offerImageView = (UIImageView*)[view viewWithTag:50];
        [offerImageView sd_setImageWithURL:[NSURL URLWithString:dvd.imageUrl]];
        return view;
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
