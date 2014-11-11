//
//  SIStatusBar.m
//  Photoroute
//
//  Created by Andreas Zöllner on 25.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import "SIStatusBar.h"

@implementation SIStatusBar
@synthesize statusText, doubleValue, maxValue, showProgress;

static SIStatusBar* _firstStatusBar = nil;

void SIStatusLog(NSString *format, ...)
{
    va_list argumentList;
    va_start(argumentList, format);
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format
                                                              arguments:argumentList];
    NSLogv(message, argumentList); // Originally NSLog is a wrapper around NSLogv.
    va_end(argumentList);
    if (_firstStatusBar) _firstStatusBar.statusText = message;
}

+(SIStatusBar*)firstStatusBar {
    return _firstStatusBar;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.showProgress = NO;
        self.maxValue = 1;
        self.doubleValue = 0;
        //NSLog(@"statusbar init");
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(statusText)) options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(doubleValue)) options:NSKeyValueObservingOptionNew context:nil];
        @synchronized ([SIStatusBar class]) {
            if (!_firstStatusBar) {
                _firstStatusBar = self;
                //NSLog(@"saving first status bar");
            }
        }
        
    }
    
    return self;
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(statusText))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(doubleValue))];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //NSLog(@"change");
    if (self.doubleValue >= self.maxValue && self.doubleValue < 0) self.showProgress = NO;
    [self setNeedsDisplay:YES];
    
}

-(NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*) key {
    return [NSSet setWithObjects:NSStringFromSelector(@selector(statusText)), NSStringFromSelector(@selector(doubleValue)), NSStringFromSelector(@selector(maxValue)), NSStringFromSelector(@selector(showProgress)), nil];
}

- (void)drawRect:(NSRect)dirtyRect
{
    //// General Declarations
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGAffineTransform affineTransform = CGContextGetCTM(context);
    
    //// Color Declarations
    NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.109 green: 0.109 blue: 0.109 alpha: 1];
    NSColor* color = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    NSColor* color2 = [NSColor colorWithCalibratedRed: 0.333 green: 0.333 blue: 0.333 alpha: 1];
    NSColor* color4 = [NSColor colorWithCalibratedRed: 0 green: 0.143 blue: 0.429 alpha: 1];
    NSColor* color5 = [NSColor colorWithCalibratedRed: 0.167 green: 0.167 blue: 0.167 alpha: 1];
    NSColor* color6 = [NSColor colorWithCalibratedRed: 0 green: 0.067 blue: 0.2 alpha: 1];
    NSColor* color7 = [NSColor colorWithCalibratedRed: 0.343 green: 0.781 blue: 1 alpha: 1];
    NSColor* gradientColor2 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 0];
    
    //// Gradient Declarations
    NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            gradientColor, 0.0,
                            [NSColor colorWithCalibratedRed: 0.554 green: 0.554 blue: 0.554 alpha: 0.5], 0.79,
                            gradientColor2, 1.0, nil];
    NSGradient* gradient2 = [[NSGradient alloc] initWithColorsAndLocations:
                             color5, 0.0, 
                             color4, 0.18, 
                             color7, 0.64, 
                             color4, 0.81, 
                             color6, 1.0, nil];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [NSColor blackColor]];
    [shadow setShadowOffset: NSMakeSize(0.1, -3.1)];
    [shadow setShadowBlurRadius: 5];
    NSShadow* shadow2 = [[NSShadow alloc] init];
    [shadow2 setShadowColor: color];
    [shadow2 setShadowOffset: NSMakeSize(0.1, 1.1)];
    [shadow2 setShadowBlurRadius: 2];
    
    //// Image Declarations
    NSImage* linen = [NSImage imageNamed: @"black_linen_v2"];
    NSColor* linenPattern = [NSColor colorWithPatternImage: linen];
    
    //// Frames
    NSRect frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 30);
    
    //// Subframes
    NSRect frame2 = NSMakeRect(NSMinX(frame) + floor((NSWidth(frame)) * 0.54291 + 0.5), NSMinY(frame) + 2, NSWidth(frame) - floor((NSWidth(frame)) * 0.54291 + 0.5), 20);
    
    
    //// Abstracted Attributes
    NSString* textContent = self.statusText;
    
    
    //// Rectangle Drawing
    NSRect rectangleRect = NSMakeRect(NSMinX(frame) + 0.5, NSMinY(frame) + 0.5, NSWidth(frame) + 1, NSHeight(frame) - 10);
    NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: rectangleRect];
    [NSGraphicsContext saveGraphicsState];
    CGContextSetPatternPhase(context, NSMakeSize(floor(NSMinX(rectangleRect) + 0.5) + affineTransform.tx, ceil(NSMinY(rectangleRect) - 0.5) + affineTransform.ty));
    [linenPattern setFill];
    [rectanglePath fill];
    [NSGraphicsContext restoreGraphicsState];
    [[NSColor blackColor] setStroke];
    [rectanglePath setLineWidth: 1];
    [rectanglePath stroke];
    
    
    //// Rectangle 2 Drawing
    NSBezierPath* rectangle2Path = [NSBezierPath bezierPathWithRect: NSMakeRect(NSMinX(frame) - 0.5, NSMinY(frame) + 20.5, NSWidth(frame), 5)];
    [NSGraphicsContext saveGraphicsState];
    [shadow set];
    CGContextBeginTransparencyLayer(context, NULL);
    [gradient drawInBezierPath: rectangle2Path angle: 90];
    CGContextEndTransparencyLayer(context);
    [NSGraphicsContext restoreGraphicsState];
    
    
    
    //// Text Drawing
    NSRect textRect = NSMakeRect(NSMinX(frame) + 6, NSMinY(frame) + 4, floor((NSWidth(frame) - 6) * 0.61818 + 0.5), 14);
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSLeftTextAlignment];
    
    NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSFont fontWithName: @"Helvetica" size: 12], NSFontAttributeName,
                                        color, NSForegroundColorAttributeName,
                                        textStyle, NSParagraphStyleAttributeName, nil];
    
    [textContent drawInRect: NSOffsetRect(textRect, 0, 1) withAttributes: textFontAttributes];
    
    if (self.showProgress) {
        //// Rounded Rectangle Drawing
        NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame2) + 3.5, NSMinY(frame2) + 2.5, NSWidth(frame2) - 8, 12) xRadius: 4 yRadius: 4];
        [NSGraphicsContext saveGraphicsState];
        [shadow2 set];
        [color2 setFill];
        [roundedRectanglePath fill];
        
        ////// Rounded Rectangle Inner Shadow
        NSRect roundedRectangleBorderRect = NSInsetRect([roundedRectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
        roundedRectangleBorderRect = NSOffsetRect(roundedRectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
        roundedRectangleBorderRect = NSInsetRect(NSUnionRect(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
        
        NSBezierPath* roundedRectangleNegativePath = [NSBezierPath bezierPathWithRect: roundedRectangleBorderRect];
        [roundedRectangleNegativePath appendBezierPath: roundedRectanglePath];
        [roundedRectangleNegativePath setWindingRule: NSEvenOddWindingRule];
        
        [NSGraphicsContext saveGraphicsState];
        {
            NSShadow* shadowWithOffset = [shadow copy];
            CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(roundedRectangleBorderRect.size.width);
            CGFloat yOffset = shadowWithOffset.shadowOffset.height;
            shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
            [shadowWithOffset set];
            [[NSColor grayColor] setFill];
            [roundedRectanglePath addClip];
            NSAffineTransform* transform = [NSAffineTransform transform];
            [transform translateXBy: -round(roundedRectangleBorderRect.size.width) yBy: 0];
            [[transform transformBezierPath: roundedRectangleNegativePath] fill];
        }
        [NSGraphicsContext restoreGraphicsState];
        
        [NSGraphicsContext restoreGraphicsState];
        
        [color2 setStroke];
        [roundedRectanglePath setLineWidth: 1];
        [roundedRectanglePath stroke];
        
        if (self.doubleValue > 0) {
            //// Rounded Rectangle 2 Drawing
            NSBezierPath* roundedRectangle2Path = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame2) + 5, NSMinY(frame2) + 3, ((self.doubleValue / self.maxValue)*(NSWidth(frame2)-10)), 10) xRadius: 4 yRadius: 4];
            [gradient2 drawInBezierPath: roundedRectangle2Path angle: -90];
            
            ////// Rounded Rectangle 2 Inner Shadow
            NSRect roundedRectangle2BorderRect = NSInsetRect([roundedRectangle2Path bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
            roundedRectangle2BorderRect = NSOffsetRect(roundedRectangle2BorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
            roundedRectangle2BorderRect = NSInsetRect(NSUnionRect(roundedRectangle2BorderRect, [roundedRectangle2Path bounds]), -1, -1);
            
            NSBezierPath* roundedRectangle2NegativePath = [NSBezierPath bezierPathWithRect: roundedRectangle2BorderRect];
            [roundedRectangle2NegativePath appendBezierPath: roundedRectangle2Path];
            [roundedRectangle2NegativePath setWindingRule: NSEvenOddWindingRule];
            
            [NSGraphicsContext saveGraphicsState];
            {
                NSShadow* shadowWithOffset = [shadow copy];
                CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(roundedRectangle2BorderRect.size.width);
                CGFloat yOffset = shadowWithOffset.shadowOffset.height;
                shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
                [shadowWithOffset set];
                [[NSColor grayColor] setFill];
                [roundedRectangle2Path addClip];
                NSAffineTransform* transform = [NSAffineTransform transform];
                [transform translateXBy: -round(roundedRectangle2BorderRect.size.width) yBy: 0];
                [[transform transformBezierPath: roundedRectangle2NegativePath] fill];
            }
        }
    }
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
