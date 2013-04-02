//
//  QSSBBezelBackgroundView.h
//  SquareBezel
//
//  Created by Mikkel Malmberg on 4/2/13.
//  Copyright (c) 2013 BRNBW. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <QSEffects/QSShading.h>

@interface QSSBBezelBackgroundView : NSView
{
  NSColor *color;
  NSColor *borderColor;
	CGFloat radius;
}
- (NSColor *)borderColor;
- (void)setBorderColor:(NSColor *)newColor;
- (NSColor *)color;
- (void)setColor:(NSColor *)newColor;
- (CGFloat) radius;
- (void)setRadius:(CGFloat)newRadius;
@end
