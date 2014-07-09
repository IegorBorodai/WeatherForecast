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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WFLeftSideCityListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pageViewController showViewControllerAtIndex:(indexPath.row + 1) fromIndex:0 completion:^(BOOL finished) {
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
    
    NSMutableArray *buttons = [@[] mutableCopy];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"Delete"];
    cell.rightUtilityButtons = buttons;
    cell.delegate = self;
    
    City *city = [WFGlobalDataManager sharedManager].cityList[indexPath.row];
    
    cell.textLabel.text = city.name;
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - SWCell Delegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    City *city = [WFGlobalDataManager sharedManager].cityList[cell.tag];
    [city MR_deleteEntity];
    [[WFGlobalDataManager sharedManager].cityList removeObjectAtIndex:cell.tag];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
