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

#import <UIKit/UIKit.h>
#import "GUResponderProtocol.h"

/**
 Login window view controller
 */
@interface GULoginViewController : UIViewController <UIWebViewDelegate>
{
    /** login window root view */
    IBOutlet UIView *loginRootView;
    
    /** login window naviation bar */
    __weak IBOutlet UINavigationBar *loginViewNavBar;

    /** login window naviation bar title */
    __weak IBOutlet UINavigationItem *loginViewNavBarTitle;
    
    /** login window naviation bar cancel button */
    __weak IBOutlet UIBarButtonItem *loginViewNavBarCancelButton;
    
    /** login window web viewer */
    __weak IBOutlet UIWebView *loginWebView;
}

/**
 Create a new login window with a given callback responder
 */
- (void)initWithResponder:(id<GUResponderProtocol>)guResponder
       withLoginServerUrl:(NSString*)guUrlPath
             withProvider:(NSString*)guProvider
               withApiKey:(NSString*)guApiKey
           withGamerToken:(NSString*)guGamerToken
            withUserAgent:(NSString*)guUserAgent;

@end
