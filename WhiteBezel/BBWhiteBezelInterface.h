/* QSController */

#import <Cocoa/Cocoa.h>
#import <QSFoundation/QSFoundation.h>
#import <QSCore/QSCore.h>
#import <QSInterface/QSResizingInterfaceController.h>


@interface BBWhiteBezelInterface : QSResizingInterfaceController {
	NSRect standardRect;
	IBOutlet NSTextField *details;
}

- (NSRect) rectForState:(BOOL)expanded;
@end

@interface NSWindow (QSBCInterfaceController)
- (NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame;
@end
