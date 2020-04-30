#import "ApptentiveFlutterPlugin.h"
@import Apptentive;

@implementation ApptentiveFlutterPlugin

-(FlutterViewController*)flutterViewController {
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    return (FlutterViewController*)appDelegate.window.rootViewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"apptentive_flutter"
            binaryMessenger:[registrar messenger]];
  ApptentiveFlutterPlugin* instance = [[ApptentiveFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if([@"engageEvent" isEqualToString:call.method]) {
        [self engageEvent:call result:result];
    } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)engageEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    if( [call.arguments isKindOfClass:[NSString class]] ) {
        NSString* stringToPass = call.arguments;
        [Apptentive.shared engage:stringToPass fromViewController:[self flutterViewController]];
    } else {
        result([FlutterError errorWithCode:@"EventErrror" message:@"Invalid paramter" details:nil]);
    }
}

@end
