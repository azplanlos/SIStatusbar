//
//  SIStatusBar.h
//  Photoroute
//
//  Created by Andreas Zöllner on 25.10.14.
//  Copyright (c) 2014 Studio Istanbul Medya Hiz. Tic. Ltd. Sti. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//#define NSLog(args...) SIStatusLog(args);

void SIStatusLog(NSString *format, ...);

@interface SIStatusBar : NSView

@property (strong) NSString* statusText;
@property (assign) double doubleValue;
@property (assign) double maxValue;
@property (assign) BOOL showProgress;

+(SIStatusBar*)firstStatusBar;

@end
