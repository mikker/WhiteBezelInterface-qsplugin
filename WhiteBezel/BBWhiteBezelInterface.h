/* QSController */

@interface BBWhiteBezelInterface : QSResizingInterfaceController {
	NSRect standardRect;
	IBOutlet NSTextField *details;
}

- (NSRect) rectForState:(BOOL)expanded;
@end

@interface NSWindow (QSBCInterfaceController)
- (NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame;
@end
