//
//  CartViewController.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 SmartCues. All rights reserved.
//

#import "CartViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "HomeCell.h"

#define kCART_CELL @"CartCell"

@interface CartViewController ()

@property(nonatomic, strong) NSMutableArray *movies;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIButton *checkoutButton;
@end

@implementation CartViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutNotification:) name:@"checkout" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _movies = [[Utils cartDvdList] mutableCopy];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkoutNotification:(NSNotification*)notification
{
    BOOL bNear = [notification.object boolValue];
    if(bNear)
    {
        _checkoutButton.alpha = 1.0f;
        _checkoutButton.userInteractionEnabled = YES;
        
        [self performSelector:@selector(disableCheckout) withObject:nil afterDelay:5.0f];
    }
    else
    {
        _checkoutButton.alpha = 0.1f;
        _checkoutButton.userInteractionEnabled = NO;
    }
}

-(void)disableCheckout
{
    _checkoutButton.alpha = 0.1f;
    _checkoutButton.userInteractionEnabled = NO;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 114.0f;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _movies.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HomeCell* cell =
    [tableView dequeueReusableCellWithIdentifier:kCART_CELL];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:kCART_CELL
                                                     owner:self
                                                   options:nil];
        cell = (HomeCell*)[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setMovie:[_movies objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *aCell = (HomeCell*) cell;
    [aCell anim];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *aCell = (HomeCell*) cell;
    [aCell backanim];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
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
