//
//  QSSBBezelBackgroundView.m
//  BBWhiteBezel
//
//  Created by Mikkel Malmberg on 4/2/13.
//  Copyright (c) 2013 BRNBW. All rights reserved.
//

#import "BBWhiteBezelBackgroundView.h"

#define kBORDER_WIDTH 10

@implementation BBWhiteBezelBackgroundView

- (void)dealloc
{
  [color release];
  [super dealloc];
}

- (BOOL)isOpaque { return NO;  }

- (void)drawRect:(NSRect)rect
{
  rect = [self bounds];

  NSBezierPath *roundRect;
  CGFloat minRadius;
  
  // Border
  [borderColor set];
	roundRect = [NSBezierPath bezierPath];
	minRadius = MIN(NSWidth(rect), NSHeight(rect)) / 2;
	if (radius < 0)
		[roundRect appendBezierPathWithRoundedRectangle:rect withRadius:minRadius];
	else
		[roundRect appendBezierPathWithRoundedRectangle:rect withRadius:MIN(minRadius, radius * 2)];
  [roundRect addClip];
  NSRectFill(rect);

  // Background
  rect = NSRectFromCGRect(CGRectMake(rect.origin.x + kBORDER_WIDTH, rect.origin.y + kBORDER_WIDTH, rect.size.width - 2*kBORDER_WIDTH, rect.size.height - 2*kBORDER_WIDTH));
  roundRect = [NSBezierPath bezierPath];
	minRadius = MIN(NSWidth(rect), NSHeight(rect)) / 2;
	if (radius < 0)
		[roundRect appendBezierPathWithRoundedRectangle:rect withRadius:minRadius];
	else
		[roundRect appendBezierPathWithRoundedRectangle:rect withRadius:MIN(minRadius, radius)];
  [roundRect addClip];
  [color set];
  NSRectFill(rect);

  [super drawRect:rect];
}

- (NSColor *)borderColor { return borderColor; }
- (void)setBorderColor:(NSColor *)newColor
{
  [borderColor release];
  borderColor = [[newColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace] retain];
  [self setNeedsDisplay:YES];
}

- (NSColor *)color { return color;  }
- (void)setColor:(NSColor *)newColor {
	[color release];
	color = [[newColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace] retain];
	[self setNeedsDisplay:YES];
}

- (CGFloat) radius { return radius;  }
- (void)setRadius:(CGFloat)newRadius {
	radius = newRadius;
	[self setNeedsDisplay:YES];
}

@end
