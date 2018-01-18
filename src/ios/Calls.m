#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>
#import <Cordova/CDVPlugin.h>
#import "Calls.h"

@implementation Calls

- (void) startListener:(CDVInvokedUrlCommand*)command {
    // SAVE THE CALLBACKID
    self.callbackId = command.callbackId;
    
    // START OBSERVER
    CXCallObserver *callObserver = [[CXCallObserver alloc] init];
    [callObserver setDelegate:self queue:nil];
    self.callObserver = callObserver;
    
    // RETURN A MESSAGES TELLING THE OBSERVER HAS STARTED
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call listener started"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void) stopListener:(CDVInvokedUrlCommand*)command {
    
    // CLEAR THE OBSERVER
    self.callObserver = nil;
    
    // CLOSE THE LISTNER CALLBACK
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call listener stopped"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:NO]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    
    // CLOSE THIS CALLBACK
    CDVPluginResult* pluginResult1 = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Ok"];
    [pluginResult1 setKeepCallback:[NSNumber numberWithBool:NO]];
    [self.commandDelegate sendPluginResult:pluginResult1 callbackId:command.callbackId];
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    // IF THE CALL STATE CHANGED CREATE THE DICTIONARY TO RETURN
    NSDictionary* payload = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithBool:call.outgoing], @"outgoing",
                             [NSNumber numberWithBool:call.hasConnected], @"hasConnected",
                             [NSNumber numberWithBool:call.hasEnded], @"hasEnded",
                             [NSNumber numberWithBool:call.onHold], @"onHold",
                             nil
                             ];
    
    // RETURN THE DICTIONARY
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:payload];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    if(self.callbackId != nil){
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }
}

@end

