//
//  MyTableViewController.m
//  jumpsumfree
//
//  Created by Tyler Cap on 2/23/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyTableViewController.h"

static NSString * const GoogleClientId = @"317322985582-t01dgsg9toha0l71e18udc6nu9ae1b73.apps.googleusercontent.com";
static NSString * const noGames = @"Sign in to access your games";
static NSString * const quickMatch = @"Quick Match";
static NSString * const chooseOpponent = @"Choose Opponent";


@implementation MyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _openGames = @[noGames];
    
    [GPGManager sharedInstance].statusDelegate = self;
    _silentlySigningIn = [[GPGManager sharedInstance] signInWithClientID:GoogleClientId silently:YES];
    [self refreshInterfaceBasedOnSignIn];
    _signedIn = NO;
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserverForName:AppOpenGoogleNotification
                              object:nil
                               queue:nil
                          usingBlock:^(NSNotification *notification){
                              [self handleNotification:notification];
                          }];
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

- (void)handleNotification:(NSNotification*)notification
{
    MyWebViewController *mwvc =[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [mwvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:mwvc animated:YES completion:nil];
    
    NSURL *request = [notification object];
    [mwvc loadRequest:request];
}

- (void)signInOrOut
{
    if( _signedIn ){
        [[GPGManager sharedInstance] signOut];
    }
    else{
        [[GPGManager sharedInstance] signInWithClientID:GoogleClientId silently:NO];
    }
}

- (void)refreshInterfaceBasedOnSignIn {
    _signedIn = [GPGManager sharedInstance].isSignedIn;
    
    if( _signedIn ){
        [self.signInItem setTitle:@"Sign Out"];
        [self loadOpenGames];
    }
    else{
        [self.signInItem setTitle:@"Sign In"];
        _openGames = @[noGames];
        [self.tableView reloadData];
    }
}

- (void)loadOpenGames
{
    _openGames = @[quickMatch, chooseOpponent];
    
    [self.tableView reloadData];
}

- (void)didFinishGamesSignInWithError:(NSError *)error {
    if (error) {
        //NSLog(@"Received an error while signing in %@", [error localizedDescription]);
    } else {
        //NSLog(@"Signed in!");
    }
    
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
    if (error) {
        //NSLog(@"Received an error while signing out %@", [error localizedDescription]);
    } else {
        //NSLog(@"Signed out!");
    }
    
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
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
    if( [noGames isEqualToString:cell.title.text] ){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MyCollectionViewController *destViewController = segue.destinationViewController;
    NSString *gameSelected = [_openGames objectAtIndex:indexPath.row];
    
    if( [gameSelected isEqualToString:quickMatch] ){
        //TODO: set up quick match
        gameSelected = @"Test Game";
    }
    else if( [gameSelected isEqualToString:chooseOpponent] ){
        //TODO: allow the user to choose their opponent
        gameSelected = @"Test 2";
    }
    
    destViewController.game = gameSelected;
}

@end
