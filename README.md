GameUp iOS SDK Usage
====================
The iOS SDK for the GameUp Service.

### About
[GameUp](https://gameup.io/) is a scalable, reliable, and fast gaming service for game developers.

The service provides the features and functionality provided by game servers today. Our goal is to enable game developers to focus on being as creative as possible and building great games. By leveraging the GameUp service you can easily add social login, gamer profiles, cloud game storage, and many other features.

For the full list of features check out our [main documentation](https://gameup.io/docs/).

### Setup
The client SDK is available on [CocoaPods](http://cocoadocs.org/docsets/GUGameUpSDK/)

It is fully compatible with iOS 6 and XCode 4.4+.

### Using [CocoaPods](http://cocoapods.org/)

```cocoapods
pod 'GUGameUpSDK'
```

### Getting Started

To interact with the GameUp SDK, first you need to get an ApiKey. Get yours through our [Dashboard](http://dashboard.gameup.io).

The SDK is asynchronous as it uses AFNetworking to make network calls. This means that you 'ask' for some information and some time later you'll get a callback with the desired data. To receive callbacks, you need to have a class that conforms to `GUResponderProtocol`:

```Objective-C
// MyGameUpResponder.h
#import <Foundation/Foundation.h>
#import <GUResponderProtocol.h>

@interface MyGameUpResponder : NSObject <GUResponderProtocol>
@end
```

```Objective-C
// MyGameUpResponder.m
#import "MyGameUpResponder.h"

@implementation MyGameUpResponder
- (void)failedPing:(NSInteger)statusCode withError:(NSError*) error
{
    // this is invoked when the ping fails to validate
        // either the ApiKey is invalid
        // or the Gamer Token is invalid
        // or the GameUp service is unreachable
}
- (void)retrievedGameData:(GUGame*)game
{
    // this is called whenever some game data is received.
}
// other methods that the protocol requires ...
@end
```

To interact with the SDK you need to instantiate a `GUGameUp` class and use that across your game. To instantiate:

```Objective-C
// MyGameHelper.h
#import <GUGameUp.h>

@interface MyGameHelper : NSObject
@property(readonly) GUGameUp* gameup;
// ... other properties etc
@end
```

```Objective-C
// MyGameHelper.m
#import "MyGameUpResponder.h"

static NSString *const MYGAME_API_KEY = @"your-api-key";

- (id)init {
    self = [super init];
    if (self) {
        // ... other init procedures you'd like to do!

        MyGameUpResponder *responder = [[MyGameUpResponder alloc] init];
        _gameup = [[GUGameUp alloc] initWithApiKey:MYGAME_API_KEY withResponder:responder];
    }
}
// other methods ...
```

#### Logging in

Now that you have an instance of a GUGameUp class, let's use it to log our gamer into the system. 

Signing can be done through a UIWebView which is created and maintained by the GUGameUpSDK. However this UIWebView is given back to you so you can display it however you like.

```Objective-C
// MyGameHelper.m

// let's imagine that this is the method invoked when the gamer taps on 'Sign in' in your game.
- (void)onLoginClick 
{
    // Get or create a unique device ID
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    // if you'd like to log the gamer in seamlessly...
    [_gameup loginAnonymouslyWith:currentDeviceId];

    // or if you'd like the gamer to login through Twitter using a webView:
    UIViewController* webViewController = [_gameup loginThroughBrowserToTwitter];
}
// other methods ...
```

Once the gamer has logged in through their desired login, you'll get a callback to the `MyGameUpResponder` we previously defined:

```Objective-C
// MyGameUpResponder.m

// ... other methods ...

- (void)successfullyLoggedinWithSession:(id)session 
{
    // Called with the new session when login completes successfully.
    // You may want to:
    //  * Store it - most other gamer-specific method requires this session!
    //  * Permanently Store it and retrieve it when your game restarts using [session getGamerToken];
    //  * Update your game's state.
    //  * Welcome the user!
}
- (void)failedToLoginWithError:(NSError*) error
{
    // Called when some sort of error has occured...
}
- (void)loginCancelled
{
    // Called when the gamer has tapped on the 'Cancel' button...
}

// ... other methods ...
```

#### GameUp Push

GameUp Push is extremely simple to setup. Setup your game as you would to use APN and add the following line in the method override below:

```Objective-C
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    GUSession* session = ...;
    [session subscribePushWithDeviceToken:token];
}

```

#### More Documentation

For more examples and more information on features in the GameUp service have a look at our [main documentation](https://gameup.io/docs/?ios).

#### Note

The iOS SDK is still in _flux_, we're looking for [feedback](mailto:hello@gameup.io) from developers to make sure we're designing what you need to build incredible games. Please do get in touch and let us know what we can improve.

### Contribute

All contributions to the documentation and the codebase are very welcome and feel free to open issues on the tracker wherever the documentation needs improving.

Lastly, pull requests are always welcome! `:)`
