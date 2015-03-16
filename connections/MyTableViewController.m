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
    _openGames = @[@"Sign in to access your games"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.1];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor colorWithRed:0.05 green:0.478 blue:1.0 alpha:1.0],
                                               NSForegroundColorAttributeName,
                                               nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if( _signInItem == nil ){
        _signInItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(signInOrOut)];
    }
    self.navigationItem.rightBarButtonItem = _signInItem;
}

- (void)signInOrOut
{
    
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
    cell.title.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    MyCollectionViewController *destViewController = segue.destinationViewController;
//    destViewController.game = indexPath.row + 1;
}

@end
