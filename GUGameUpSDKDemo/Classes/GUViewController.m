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

- (void)awakeFromNib
{
    self.picker.dataSource = self;
    self.picker.delegate = self;
    currentlySelectedRowInPicker = 0;
    
    pickerData = [NSArray arrayWithObjects:
                  @"Ping",
                  @"Server Info",
                  @"Game Info",
                  @"Game Achievements",
                  @"Login",
                  @"Gamer Info",
                  @"PUT Storage",
                  @"GET Storage",
                  @"DEL Storage",
                  @"Gamer Achievements",
                  @"Update Achievements",
                  nil
                  ];

}

- (IBAction)onGoButtonClick:(id)sender
{
    // case number correspond to the index of the pickerData array
    switch (currentlySelectedRowInPicker) {
        case 0:
            [_gameup ping:[_dataHolder apiKey]];
            break;
        case 1:
            [_gameup requestServerInfo:[_dataHolder apiKey]];
            break;
        case 2:
            [_gameup requestToGetGameDetails:[_dataHolder apiKey]];
            break;
        case 3:
            [_gameup requestToGetAllAchievements:[_dataHolder apiKey]];
            break;
        case 4:
            loginController = [_gameup requestSocialLogin:[_dataHolder apiKey]];
            [_window setRootViewController:loginController];
            break;
        case 5:
            [_gameup requestToGetGamerProfile:[_dataHolder apiKey] withToken:[_dataHolder gamerToken]];
            break;
        case 6:
            [self storeData];
            break;
        case 7:
            [_gameup requestToGetStoredData:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] storedWithKey:[_dataHolder storageKey]];
            break;
        case 8:
            [_gameup requestToDeleteStoredData:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] storedWithKey:[_dataHolder storageKey]];
            break;
        case 9:
            [_gameup requestToGetAllAchievements:[_dataHolder apiKey] withToken:[_dataHolder gamerToken]];
            break;
        case 10:
            [self updateAchievement];
            break;
        default:
            break;
    }
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
    
    [_gameup requestToStoreData:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] storeWithKey:[_dataHolder storageKey] withValue:storageValue];
}

- (void)updateAchievement
{
    NSString* uid = [[_dataHolder achievementUids] objectAtIndex:0];
    GUAchievementUpdate* update = [[GUAchievementUpdate alloc] initWithAchievementUid:uid andCount:1];
    [_gameup requestToUpdateAchievement:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] withAchievementUpdate:update];
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
