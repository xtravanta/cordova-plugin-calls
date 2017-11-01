#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>
#import <Cordova/CDVPlugin.h>
#import "Calls.h"

@implementation Calls

- (void) callListener:(CDVInvokedUrlCommand*)command {
    self.callbackId = command.callbackId;
    
    CXCallObserver *callObserver = [[CXCallObserver alloc] init];
    [callObserver setDelegate:self queue:nil];
    self.callObserver = callObserver;
    
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    
    NSString* payload = nil;
    if (call.hasConnected) {
        NSLog(@"********** voice call connected **********/n");
        payload = @"connected";
    } else if(call.hasEnded) {
        NSLog(@"********** voice call disconnected **********/n");
        payload = @"ended";
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:payload];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    if(self.callbackId != nil){
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }
}

@end
