#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>
#import <Cordova/CDVPlugin.h>
#import "Calls.h"

@implementation Calls

- (void) startListener:(CDVInvokedUrlCommand*)command {
    self.callbackId = command.callbackId;
    
    CXCallObserver *callObserver = [[CXCallObserver alloc] init];
    [callObserver setDelegate:self queue:nil];
    self.callObserver = callObserver;
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call listener started"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void) stopListener:(CDVInvokedUrlCommand*)command {
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call listener stopped"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:NO]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    NSDictionary* payload = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithBool:call.outgoing], @"outgoing",
                             [NSNumber numberWithBool:call.hasConnected], @"hasConnected",
                             [NSNumber numberWithBool:call.hasEnded], @"hasEnded",
                             [NSNumber numberWithBool:call.onHold], @"onHold",
                             nil
                             ];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:payload];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    if(self.callbackId != nil){
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }
}

@end
