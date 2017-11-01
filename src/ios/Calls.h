#import <Cordova/CDVPlugin.h>
#import <CallKit/CXCallObserver.h>

@interface Calls : CDVPlugin <CXCallObserverDelegate>
@property (nonatomic, strong) CXCallObserver *callObserver;


- (void) startListener:(CDVInvokedUrlCommand*)command;
- (void) stopListener:(CDVInvokedUrlCommand*)command;

@property (nonatomic, copy) NSString* callbackId;

@end

