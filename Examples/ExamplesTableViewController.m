//
//  ExamplesTableViewController.m
//  Examples
//
//  Created by Jason Wray on 1/26/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "ExamplesTableViewController.h"
#import "Examples.h"
#import "ExamplesContainerViewController.h"

NSString *const MBXSegueTableToExample = @"TableToExampleSegue";

@interface ExamplesTableViewController ()

@property (nonatomic) NSArray *exampleGroups;
@property (nonatomic) UISegmentedControl *languagesSegementControl;
@property (nonatomic, readonly) NSDictionary *selectedGroup;

@end
@implementation ExamplesTableViewController

- (NSArray *)selectedGroup {
    return self.exampleGroups[self.languagesSegementControl.selectedSegmentIndex];
}

- (NSDictionary *)exampleAtIndexPath:(NSIndexPath *)indexPath {
    return self.selectedGroup[@"categories"][indexPath.section][@"examples"][indexPath.row];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    // do this ourselves, as automatic doesn't work with fast swipes
    self.clearsSelectionOnViewWillAppear = NO;

    // testing: explicitly jump to an example, later defined in prepareForSegue
    //[self performSegueWithIdentifier:MBXSegueTableToExample sender:self];
    
    // To avoid gesture conflict with mapview,  disable menu presented and dismissed using a swipe gesture.
    self.splitViewController.presentsWithGesture = NO;
    // The menu and example view controllers are displayed side-by-side onscreen.
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    if (!self.exampleGroups) {
        self.exampleGroups = [Examples groups];
    }
    NSMutableArray *languageNames = [NSMutableArray array];
    [self.exampleGroups enumerateObjectsUsingBlock:^(NSDictionary *exampleGroup, NSUInteger index, BOOL *stop) {
        [languageNames addObject:exampleGroup[@"title"]];
    }];

    UISegmentedControl *languagesSegementControl = [[UISegmentedControl alloc] initWithItems:languageNames];
    [languagesSegementControl sizeToFit];
    languagesSegementControl.selectedSegmentIndex = 0;
    [languagesSegementControl addTarget:self
                                 action:@selector(onLanguagesSegementControlValueChanged:)
                       forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = languagesSegementControl;
    
    self.languagesSegementControl = languagesSegementControl;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];

    [self.languagesSegementControl sizeToFit];
}

#pragma mark - Segement control event handle
- (void)onLanguagesSegementControlValueChanged:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [(NSArray *)self.selectedGroup[@"categories"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *examples = self.selectedGroup[@"categories"][section][@"examples"];
    
    return examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self exampleAtIndexPath:indexPath][@"title"];
    cell.detailTextLabel.text = [self exampleAtIndexPath:indexPath][@"className"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *exampleName = [self exampleAtIndexPath:indexPath][@"className"];
    [self showExample:exampleName];
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.bounds = CGRectMake(0, 0, tableView.bounds.size.width, 60);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = UIEdgeInsetsInsetRect(headerView.bounds, UIEdgeInsetsMake(0, tableView.separatorInset.left, 0, 0));
    label.text = self.selectedGroup[@"categories"][section][@"title"];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];

    [headerView addSubview:label];

    return headerView;
}

#pragma mark - Navigation

- (void)showExample: (NSString *)exampleName {
    ExamplesContainerViewController* containerController =[self.storyboard instantiateViewControllerWithIdentifier:@"ExamplesContainer"];
    containerController.exampleToLoad = exampleName;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:containerController];
    
    containerController.navigationItem.leftItemsSupplementBackButton = true;
    containerController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    [self.splitViewController showDetailViewController:navController sender:nil];
}

@end
