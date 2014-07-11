//
//  WFLeftSideCityListViewController.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/8/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFLeftSideCityListViewController.h"
#import "WFGlobalDataManager.h"

@interface WFLeftSideCityListViewController () <UITableViewDataSource, UITabBarControllerDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton    *fahrenheitButton;
@property (weak, nonatomic) IBOutlet UIButton    *celsiumButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIScrollView         *pageViewScrollView;

@end

@implementation WFLeftSideCityListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    [self.tableView setAccessibilityLabel:@"City List"];
    [self.tableView setIsAccessibilityElement:YES];
    
    [self convertButtonImagesToTemplate:self.fahrenheitButton];
    [self convertButtonImagesToTemplate:self.celsiumButton];
    
    [self updateButtonsSelectionStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.pageViewScrollView setScrollEnabled:YES];
}

#pragma mark - Private methods

- (void)updateButtonsSelectionStyle {
    self.fahrenheitButton.selected = [WFGlobalDataManager sharedManager].fahrenheit;
    self.celsiumButton.selected = ![WFGlobalDataManager sharedManager].fahrenheit;
}

- (void)convertButtonImagesToTemplate:(UIButton *)button {
    UIImage* image = [[button imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateNormal];
    
    image = [[button imageForState:UIControlStateHighlighted] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateHighlighted];
    
    image = [[button imageForState:UIControlStateSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateSelected];
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pageViewController showViewControllerAtIndex:(indexPath.row + LEFT_VC_COUNT_IN_STACK) fromIndex:self.pageIndex animated:YES completion:^(BOOL finished) {
        for (NSIndexPath *indexPath in tableView.indexPathsForSelectedRows) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [WFGlobalDataManager sharedManager].cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CitySearchTableViewCellIdentifier";
    SWTableViewCell *cell = (SWTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    City *city = [WFGlobalDataManager sharedManager].cityList[indexPath.row];
    
    if (![city.isCurrentLocation boolValue]) {
        NSMutableArray *buttons = [@[] mutableCopy];
        [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"Delete"];
#ifdef DEBUG
        UIButton *deleteButton = [buttons firstObject];
        [deleteButton setAccessibilityLabel:@"Delete"];
        [deleteButton setIsAccessibilityElement:YES];
#endif
        
        cell.rightUtilityButtons = buttons;
        cell.delegate = self;
        cell.accessoryView = nil;
    } else {
        cell.rightUtilityButtons = nil;
        cell.delegate = nil;
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"locationIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        accessoryView.tintColor = [UIColor whiteColor];
        CGRect frame = accessoryView.frame;
        frame.size.height = cell.contentView.frame.size.height;
        frame.size.width = frame.size.height;
        cell.accessoryView = accessoryView;
    }
    
    cell.textLabel.text = city.name;
    cell.tag = indexPath.row;
    
#ifdef DEBUG
    [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
    [cell setAccessibilityIdentifier:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
#endif
    
    return cell;
}

#pragma mark - SWCell Delegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    City *city = [WFGlobalDataManager sharedManager].cityList[cell.tag];
    [city MR_deleteEntity];
    [[WFGlobalDataManager sharedManager].cityList removeObjectAtIndex:cell.tag];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    if ([WFGlobalDataManager sharedManager].cityList.count > 0) {
        [self.pageViewController showViewControllerAtIndex:0 fromIndex:0 animated:NO completion:NULL]; // PageVC workaround for data source updating
    } else {
        [self.pageViewController showViewControllerAtIndex:1 fromIndex:0 animated:YES completion:NULL];
    }

    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfWithCompletion:NULL];
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state //workaround with hiding gestrecognizer on page vc iOS6+
{
    if (!self.pageViewScrollView) {
        for (UIScrollView *view in self.pageViewController.pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                self.pageViewScrollView = view;
                [self.pageViewScrollView setScrollEnabled:NO];
            }
        }
    } else {
        [self.pageViewScrollView setScrollEnabled:NO];
    }
    return YES;
}

-(void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell //workaround with hiding gestrecognizer on page vc iOS6+
{
   [self.pageViewScrollView setScrollEnabled:YES];
}

#pragma mark - Button Actions


- (IBAction)fahrenheitButtonDidRecieveTap:(id)sender {
    [WFGlobalDataManager sharedManager].fahrenheit = NO;
    [self updateButtonsSelectionStyle];
}


- (IBAction)celsiumButtonDidRecieveTap:(id)sender {
    [WFGlobalDataManager sharedManager].fahrenheit = YES;
    [self updateButtonsSelectionStyle];
}

@end
