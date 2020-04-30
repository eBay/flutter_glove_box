#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import Apptentive;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ApptentiveConfiguration* configuration = [ApptentiveConfiguration configurationWithApptentiveKey:@"apptentiveKey-for-ios" apptentiveSignature:@"apptentive signature"];
    [Apptentive registerWithConfiguration:configuration];

    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
