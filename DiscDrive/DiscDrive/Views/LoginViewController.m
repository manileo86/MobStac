//
//  LoginViewController.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "Collector.h"

@interface LoginViewController ()

@property(nonatomic, strong) IBOutlet UIButton *maleButton;
@property(nonatomic, strong) IBOutlet UIButton *femaleButton;
@property(nonatomic, strong) IBOutlet UIButton *shopButton;
@property(nonatomic, strong) IBOutlet UITextField *nameField;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _shopButton.layer.cornerRadius = 26.0f;
    _nameField.layer.cornerRadius = 30.0f;
}

-(IBAction)maleButtonPressed:(id)sender
{
    _maleButton.selected = YES;
    _femaleButton.selected = NO;
    [UIView animateWithDuration:0.25f animations:^{
        _maleButton.alpha = 1.0f;
        _femaleButton.alpha = 0.3f;
    }];
}

-(IBAction)femaleButtonPressed:(id)sender
{
    _maleButton.selected = NO;
    _femaleButton.selected = YES;
    [UIView animateWithDuration:0.25f animations:^{
        _femaleButton.alpha = 1.0f;
        _maleButton.alpha = 0.3f;
    }];
}

-(IBAction)shopButtonPressed:(id)sender
{
    User *user = [[User alloc] init];
    user.name = _nameField.text;
    user.gender = _maleButton.selected?Male:Female;
    [Utils saveUser:user];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addHome];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
