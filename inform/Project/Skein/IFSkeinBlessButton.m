//
//  IFSkeinBlessButton.m
//  Inform
//
//  Created by Toby Nelson in 2015
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "IFSkeinBlessButton.h"
#import "IFImageCache.h"

static NSImage* blessImage;
static NSImage* blessOverImage;
static NSImage* curseImage;
static NSImage* curseOverImage;

@implementation IFSkeinBlessButton {
    BOOL inside;
    NSTrackingArea *focusTrackingArea;
}

@synthesize blessState;

// Class initialisation
+ (void) initialize {
    blessImage      = [IFImageCache loadResourceImage: @"App/Skein/Trans-tick-off.png"];
    curseImage      = [IFImageCache loadResourceImage: @"App/Skein/Trans-cross-off.png"];
    blessOverImage  = [IFImageCache loadResourceImage: @"App/Skein/Trans-tick.png"];
    curseOverImage  = [IFImageCache loadResourceImage: @"App/Skein/Trans-cross.png"];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if(self != nil) {
        self.bordered   = NO;
        self.wantsLayer = YES;
        self.blessState = YES;
        inside = NO;
    }
    return self;
}

-(BOOL) blessState {
    return blessState;
}

-(NSImage*) imageForState {
    int state = (blessState ? 2 : 0) + (inside ? 1 : 0);
    return @[curseImage, curseOverImage, blessImage, blessOverImage][state];
}

-(void) updateImage {
    self.image = [self imageForState];
    [self setNeedsDisplay];
}

-(void) setBlessState:(BOOL)theBlessState {
    blessState = theBlessState;
    [self updateImage];
}

-(void) toggleBlessState {
    self.blessState = !blessState;
}

-(void) cursorUpdate:(NSEvent *)theEvent {
    [[NSCursor pointingHandCursor] set];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    inside = YES;
    [self updateImage];
}

- (void)mouseExited:(NSEvent *)theEvent {
    inside = NO;
    [self updateImage];
}

- (void)updateTrackingAreas
{
    if( focusTrackingArea == nil ) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
        focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
        focusTrackingAreaOptions |= NSTrackingCursorUpdate;
        focusTrackingAreaOptions |= NSTrackingInVisibleRect;

        focusTrackingArea = [[NSTrackingArea alloc] initWithRect: NSZeroRect
                                                         options: focusTrackingAreaOptions
                                                           owner: self
                                                        userInfo: nil];
        [self addTrackingArea:focusTrackingArea];
    }
}

@end
