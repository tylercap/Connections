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
    _openGames = [[NSMutableArray alloc] init];
    [_openGames addObject:noGames];
    
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
    
    [GPGManager sharedInstance].statusDelegate = self;
    [GPGManager sharedInstance].turnBasedMatchDelegate = self;
    [GPGLauncherController sharedInstance].turnBasedMatchListLauncherDelegate = self;
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
    
    if( _signedIn ){
        [self.signInItem setTitle:@"Sign Out"];
        [self loadOpenGames];
    }
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
        _openGames = [[NSMutableArray alloc] init];
        [_openGames addObject:noGames];
        [self.tableView reloadData];
    }
}

- (void)loadOpenGames
{
    _openGames = [[NSMutableArray alloc] init];
    [_openGames addObject:quickMatch];
    [_openGames addObject:chooseOpponent];
    
//    [[GPGLauncherController sharedInstance] presentTurnBasedMatchList];
    [GPGTurnBasedMatch allMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
    {
        for (GPGTurnBasedMatch* match in matches )
        {
            if (match.status == GPGTurnBasedUserMatchStatusInvited )
            {
                [_openGames addObject:match];
            }
            else if( match.status == GPGTurnBasedUserMatchStatusTurn )
            {
                [_openGames addObject:match];
            }
            else if( match.status == GPGTurnBasedUserMatchStatusAwaitingTurn )
            {
                [_openGames addObject:match];
            }
        }
        [self.tableView reloadData];
    }];
    
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

    NSObject *object = [_openGames objectAtIndex:indexPath.row];
    if( [object isKindOfClass:[GPGTurnBasedMatch class]] ){
        GPGTurnBasedMatch *match = (GPGTurnBasedMatch *)object;
        
        GPGTurnBasedParticipant *opponent = [MyCollectionViewController getOpponent:match];
        
        switch (match.userMatchStatus)
        {
            case GPGTurnBasedUserMatchStatusTurn:         //My turn
                cell.title.text = [NSString stringWithFormat:@"%@: Your Turn", opponent.displayName];
                break;
            case GPGTurnBasedUserMatchStatusAwaitingTurn: //Their turn
                cell.title.text = [NSString stringWithFormat:@"%@: Their Turn", opponent.displayName];
                break;
            case GPGTurnBasedUserMatchStatusInvited:
                cell.title.text = [NSString stringWithFormat:@"%@: You're Invited", opponent.displayName];
                break;
            case GPGTurnBasedUserMatchStatusMatchCompleted: //Completed match
                cell.title.text = [NSString stringWithFormat:@"%@: Completed", opponent.displayName];
                break;
            default:
                cell.title.text = opponent.displayName;
                break;
        }
    }
    else{
        cell.title.text = (NSString *)object;
    }
    
    cell.title.lineBreakMode = NSLineBreakByWordWrapping;
    if( [noGames isEqualToString:cell.title.text] ){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *object = [_openGames objectAtIndex:indexPath.row];
    if( [object isKindOfClass:[GPGTurnBasedMatch class]] ){
        GPGTurnBasedMatch *match = (GPGTurnBasedMatch *)object;
        [self turnBasedMatchListLauncherDidSelectMatch:match];
    }
    else{
        NSString *gameSelected = (NSString *)object;
        
        if( [gameSelected isEqualToString:quickMatch] ){
            // set up quick match
            [self startQuickMatchGame];
        }
        else if( [gameSelected isEqualToString:chooseOpponent] ){
            // allow the user to choose their opponent
            [self inviteMyFriends];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( [alertView.title isEqualToString:@"You've been invited!"] ){
        if( buttonIndex == 0 ){
            // cancel match
            [self.matchToTrack declineWithCompletionHandler:nil];
        }
        else{
            // accept match
            [self.matchToTrack joinWithCompletionHandler:nil];
            [self performSegueWithIdentifier:@"openGame" sender:self.matchToTrack];
        }
    }
}

#pragma mark - GPGTurnBasedMatchListLauncherDelegate methods

- (void)matchEnded:(GPGTurnBasedMatch *)match
       participant:(GPGTurnBasedParticipant *)participant
fromPushNotification:(BOOL)fromPushNotification
{
    // Only show an alert if you received this from a push notification
    if (fromPushNotification) {
        NSString *messageToShow = [NSString
                                   stringWithFormat:@"%@ just finished a match. "
                                   @"Would you like view the results now?",
                                   participant.displayName];
        [[[UIAlertView alloc] initWithTitle:@"Match has ended!"
                                    message:messageToShow
                                   delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Sure!",
          nil] show];
//        self.matchToTrackFromNotification = match;
    }
    [self loadOpenGames];
}

- (void)didReceiveTurnBasedInviteForMatch:(GPGTurnBasedMatch *)match
                     fromPushNotification:(BOOL)fromPushNotification {
    // Only show an alert if you received this from a push notification
//    if (fromPushNotification) {
        GPGTurnBasedParticipant *invitingParticipant = match.lastUpdateParticipant;
        // This should always be true
        if ([match.pendingParticipant.participantId isEqualToString:match.localParticipantId]) {
            NSString *messageToShow =
            [NSString stringWithFormat:@"%@ just invited you to a game. Would you like to play now?",
             invitingParticipant.displayName];
            [[[UIAlertView alloc] initWithTitle:@"You've been invited!"
                                        message:messageToShow
                                       delegate:self
                              cancelButtonTitle:@"Not now"
                              otherButtonTitles:@"Sure!",
              nil] show];
            self.matchToTrack = match;
        }
//    }
    // Tell users they have matches that might need their attention,
    // no matter how your app reaches this method.
    [self loadOpenGames];
}

- (void)didReceiveTurnEventForMatch:(GPGTurnBasedMatch *)match
                        participant:(GPGTurnBasedParticipant *)participant
               fromPushNotification:(BOOL)fromPushNotification {
    // Only show an alert if you received this from a push notification
//    if (fromPushNotification) {
        if ([match.pendingParticipant.participantId isEqualToString:match.localParticipantId]) {
            NSString *messageToShow = [NSString stringWithFormat:
                                       @"%@ just took their turn in a match. "
                                       @"Would you like to jump to that game now?",
                                       participant.displayName];
            [[[UIAlertView alloc] initWithTitle:@"It's your turn!"
                                        message:messageToShow
                                       delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Sure!",
              nil] show];
//            self.matchToTrackFromNotification = match;
        }
//    }
    [self loadOpenGames];
}

- (void) turnBasedMatchListLauncherDidJoinMatch:(GPGTurnBasedMatch *) match
{
    NSLog( @"DID JOIN" );
}

- (void)turnBasedMatchListLauncherDidSelectMatch:(GPGTurnBasedMatch *) match
{
    NSLog( @"DID SELECT" );
    
    switch (match.userMatchStatus)
    {
        case GPGTurnBasedUserMatchStatusTurn:         //My turn
            [self performSegueWithIdentifier:@"openGame" sender:match];
            break;
        case GPGTurnBasedUserMatchStatusAwaitingTurn: //Their turn
            [self performSegueWithIdentifier:@"openGame" sender:match];
            break;
        case GPGTurnBasedUserMatchStatusInvited:
            // the game brings up a UIAlert about the match
            [self didReceiveTurnBasedInviteForMatch:match fromPushNotification:NO];
            break;
        case GPGTurnBasedUserMatchStatusMatchCompleted: //Completed match
            [self performSegueWithIdentifier:@"openGame" sender:match];
            break;
    }
}

- (void) turnBasedMatchListLauncherDidDeclineMatch:(GPGTurnBasedMatch *) match
{
    NSLog( @"DID DECLINE" );
}

- (void) turnBasedMatchListLauncherDidRematch:(GPGTurnBasedMatch *) match
{
    NSLog( @"DID REMATCH" );
}

#pragma mark - GPGPlayerPickerLauncherDelegate methods

- (int)minPlayersForPlayerPickerLauncher {
    return 1;
}

- (int)maxPlayersForPlayerPickerLauncher {
    return 1;
}

- (void)inviteMyFriends{
    // Must be a 2 player game
    [GPGLauncherController sharedInstance].playerPickerLauncherDelegate = self;
    // This assumes your class has been declared a GPGPlayerPickerLauncherDelegate
    [[GPGLauncherController sharedInstance] presentPlayerPicker];
}

- (void)playerPickerLauncherDidPickPlayers:(NSArray *) players
                        autoPickPlayerCount:(int) autoPickPlayerCount
{
    GPGMultiplayerConfig *matchConfigForCreation = [[GPGMultiplayerConfig alloc] init];
    matchConfigForCreation.invitedPlayerIds = players; // set The PlayerId of the user
    if( autoPickPlayerCount == 0 ){
        [GPGTurnBasedMatch createMatchWithConfig:matchConfigForCreation
                               completionHandler:^(GPGTurnBasedMatch *match, NSError *error)
                               {
                                   if (error) {
                                       NSLog(@"Received an error trying to create a match %@", [error localizedDescription]);
                                   } else {
                                       GPGTurnBasedMatchStatus status = match.status;
                                       if( status == GPGTurnBasedMatchStatusActive ){
                                           [self performSegueWithIdentifier:@"openGame" sender:match];
                                       }
                                       else{
                                           [self loadOpenGames];
                                       }
                                   }
                               }];
    }
    else{
        [self startQuickMatchGame];
    }
}

- (void)startQuickMatchGame
{
    GPGMultiplayerConfig *gameConfigForAutoMatch = [[GPGMultiplayerConfig alloc] init];
    // We will automatically match with one other player
    gameConfigForAutoMatch.minAutoMatchingPlayers = 1;
    gameConfigForAutoMatch.maxAutoMatchingPlayers = 1;
    
    [GPGTurnBasedMatch createMatchWithConfig:gameConfigForAutoMatch
                           completionHandler:^(GPGTurnBasedMatch *match, NSError *error)
                           {
                               if (error) {
                                   NSLog(@"Received an error trying to create a match %@", [error localizedDescription]);
                               } else {
                                   GPGTurnBasedMatchStatus status = match.status;
                                   NSInteger count = match.participants.count;
                                   if( status == GPGTurnBasedMatchStatusAutoMatching ||
                                       count == 1 )
                                   {
                                       [[[UIAlertView alloc] initWithTitle:@"No Opponent Found"
                                                                   message:@"Did not find an opponent at this time. Try again Later."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Okay"
                                                         otherButtonTitles:nil] show];
                                   }
                                   else if( status == GPGTurnBasedMatchStatusActive ){
                                       [self performSegueWithIdentifier:@"openGame" sender:match];
                                   }
                                   else{
                                       [self loadOpenGames];
                                   }
                               }
                           }];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return [sender isKindOfClass:[GPGTurnBasedMatch class]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MyCollectionViewController *destViewController = segue.destinationViewController;
    
    destViewController.match = (GPGTurnBasedMatch*)sender;
}

@end
