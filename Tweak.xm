#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import <SpringBoard/SBUIController.h>

#pragma mark SBUIController Methods
@interface SBUIController (ActivatorDemo)
- (void)showAlertWithEvent:(LAEvent *)aEvent;
- (void)dismissSampleAlert;
@end

%hook SBUIController

static UIAlertView *aAlertView;

%new(v@:@)
- (void)showAlertWithEvent:(LAEvent *)aEvent {
	if (![aAlertView isVisible]) {
		aAlertView = [[UIAlertView alloc] initWithTitle:@"Activator Demo" message:[aEvent name] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[aAlertView show];
		[aEvent setHandled:YES];
	}
}

%new(v@:)
- (void)dismissSampleAlert {
	if (aAlertView) {
		if ([aAlertView isVisible]) {
			[aAlertView dismissWithClickedButtonIndex:[aAlertView cancelButtonIndex] animated:YES];
			[aAlertView release];
			aAlertView = nil;
		}
	}
}

-(void)dealloc {
	[aAlertView release];
	%orig;
}
%end
#pragma mark -

#pragma mark ActivatorDemoListener Methods
@interface ActivatorDemoListener : NSObject <LAListener> {
}
@end

@implementation ActivatorDemoListener

+ (void)load {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[[LAActivator sharedInstance] registerListener:[self new] forName:@"com.tylercalderone.activatordemo"];

	[pool release];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[(SBUIController *)[%c(SBUIController) sharedInstance] showAlertWithEvent:event];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	[(SBUIController *)[%c(SBUIController) sharedInstance] dismissSampleAlert];
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
	[(SBUIController *)[%c(SBUIController) sharedInstance] dismissSampleAlert];
}

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	[(SBUIController *)[%c(SBUIController) sharedInstance] dismissSampleAlert];
}

- (void)dealloc {
	[super dealloc];
}

@end
#pragma mark -