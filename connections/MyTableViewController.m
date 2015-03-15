//
//  MyTableViewController.m
//  jumpsumfree
//
//  Created by Tyler Cap on 2/23/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyTableViewController.h"

@implementation MyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _openGames = @[@"You must be signed in to access your games"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    /*self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.9 blue:1.0 alpha:0.1];
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1 green:0.68 blue:0.25 alpha:0.2];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor colorWithRed:0.0 green:0.0 blue:0.44 alpha:1.0],
                                               NSForegroundColorAttributeName,
                                               nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];*/
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [_openGames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OpenGame" forIndexPath:indexPath];

    cell.title.text = [_openGames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    MyCollectionViewController *destViewController = segue.destinationViewController;
//    destViewController.game = indexPath.row + 1;
}

@end
