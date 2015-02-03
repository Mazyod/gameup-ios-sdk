/*
 Copyright 2014-2015 GameUp

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "GUViewController.h"
#import "GUAchievementUpdate.h"

@implementation GUViewController
{
    UIViewController *loginController;
    NSArray* pickerData;
    NSInteger currentlySelectedRowInPicker;
}


typedef NS_ENUM(NSInteger, GUOptions)
{
    LOGIN_ANONYMOUS,
    LOGIN_FACEBOOK,
    LOGIN_GOOGLE,
    LOGIN_WEB_GAMEUP,
    LOGIN_WEB_TWITTER,
    LOGIN_WEB_FACEBOOK,
    LOGIN_WEB_GOOGLE,
    _NULL,
    PING,
    SERVER,
    GAME,
    ACHIEVEMENT,
    LEADERBOARD,
    GAMER,
    STORAGE_PUT,
    STORAGE_GET,
    STORAGE_DEL,
    GAMER_ACHIEVEMENT,
    GAMER_ACHIEVEMENT_UPDATE,
    GAMER_LEADERBOARD,
    GAMER_LEADERBOARD_UPDATE
};

- (void)awakeFromNib
{
    self.picker.dataSource = self;
    self.picker.delegate = self;
    currentlySelectedRowInPicker = 0;

    pickerData = [NSArray arrayWithObjects:
                  @"Login Anonymously",
                  @"Facebook Login",
                  @"Google Login",
                  @"GameUp Web Login",
                  @"Twitter Web Login",
                  @"Facebook Web Login",
                  @"Google Web Login",
                  @"----",
                  @"Ping",
                  @"Server Info",
                  @"Game Info",
                  @"Game Achievements",
                  @"Game Leaderboard",
                  @"Gamer Info",
                  @"PUT Storage",
                  @"GET Storage",
                  @"DEL Storage",
                  @"Gamer Achievements",
                  @"Update Achievements",
                  @"Gamer Leaderboard",
                  @"Update Leaderboard",
                  nil
                  ];

}

- (IBAction)onGoButtonClick:(id)sender
{
    switch (currentlySelectedRowInPicker) {
        case LOGIN_ANONYMOUS:
            [self loginAnonymously];
            break;
        case LOGIN_FACEBOOK:
            [_gameup loginThroughFacebookWith:[_dataHolder facebookAccessToken]];
            break;
        case LOGIN_GOOGLE:
            [_gameup loginThroughGoogleWith:[_dataHolder googleAccessToken]];
            break;
        case LOGIN_WEB_GAMEUP:
            loginController = [_gameup loginThroughBrowserToGameUp];
            [_window setRootViewController:loginController];
            break;
        case LOGIN_WEB_TWITTER:
            loginController = [_gameup loginThroughBrowserToTwitter];
            [_window setRootViewController:loginController];
            break;
        case LOGIN_WEB_FACEBOOK:
            loginController = [_gameup loginThroughBrowserToFacebook];
            [_window setRootViewController:loginController];
            break;
        case LOGIN_WEB_GOOGLE:
            loginController = [_gameup loginThroughBrowserToGoogle];
            [_window setRootViewController:loginController];
            break;
        case PING:
            [_gameup ping];
            break;
        case SERVER:
            [_gameup requestServerInfo];
            break;
        case GAME:
            [_gameup requestToGetGameDetails];
            break;
        case ACHIEVEMENT:
            [_gameup requestToGetAllAchievements];
            break;
        case LEADERBOARD:
            [_gameup requestToGetLeaderboardData:[_dataHolder leaderboardId]];
            break;
        case GAMER:
            [_gameup requestToGetGamerProfile:[_dataHolder gamerToken]];
            break;
        case STORAGE_PUT:
            [self storeData];
            break;
        case STORAGE_GET:
            [_gameup requestToGetStoredData:[_dataHolder gamerToken] storedWithKey:[_dataHolder storageKey]];
            break;
        case STORAGE_DEL:
            [_gameup requestToDeleteStoredData:[_dataHolder gamerToken] storedWithKey:[_dataHolder storageKey]];
            break;
        case GAMER_ACHIEVEMENT:
            [_gameup requestToGetAllAchievements:[_dataHolder gamerToken]];
            break;
        case GAMER_ACHIEVEMENT_UPDATE:
            [self updateAchievement];
            break;
        case GAMER_LEADERBOARD:
            [_gameup requestToGetLeaderboardDataAndRank:[_dataHolder gamerToken] withLeaderboardId:[_dataHolder leaderboardId]];
            break;
        case GAMER_LEADERBOARD_UPDATE:
            [self updateLeaderboard];
            break;
        default:
            break;
    }
}

- (void)loginAnonymously
{
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    [_gameup loginAnonymouslyWith:currentDeviceId];
}

- (void)storeData
{
    NSDictionary *storageValue = @{
       @"level" : @4,
       @"level_name" : @"boomrang",
       @"bosses_killed" : @[@"mo", @"chris", @"andrei"],
       @"coins_collected" : @2302,
       @"meters_jumped" : @1.24,
       @"meters_jumped" : @1.24,
       @"killed" : @5
    };
    
    [_gameup requestToStoreData:[_dataHolder gamerToken] storeWithKey:[_dataHolder storageKey] withValue:storageValue];
}

- (void)updateAchievement
{
    NSString* uid = [[_dataHolder achievementUids] objectAtIndex:0];
    GUAchievementUpdate* update = [[GUAchievementUpdate alloc] initWithAchievementUid:uid andCount:1];
    [_gameup requestToUpdateAchievement:[_dataHolder gamerToken] withAchievementUpdate:update];
}

- (void)updateLeaderboard
{
    NSString* uid = [_dataHolder leaderboardId];
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    GULeaderboardUpdate* update = [[GULeaderboardUpdate alloc] initWithLeaderboardUid:uid andScore:currentTime];
    [_gameup requestToUpdateLeaderboardRank:[_dataHolder gamerToken] withLeaderboardUpdate:update];
}

/////////////

- (void)backToMainView
{
    [_window setRootViewController:self];
}

- (void)enableLoginDependantButtons
{
    [[self goButton] setEnabled:true];
}

- (void)disableLoginDependantButtons
{
    [[self goButton] setEnabled:false];
}

- (void)setResultText:(NSString*) text
{
    [[self resultTextView] setText:text];
}

- (void)appendResultText:(NSString*) text
{
    NSMutableString *newText = [[NSMutableString alloc] initWithString:[[self resultTextView] text]];
    [newText appendString:@"\n"];
    [newText appendString:text];
    
    [[self resultTextView] setText:newText];
}

/////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self apiKeyTextField] setText:[_dataHolder apiKey]];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        currentlySelectedRowInPicker = row;
}

- (IBAction)onApiKeyUpdate:(id)sender
{
    [_dataHolder setApiKey:[[self apiKeyTextField] text]];
}
@end
