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

#import "GULoginViewController.h"
#import "GUSession.h"

static NSString *const SUCCESS_SUB_URL = @"success";

@implementation GULoginViewController
{
    id<GUResponderProtocol> responder;
    id<GURequestRetryHandlerProtocol> retryHandler;
    NSString* urlPath;
    NSString* provider;
    NSString* apiKey;
    NSString* gamerToken;
    NSString* userAgent;
}

- (void)initWithResponder:(id<GUResponderProtocol>)guResponder
         withRetryHandler:(id<GURequestRetryHandlerProtocol>) guRetryHandler
       withLoginServerUrl:(NSString*)guUrlPath
             withProvider:(NSString*)guProvider
               withApiKey:(NSString*)guApiKey
           withGamerToken:(NSString*)guGamerToken
            withUserAgent:(NSString*)guUserAgent
{
    responder = guResponder;
    retryHandler = guRetryHandler;
    urlPath = guUrlPath;
    provider = guProvider;
    apiKey = guApiKey;
    gamerToken = guGamerToken;
    userAgent = guUserAgent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loginViewNavBarCancelButton.action = @selector(onCancelButtonTap);
    
    NSMutableString *fullUrlPathWithApiKey = [[NSMutableString alloc] initWithString:urlPath];
    [fullUrlPathWithApiKey appendString:provider];
    [fullUrlPathWithApiKey appendString:@"?apiKey="];
    [fullUrlPathWithApiKey appendString:apiKey];
    
    if ([gamerToken length] > 0) {
        [fullUrlPathWithApiKey appendString:@"&token="];
        [fullUrlPathWithApiKey appendString:gamerToken];
    }
    
    NSURL *url = [NSURL URLWithString:fullUrlPathWithApiKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // this is the best we can do
    // as we don't want to change the NSUserDefaults user-agent values
    // which can also effect the game too.
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    [loginWebView setDelegate:self];
    [loginWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onCancelButtonTap
{
    [responder loginCancelled];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentUrl = webView.request.URL.absoluteString;

    NSMutableString *guSuccessPath = [[NSMutableString alloc] initWithString:urlPath];
    [guSuccessPath appendString:SUCCESS_SUB_URL];
    
    if ([currentUrl hasPrefix:guSuccessPath]) {
        [guSuccessPath appendString:@"?apiKey="];
        [guSuccessPath appendString:apiKey];
        [guSuccessPath appendString:@"&token="];
        
        NSString *token = [currentUrl substringFromIndex:guSuccessPath.length];
        id session = [[GUSession alloc] initWithApiKey:apiKey
                                             withToken:token
                                         withResponder:responder
                                      withRetryHandler:retryHandler];
        [responder successfullyLoggedinWithSession:session];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [responder failedToLoginWithError:error];
}
- (BOOL)shouldAutorotate {
    return YES;
}


@end
