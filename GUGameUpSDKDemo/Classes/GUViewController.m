/*
 * Copyright 2014 GameUp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "GUViewController.h"

@interface GUViewController ()

@end

@implementation GUViewController
{
    UIViewController *loginController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [apiKeyTextField setText:[_dataHolder apiKey]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setResultText:(NSString*) text
{
    [resultTextView setText:text];
}

- (void)appendResultText:(NSString*) text
{
    NSMutableString *newText = [[NSMutableString alloc] initWithString:[resultTextView text]];
    [newText appendString:@"\n"];
    [newText appendString:text];
    
    [resultTextView setText:newText];
}

- (IBAction)onPingClick:(id)sender
{
    [_gameup ping:[_dataHolder apiKey]];
}

- (IBAction)onGameClick:(id)sender
{
    [_gameup requestToGetGameDetails:[_dataHolder apiKey]];
}

- (IBAction)onLoginClick:(id)sender
{
    loginController = [_gameup requestSocialLogin:[_dataHolder apiKey]];
    [_window setRootViewController:loginController];
}

- (IBAction)onGamerClick:(id)sender
{
    [_gameup requestToGetGamerProfile:[_dataHolder apiKey] withToken:[_dataHolder gamerToken]];
}

- (IBAction)onStoreDataClick:(id)sender
{
    NSDictionary *storageValue = @{
       @"level" : @4,
       @"level_name" : @"boomrang",
       @"bosses_killed" : @[@"mo", @"chris", @"dre"],
       @"coins_collected" : @2302,
       @"meters_jumped" : @1.24,
       @"meters_jumped" : @1.24,
       @"killed" : @5
   };
    
    [_gameup requestToStoreData:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] storeWithKey:[_dataHolder storageKey] withValue:storageValue];
}

- (IBAction)onGetDataClick:(id)sender
{
    [_gameup requestToGetStoredData:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] storedWithKey:[_dataHolder storageKey]];

}

- (IBAction)onDeleteDataClick:(id)sender
{
    [_gameup requestToDeleteStoredData:[_dataHolder apiKey] withToken:[_dataHolder gamerToken] storedWithKey:[_dataHolder storageKey]];
}

- (IBAction)onApiKeyUpdate:(id)sender
{
    [_dataHolder setApiKey:[apiKeyTextField text]];
}

- (void)backToMainView
{
    [_window setRootViewController:self];
    
}

- (void)enableLoginDependantButtons
{
    [gamerButton setHidden:false];
    [storagePutButton setHidden:false];
    [storageGetButton setHidden:false];
    [storageDeleteButton setHidden:false];
}

- (void)disableLoginDependantButtons
{
    [gamerButton setHidden:true];
    [storagePutButton setHidden:true];
    [storageGetButton setHidden:true];
    [storageDeleteButton setHidden:true];
}

@end
