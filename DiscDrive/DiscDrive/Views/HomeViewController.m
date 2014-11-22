//
//  HomeViewController.m
//  DiscDrive
//
//  Created by Mani on 08/11/14.
//  Copyright (c) 2014 Mani. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "HomeCell.h"
#import "CartViewController.h"
#import "NotifyViewController.h"

#define kHOME_CELL @"HomeCell"

@interface HomeViewController ()<UIActionSheetDelegate>

@property(nonatomic, strong) NSMutableArray *movies;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIView *checkoutView;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconNotification:) name:@"beacon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutNotification:) name:@"checkout" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _movies = [[Utils dvdList:@"movies"] mutableCopy];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender
{
    [Utils deleteCurrentUser];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addLogin];
}

-(IBAction)cart:(id)sender
{
    [self hideCheckout];
    CartViewController *cartVC = [[CartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

-(void)beaconNotification:(NSNotification*)notification
{
    NSArray *finalArray = (NSArray*)notification.object;
    
    NotifyViewController *nVC = [[NotifyViewController alloc] init];
    nVC.dvds = finalArray;
    [self presentViewController:nVC animated:YES completion:^{
        
    }];
}

-(void)checkoutNotification:(NSNotification*)notification
{
    BOOL bNear = [notification.object boolValue];
    if(bNear)
    {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             CGRect frame = _checkoutView.frame;
                             frame.origin.y = 460.0f;
                             _checkoutView.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [self performSelector:@selector(hideCheckout) withObject:nil afterDelay:5.0f];
                         }];
    }
}

-(IBAction)hideCheckout
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         CGRect frame = _checkoutView.frame;
                         frame.origin.y = 568.0f;
                         _checkoutView.frame = frame;
                     }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 360.0f;
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
    [tableView dequeueReusableCellWithIdentifier:kHOME_CELL];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:kHOME_CELL
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
    DVD *dvd = [_movies objectAtIndex:indexPath.row];
    //give the user a choice of Apple or Google Maps
    NSString *action = [NSString stringWithFormat:@"Open %@", dvd.title];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:action
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Open in IMDB", nil];
    sheet.tag =indexPath.row;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
    if (buttonIndex==0)
    {
           DVD *dvd = [_movies objectAtIndex:actionSheet.tag];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dvd.imdbUrl]];
    }
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
