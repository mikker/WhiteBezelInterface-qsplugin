#import "BBWhiteBezelInterface.h"
#import "BBWhiteBezelBackgroundView.h"

@implementation BBWhiteBezelInterface

- (NSColor*)colorWithHexColorString:(NSString*)inColorString
{
  NSColor* result = nil;
  unsigned colorCode = 0;
  unsigned char redByte, greenByte, blueByte;

  if (nil != inColorString)
  {
    NSScanner* scanner = [NSScanner scannerWithString:inColorString];
    (void) [scanner scanHexInt:&colorCode]; // ignore error
  }
  redByte = (unsigned char)(colorCode >> 16);
  greenByte = (unsigned char)(colorCode >> 8);
  blueByte = (unsigned char)(colorCode); // masks off high bits

  result = [NSColor
            colorWithCalibratedRed:(CGFloat)redByte / 0xff
            green:(CGFloat)greenByte / 0xff
            blue:(CGFloat)blueByte / 0xff
            alpha:1.0];
  return result;
}

- (id)init {
	return [self initWithWindowNibName:@"BBWhiteBezelInterface"];
}

- (void)windowDidLoad {
	standardRect = centerRectInRect([[self window] frame], [[NSScreen mainScreen] frame]);

  NSString *fontName = @"HelveticaNeue";
  NSString *fontNameBold = @"HelveticaNeue-Bold";
  NSColor *whiteColor = [self colorWithHexColorString:@"FFFFFF"];
  NSColor *blackColor = [self colorWithHexColorString:@"000000"];
  NSColor *blackTransparentColor = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.6];
//  NSColor *purpleColor = [self colorWithHexColorString:@"B42C86"];
  NSColor *highlighColor = [self colorWithHexColorString:@"DDDDDD"];

	[super windowDidLoad];
	QSWindow *window = (QSWindow *)[self window];
	[window setLevel:NSPopUpMenuWindowLevel];
	[window setBackgroundColor:[NSColor clearColor]];
	
	// Set the window to be visible on all spaces
    [[self window] setCollectionBehavior:NSWindowCollectionBehaviorTransient];

	[window setHideOffset:NSMakePoint(0,0)];
	[window setShowOffset:NSMakePoint(0,0)];

  BBWhiteBezelBackgroundView *bezelBackgroundView = (BBWhiteBezelBackgroundView *)[[self window] contentView];
  [bezelBackgroundView setRadius:8.0];
  [bezelBackgroundView setColor:whiteColor];
  [bezelBackgroundView setBorderColor:[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.2]];

	[[self window] setFrame:standardRect display:YES];

  [self.window setHasShadow:NO];

  [commandView setTextColor:blackColor];
  [details setTextColor:blackTransparentColor];
  [details setFont:[NSFont fontWithName:fontName size:11]];

	[[self window] setMovableByWindowBackground:NO];
	[(QSWindow *)[self window] setFastShow:YES];

	NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
	for(QSSearchObjectView *theControl in theControls) {
		QSObjectCell *theCell = [theControl cell];
//		[theControl setPreferredEdge:NSMinYEdge];
		[theControl setResultsPadding:6];
		[theControl setPreferredEdge:NSMinYEdge];
		[(QSWindow *)[(theControl)->resultController window] setHideOffset:NSMakePoint(0, NSMinY([iSelector frame]))];
		[(QSWindow *)[(theControl)->resultController window] setShowOffset:NSMakePoint(0, NSMinY([dSelector frame]))];

		[theCell setShowDetails:NO];
		[theCell setState:NSOnState];
    [theCell setAlignment:NSCenterTextAlignment];
    [theCell setCellRadiusFactor:35];
    [theCell setBackgroundColor:whiteColor];
//    [theCell setTextColor:purpleColor];
		[theCell bind:@"textColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.QSAppearance1T" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    [theCell setHighlightColor:highlighColor];
    [theCell setIconSize:NSSizeFromCGSize(CGSizeMake(96,96))];
    [theCell setNameFont:[NSFont fontWithName:fontNameBold size:16]];
    [theCell setDetailsFont:[NSFont fontWithName:fontName size:12]];
  }

	[self contractWindow:nil];
}

- (void)dealloc {
  if ([self isWindowLoaded]) {
    NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
    for(NSControl * theControl in theControls) {
      NSCell *theCell = [theControl cell];
      [theCell unbind:@"textColor"];
    }
  }
  [super dealloc];
}

- (NSSize) maxIconSize {
	return QSSize128;
}

- (void)showMainWindow:(id)sender {
	[[self window] setFrame:[self rectForState:[self expanded]]  display:YES];
	if ([[self window] isVisible]) [[self window] pulse:self];
	[super showMainWindow:sender];
	[[[self window] contentView] setNeedsDisplay:YES];
}

- (void)expandWindow:(id)sender {
	if (![self expanded])
		[[self window] setFrame:[self rectForState:YES] display:YES animate:YES];
	[super expandWindow:sender];
}
- (void)contractWindow:(id)sender {
	if ([self expanded])
		[[self window] setFrame:[self rectForState:NO] display:YES animate:YES];
	[super contractWindow:sender];
}

- (NSRect) rectForState:(BOOL)shouldExpand {
	NSRect newRect = standardRect;
	NSRect screenRect = [[NSScreen mainScreen] frame];
	if (!shouldExpand) {
		newRect.size.width -= NSMaxX([iSelector frame]) -NSMaxX([aSelector frame]);
		newRect = centerRectInRect(newRect, [[NSScreen mainScreen] frame]);
	}
	return NSOffsetRect(centerRectInRect(newRect, screenRect), 0, NSHeight(screenRect) /8);
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
	return NSOffsetRect(NSInsetRect(rect, 8, 0), 0, -21);
}

- (void)updateDetailsString {
	NSControl *firstResponder = (NSControl *)[[self window] firstResponder];
	if ([firstResponder respondsToSelector:@selector(objectValue)]) {
		id object = [firstResponder objectValue];
		NSString *string = [object details];
		if ([object respondsToSelector:@selector(details)] && string) {
			[details setStringValue:string];
			return;
		}
	}
	[details setStringValue:@""];
}

- (void)firstResponderChanged:(NSResponder *)aResponder {
	[super firstResponderChanged:aResponder];
	[self updateDetailsString];
}

- (void)searchObjectChanged:(NSNotification*)notif {
	[super searchObjectChanged:notif];
	[self updateDetailsString];
}

-(NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame
{
	return 0.01;
}

@end
