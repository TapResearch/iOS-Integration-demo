# TapResearch iOS Integration demo app

This simple app demonstrates how to integrate the TapResearch SDK in your app.

* Clone the repo

~~~~~~bash
$ git clone git@github.com:TapResearch/iOS-Integration-demo.git
~~~~~~

* Make sure you have [CocoaPods](https://cocoapods.org/) and install the TapResearch pod

~~~~~bash
$ pod install
~~~~~

* Open the workspace

~~~~~bash
$ open TapresearchDemo.xcworkspace
~~~~~

* If you want to see the app in action make sure you add your iOS api token and a user identifier in `AppDelegate.m`

~~~~objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [TapResearch initWithApiToken: @"<The API Token>" delegate:self];
    [TapResearch setUniqueUserIdentifier:@"<User Identifier"];

    return YES;
}
~~~~

Please send all questions, concerns, or bug reports to developers@tapresearch.com.
