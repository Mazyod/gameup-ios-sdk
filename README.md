GameUp iOS SDK Usage
====================
The iOS SDK for the GameUp Service.

### About
[GameUp](https://gameup.io/) is a scalable, reliable, and fast gaming service for game developers.

The service provides the features and functionality provided by game servers today. Our goal is to enable game developers to focus on being as creative as possible and building great games. By leveraging the GameUp service you can easily add social login, gamer profiles, cloud game storage, and many other features.

For the full list of features check out our [main documentation](https://gameup.io/docs/).

### Setup
The client SDK is available on [CocoaPods](http://cocoadocs.org/docsets/GUGameUpSDK/0.3.0)

It is fully compatible with iOS 6 and XCode 4.4+.

### Using [CocoaPods](http://http://cocoapods.org/)

```cocoapods
pod 'GUGameUpSDK', '~> 0.3.0'
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
        _gameup = [[GUGameUp alloc] initWithResponder:responder];
    }
}
// other methods ...
```

#### Logging in

Now that you have an instance of a GUGameUp class, let's use it to log our gamer into the system. 

Signing is done through a UIWebView which is created and maintained by the GUGameUpSDK. However this UIWebView is given back to you so you can display it however you like.

```Objective-C
// MyGameHelper.m

// let's imagine that this is the method invoked when the gamer taps on 'Sign in' in your game.
- (void)onLoginClick 
{
    UIViewController* webViewController = [_gameup requestSocialLogin:[MyGame]];

    // somehow display the given view controller in your game - we recommend through your current views NavigationController
    [navigationController pushViewController:webViewController animated:YES];
}
// other methods ...
```

Once the gamer has logged in through their desired social login, you'll get a callback to the `MyGameUpResponder` we previously defined:

```Objective-C
// MyGameUpResponder.m

// ... other methods ...

- (void)successfullyLoggedinWithGamerToken:(NSString*)gamerToken 
{
    // Called with the new session when login completes successfully.
        // You may want to:
        //  * Store it - most other gamer-specific method requires this gamerToken!
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

#### Quickstart

The iOS SDK has a quickstart guide to help familiarise you with the API quickly it's available [here](http://gameup-io.github.io/gameup-ios-sdk/).

#### More Documentation

For more examples and more information on features in the GameUp service have a look at our [main documentation](https://gameup.io/docs/?ios).

#### Note

The iOS SDK is still in _flux_, we're looking for [feedback](mailto:hello@gameup.io) from developers to make sure we're designing what you need to build incredible games. Please do get in touch and let us know what we can improve.

===========

GameUp iOS SDK Development
==========================

This part of the README is intended for those who would like to develop the `GUGameUpSDK` and `GUGameUpSDKDemo` app.

To develop on the codebase you'll need:

* [XCode 4.4+](https://developer.apple.com/xcode/) The iOS IDE (We internally use XCode 5)
* [CocoaPods](http://cocoapods.org/) for dependecy management.
* [Alcatraz](http://alcatraz.io) for plugin management within XCode. This is optional (but we use it internally).

_If you want to use JetBrains AppCode, you need to disable Code Signing Requirement for the GUGameUpSDKDemo App. 
To do this, you need to follow this [Stackoverflow Question](http://stackoverflow.com/questions/9898039/xcode-4-3-2-bypass-code-signing)._

#### System Dependencies

* Install CocoaPods:

` sudo gem install cocoapods `

* Install Alcatraz:

` curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh `

#### Project Development Steps

* Open the `GUGameUpSDKDemo.xcworkspace` in XCode. `GUGameUpSDK` can be found in the `Development Pods` group in the `Pods` project.     
* Clean the project build directory by pressing the following keys: `Alt`+`Cmd`+`Shift`+`K`

* Please ignore any `#pragma` warning that you get about `AFHTTPClient.h`. This warning is fixed in AFNetworking 2.0.

* To install dependencies (only needed when changing/updating Podfile):
`pod install`

### Contribute

All contributions to the documentation and the codebase are very welcome and feel free to open issues on the tracker wherever the documentation needs improving.

Lastly, pull requests are always welcome! `:)`
