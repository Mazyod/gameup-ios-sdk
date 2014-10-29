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

#import <GUGameUp.h>
#import "GUAppDelegate.h"
#import "GUViewController.h"
#import "GUDemoResponderDelegate.h"
#import "GUDataHolder.h"

static NSString *const APIKEY = @"";

@implementation GUAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[GUViewController alloc] initWithNibName:@"GUViewController" bundle:nil];
    self.window.rootViewController = self.viewController;

    GUDataHolder *dataHolder = [[GUDataHolder alloc] init];
    [dataHolder setApiKey:APIKEY]; //setup initial ApiKey for testing purposes...
    
    GUDemoResponderDelegate *delegate = [GUDemoResponderDelegate alloc];
    [delegate setViewController:self.viewController];
    [delegate setDataHolder:dataHolder];
    
    GUGameUp *gameup = [[GUGameUp alloc] initWithResponder:delegate];
    [self.viewController setGameUpController:gameup];
    [self.viewController setDataHolder:dataHolder];
    [self.viewController setWindow:_window];
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

@end
