//
//  MyTableViewController.m
//  connections
//
//  Created by Tyler Cap on 2/23/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyCollectionViewController.h"

static NSString * const GoogleClientId = @"317322985582-t01dgsg9toha0l71e18udc6nu9ae1b73";
//static NSString * const GoogleClientId = @"317322985582-t01dgsg9toha0l71e18udc6nu9ae1b73.apps.googleusercontent.com";

static NSString * const noGames = @"Sign in to access your games";
static NSString * const quickMatch = @"Quick Match";
static NSString * const chooseOpponent = @"Choose Opponent";
static NSString * const openGame = @"openGame";
static NSString * const invited = @"You've been invited!";
static NSString * const yourTurn = @"It's your turn!";
static NSString * const matchEnded = @"Match has ended!";

@implementation MyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _openGames = [[NSMutableArray alloc] init];
    [_openGames addObject:noGames];
    
    [GPGManager sharedInstance].statusDelegate = self;
    [GPGManager sharedInstance].turnBasedMatchDelegate = self;
    [GPGLauncherController sharedInstance].turnBasedMatchListLauncherDelegate = self;
    
    _signedIn = NO;
    
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserverForName:AppOpenGoogleNotification
                              object:nil
                               queue:nil
                          usingBlock:^(NSNotification *notification){
                              [self handleNotification:notification];
                          }];
    
    _silentlySigningIn = [[GPGManager sharedInstance] signInWithClientID:GoogleClientId silently:YES];
    [self refreshInterfaceBasedOnSignIn];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshInterfaceBasedOnSignIn];
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
    if ([GPGManager sharedInstance].isSignedIn) {
        // Request information about the local player
        [GPGPlayer localPlayerWithCompletionHandler:^(GPGPlayer *player, NSError *error) {
            if (!error) {
//                GPGPlayer *localPlayer = player;
                [self doLoadOpenGames];
            }
            else{
                [[[UIAlertView alloc] initWithTitle:@"Unable To Properly Login"
                                            message:@"Check you internet connection, or try again later."
                                           delegate:self
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil] show];
            }
        }];
    }
}

- (void)doLoadOpenGames
{
    [GPGTurnBasedMatch allMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
     {
        _openGames = [[NSMutableArray alloc] init];
        [_openGames addObject:quickMatch];
        [_openGames addObject:chooseOpponent];
         
        for (GPGTurnBasedMatch* match in matches)
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
            else if( match.status == GPGTurnBasedUserMatchStatusMatchCompleted )
            {
                [_openGames addObject:match];
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)didFinishGamesSignInWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);
    } else {
        NSLog(@"Signed in!");
    }
    
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while signing out %@", [error localizedDescription]);
    } else {
        NSLog(@"Signed out!");
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
        
        Model *model = [[Model alloc] init];
        [model loadFromData:match];
        NSString *opponentName = [model getOpponentDisplayName];
        
        NSString *resultStr = @"Match Expired";
        switch (match.userMatchStatus)
        {
            case GPGTurnBasedUserMatchStatusTurn:         //My turn
                cell.title.text = [NSString stringWithFormat:@"%@: Your Turn", opponentName];
                break;
            case GPGTurnBasedUserMatchStatusAwaitingTurn: //Their turn
                cell.title.text = [NSString stringWithFormat:@"%@: Their Turn", opponentName];
                break;
            case GPGTurnBasedUserMatchStatusInvited:
                cell.title.text = [NSString stringWithFormat:@"%@: You're Invited", opponentName];
                break;
            case GPGTurnBasedUserMatchStatusMatchCompleted: //Completed match
                for (GPGTurnBasedParticipantResult *result in match.results)
                {
                    if( [result.participantId isEqualToString:[model getOpponent].participantId] ){
                        // opponent result
                        if( result.result == GPGTurnBasedParticipantResultStatusWin ){
                            resultStr = @"You Lost";
                        }
                        if( result.result == GPGTurnBasedParticipantResultStatusLoss ){
                            resultStr = @"You Won!";
                        }
                    }
                    else{
                        // my result
                        if( result.result == GPGTurnBasedParticipantResultStatusWin ){
                            resultStr = @"You Won!";
                        }
                        if( result.result == GPGTurnBasedParticipantResultStatusLoss ){
                            resultStr = @"You Lost";
                        }
                    }
                }
                
                cell.title.text = [NSString stringWithFormat:@"%@: %@", opponentName, resultStr];
                break;
            default:
                cell.title.text = opponentName;
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
    if( [alertView.title isEqualToString:matchEnded] ){
        if( buttonIndex == 0 ){
            // cancel
        }
        else{
            // go to match
            [self performSegueWithIdentifier:openGame sender:self.matchToTrack];
        }
    }
    else if( [alertView.title isEqualToString:invited] ){
        if( buttonIndex == 0 ){
            if( self.shouldDeclineMatch ){
                // decline the match
                [self.matchToTrack declineWithCompletionHandler:nil];
                [self loadOpenGames];
            }
            else{
                // don't cancel match, just save it for later
            }
        }
        else{
            // accept match
            [self.matchToTrack joinWithCompletionHandler:nil];
            [self performSegueWithIdentifier:openGame sender:self.matchToTrack];
        }
    }
    else if( [alertView.title isEqualToString:yourTurn] ){
        if( buttonIndex == 0 ){
            // cancel
        }
        else{
            // go to match
            [self performSegueWithIdentifier:openGame sender:self.matchToTrack];
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
                                   @"Would you like to view the results now?",
                                   participant.displayName];
        [[[UIAlertView alloc] initWithTitle:matchEnded
                                    message:messageToShow
                                   delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Sure!",  nil] show];
        self.matchToTrack = match;
    }
    [self loadOpenGames];
}

- (void)didReceiveTurnBasedInviteForMatch:(GPGTurnBasedMatch *)match
                     fromPushNotification:(BOOL)fromPushNotification
{
    [self didReceiveTurnBasedInviteForMatch:match fromPushNotification:fromPushNotification declineOnCancel:NO];
}

- (void)didReceiveTurnBasedInviteForMatch:(GPGTurnBasedMatch *)match
                     fromPushNotification:(BOOL)fromPushNotification
                          declineOnCancel:(BOOL)decline
{
    NSString *cancelTitle = @"Not now";
    if( decline ){
        cancelTitle = @"Decline";
    }
    
//    if (fromPushNotification) {
        GPGTurnBasedParticipant *invitingParticipant = match.lastUpdateParticipant;
        // This should always be true
        if ([match.pendingParticipant.participantId isEqualToString:match.localParticipantId]) {
            NSString *messageToShow =
            [NSString stringWithFormat:@"%@ just invited you to a game. Would you like to play now?",
             invitingParticipant.displayName];
            [[[UIAlertView alloc] initWithTitle:invited
                                        message:messageToShow
                                       delegate:self
                              cancelButtonTitle:cancelTitle
                              otherButtonTitles:@"Sure!",
              nil] show];
            self.matchToTrack = match;
            self.shouldDeclineMatch = decline;
        }
//    }
    // Tell users they have matches that might need their attention,
    // no matter how your app reaches this method.
    [self loadOpenGames];
}

- (void)didReceiveTurnEventForMatch:(GPGTurnBasedMatch *)match
                        participant:(GPGTurnBasedParticipant *)participant
               fromPushNotification:(BOOL)fromPushNotification
{
    // Only show an alert if you received this from a push notification
//    if (fromPushNotification) {
        if ([match.pendingParticipant.participantId isEqualToString:match.localParticipantId]) {
            NSString *messageToShow = [NSString stringWithFormat:
                                       @"%@ just took their turn in a match. "
                                       @"Would you like to jump to that game now?",
                                       participant.displayName];
            [[[UIAlertView alloc] initWithTitle:yourTurn
                                        message:messageToShow
                                       delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Sure!",
              nil] show];
            self.matchToTrack = match;
        }
//    }
    [self loadOpenGames];
}

- (void)turnBasedMatchListLauncherDidSelectMatch:(GPGTurnBasedMatch *) match
{
    NSLog( @"DID SELECT" );
    
    switch (match.userMatchStatus)
    {
        case GPGTurnBasedUserMatchStatusTurn:         //My turn
            [self performSegueWithIdentifier:openGame sender:match];
            break;
        case GPGTurnBasedUserMatchStatusAwaitingTurn: //Their turn
            [self performSegueWithIdentifier:openGame sender:match];
            break;
        case GPGTurnBasedUserMatchStatusInvited:
            // the game brings up a UIAlert about the match
            [self didReceiveTurnBasedInviteForMatch:match fromPushNotification:NO declineOnCancel:YES];
            break;
        case GPGTurnBasedUserMatchStatusMatchCompleted: //Completed match
            [self performSegueWithIdentifier:openGame sender:match];
            break;
    }
}
              
- (void) turnBasedMatchListLauncherDidJoinMatch:(GPGTurnBasedMatch *) match
{
    NSLog( @"DID JOIN" );
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

- (void)inviteMyFriends
{
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
                                           [self submitNewMatch:match];
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
    [[GPGLauncherController sharedInstance] presentTurnBasedMatchList];
//    GPGMultiplayerConfig *gameConfigForAutoMatch = [[GPGMultiplayerConfig alloc] init];
//    // We will automatically match with one other player
//    gameConfigForAutoMatch.minAutoMatchingPlayers = 1;
//    gameConfigForAutoMatch.maxAutoMatchingPlayers = 1;
//    
//    [GPGTurnBasedMatch createMatchWithConfig:gameConfigForAutoMatch
//                           completionHandler:^(GPGTurnBasedMatch *match, NSError *error)
//                           {
//                               if (error) {
//                                   NSLog(@"Received an error trying to create a match %@", [error localizedDescription]);
//                               } else {
//                                   GPGTurnBasedMatchStatus status = match.status;
//                                   NSInteger count = match.participants.count;
//                                   if( status == GPGTurnBasedMatchStatusAutoMatching ||
//                                       count == 1 )
//                                   {
//                                       [[[UIAlertView alloc] initWithTitle:@"No Opponent Found"
//                                                                   message:@"Did not find an opponent at this time. Try again Later."
//                                                                  delegate:nil
//                                                         cancelButtonTitle:@"Okay"
//                                                         otherButtonTitles:nil] show];
//                                   }
//                                   else if( status == GPGTurnBasedMatchStatusActive ){
//                                       [self submitNewMatch:match];
//                                   }
//                                   else{
//                                       [self loadOpenGames];
//                                   }
//                               }
//                           }];
}

- (void)submitNewMatch:(GPGTurnBasedMatch*)match
{
    GPGTurnBasedParticipant *me = match.localParticipant;
    if( me == nil ){
        [[[UIAlertView alloc] initWithTitle:@"Unable To Create New Game"
                                    message:@"Check you internet connection, or try again later."
                                   delegate:self
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
        
        [match dismissWithCompletionHandler:nil];
        [match cancelWithCompletionHandler:nil];
        return;
    }
    
    Model *model = [[Model alloc]init];
    [model loadNewGame:match localParticipant:me];
    
    NSData *data = [model storeToData];
    [match takeTurnWithNextParticipantId:me.participantId data:data results:match.results completionHandler:^(NSError *error)
     {
         if (error) {
             [[[UIAlertView alloc] initWithTitle:@"Unable To Create New Game"
                                         message:@"Check you internet connection, or try again later."
                                        delegate:self
                               cancelButtonTitle:@"Okay"
                               otherButtonTitles:nil] show];
             
             [match dismissWithCompletionHandler:nil];
             [match cancelWithCompletionHandler:nil];
             return;
         } else {
             [self performSegueWithIdentifier:openGame sender:match];
         }
     }];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if( ![sender isKindOfClass:[GPGTurnBasedMatch class]] ){
        return NO;
    }
    
    GPGTurnBasedMatch *match = (GPGTurnBasedMatch*)sender;
    return (match.data != nil);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MyCollectionViewController *destViewController = segue.destinationViewController;
    
    destViewController.match = (GPGTurnBasedMatch*)sender;
    destViewController.lobby = self;
}

@end
