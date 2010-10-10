/*
//
//  @version Subversion: $Id: iTM2ButtonKit.m 799 2009-10-13 16:46:39Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Dec 13 2002.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import "iTM2FileManagerKit.h"
#import "iTM2ButtonKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2ViewKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2BundleKit.h"
#import "iTM2ImageKit.h"
#import <objc/objc-class.h>

#define BUNDLE [iTM2ButtonRWStatus classBundle4iTM3]

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSButton(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSButton(iTM2ButtonKit_PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  fixImageNamed:inBundle:
- (void)fixImageNamed:(NSString *)name inBundle:(NSBundle *)B;
/*"If the image is found, .
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * path = [B pathForImageResource:name];
    NSImage * I = nil;
    if (!path.length || !(I = [[[NSImage alloc] initWithContentsOfFile:path] autorelease]))
        NSLog(@"%@ %#x error: Could not find a %@ image, PLEASE report BUG iTM202103",
            NSStringFromClass(self.class), NSStringFromSelector(_cmd), self, name);
    else
    {
//NSLog(@"INFO: image path: %@", path);
        self.image = I;
        [self setImagePosition:NSImageOnly];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  fixImageNamed:
- (void)fixImageNamed:(NSString *)name;
/*"This one calls the above method with the receiver's bundle as second argument.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self fixImageNamed:(NSString *) name inBundle:self.classBundle4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  fixImage
- (void)fixImage;
/*"This one calls the above method with the receiver's bundle as second argument.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self fixImageNamed:NSStringFromClass(self.class)];
    return;
}
@end

NSString * const iTM2UDMixedButtonDelayKey = @"iTM2UDMixedButtonDelay";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonMixed
/*"Mixed buttons are used in two ways.
- 1: they act like internet explorer, netscape's history buttons (a short click
displayed the previous visited page, a long one displays a menu with all previously visited pages).
Such button #{isMixedEnabled}.
- 2: if the button has a menu, it displays the menu like any pop up button. The difference is that submenus are allowed...
if no menu is associate with that button, it behaves quite like any standard button. This case does not have any interest.
"*/
@implementation iTM2ButtonMixed
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:0.25], iTM2UDMixedButtonDelayKey,
                nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)aRect;
/*"One button, one target. No border."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self = [super initWithFrame:aRect];
    self.awakeFromNib;
    [self setMixedEnabled:NO];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.cell setHighlightsBy:NSContentsCellMask];
//    self.isBordered = NO;
    [self setCenteredArrow:NO];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= timer
- (NSTimer *)timer;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Timer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setTimer:
- (void)setTimer:(NSTimer *)aTimer;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![aTimer isEqual:_Timer])
    {
        [_Timer invalidate];
        [_Timer autorelease];
        _Timer = [aTimer retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isCenteredArrow
- (BOOL)isCenteredArrow;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _CenteredArrow;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCenteredArrow:
- (void)setCenteredArrow:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _CenteredArrow = aFlag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isMixedEnabled
- (BOOL)isMixedEnabled;
/*"The receiver is enabled either in a normal fashion, id est when its target authorizes it, or in a menu driven way.
If the menu has items to display, the receiver is definitely enabled.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _MixedEnabled;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMixedEnabled:
- (void)setMixedEnabled:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _MixedEnabled = aFlag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mixedAction
- (SEL)mixedAction;
/*"#{-action} corresponds to the button's normal mode whereas #{-mixedAction} corresponds to the button's pull down mode. This message is sent when the timer has fired. It is used for example for templates buttons: the help menu stores an invocation and the %mixedAction invokes it once the menu is totally dismissed to avoid weird window positions. The %mixedAction and the %action do not participate to any validating procedure, but subclasses will certainly use them."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _MixedAction;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMixedAction:
- (void)setMixedAction:(SEL)anAction;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _MixedAction = anAction;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mouseDown:
- (void)mouseDown:(NSEvent *)theEvent;
/*"If the receiver has no menu, it forwards the message to super, otherwise it creates a timer to see if the mouse is down a long time to display a submenu. If the receiver #{isMixedEnabled}, it has a mixed behaviour acting as a standard button when short clicking and as a pull down when long clicking.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([theEvent clickCount] == 1)
    {
        self.willPopUp;
        if (self.isEnabled)
            if ([self.menu numberOfItems] > 0)
            {
                [self highlight:YES];
                self.state = NSOnState;
                self.display;
                NSTimeInterval timeInterval = self.isMixedEnabled ? [SUD floatForKey:@"iTM2DoubleClickDelay"]:0;
#if 1
				NSDate * date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
				if (![NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:date inMode:NSDefaultRunLoopMode dequeue:NO])
				{
					[self popUpContextMenuWithEvent:theEvent];
					[self highlight:NO];
					self.state = NSOffState;
				#if 0
					// crash here, don't know why
					[self.target performSelector:self.mixedAction withObject:self afterDelay:0];
				#else
					[self sendAction:self.mixedAction to:self.target];
				#endif
					[self.window update];
					
				}
#else
                [self setTimer:[NSTimer scheduledTimerWithTimeInterval:timeInterval
                                    target: self selector: @selector(timerHasFired:) userInfo: theEvent repeats: NO]];
#endif
            }
            else if (!self.isMixedEnabled)
            {
                [super mouseDown:theEvent];
            }
			else
			{
				LOG4iTM3(@"***  WEIRD: no menu in iTM2ButtonMixed: %@, %@", self, self.menu);
			}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= timerHasFired:
- (void)timerHasFired:(NSTimer *)aTimer;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self popUpContextMenuWithEvent:[aTimer userInfo]];
    [self setTimer:nil];
    [self highlight:NO];
    self.state = NSOffState;
#if 0
    // crash here, don't know why
    [self.target performSelector:self.mixedAction withObject:self afterDelay:0];
#else
    [self sendAction:self.mixedAction to:self.target];
#endif
    [self.window update];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= popUpContextMenuWithEvent:
- (void)popUpContextMenuWithEvent:(NSEvent *)theEvent;
/*"Use #{-popUpContextMenu:withEvent:forView:} to display the menu."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [NSMenu popUpContextMenu:self.menu
            withEvent: [NSEvent mouseEventWithType:[theEvent type]
                                location: NSMakePoint([theEvent locationInWindow].x-10, [theEvent locationInWindow].y)
                                modifierFlags: [theEvent modifierFlags]
                                timestamp: [theEvent timestamp]
                                windowNumber: [theEvent windowNumber]
                                context: [theEvent context]
                                eventNumber: [theEvent eventNumber]
                                clickCount: [theEvent clickCount]
                                pressure: [theEvent pressure]]
                        forView: self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mouseUp:
- (void)mouseUp:(NSEvent *)theEvent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setTimer:nil];
    if (self.isMixedEnabled)
        [super mouseDown:theEvent];
    [super mouseUp:theEvent];
    [self highlight:NO];
    self.state = NSOffState;
    self.display;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect
- (void)drawRect:(NSRect)aRect;
/*"Adding a small rectangle drawn when the receiver is ON to indicate that there is a menu to pull down."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super drawRect:aRect];
    if (([self.menu numberOfItems] > 0) && ((self.action == NULL) || ([self.cell state]==NSOnState)))
    {
        NSBezierPath * path = [NSBezierPath bezierPath];
        if (self.isCenteredArrow)
        {
            [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect))];
            [path relativeMoveToPoint:NSMakePoint(-4.5,-2.5)];
            [path relativeLineToPoint:NSMakePoint(+4.5,+7.5)];
            [path relativeLineToPoint:NSMakePoint(+4.5,-7.5)];
        }
        else
        {
            [path moveToPoint:NSMakePoint(25,26)];
            [path relativeLineToPoint:NSMakePoint(+3,+5.1)];
            [path relativeLineToPoint:NSMakePoint(+3,-5.1)];
        }
        [path closePath];
        [NSColor setIgnoresAlpha:NO];
        [[[NSColor blackColor] colorWithAlphaComponent:0.66] set];
        [path fill];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performKeyEquivalent:
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list: problem when more than one key is pressed.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([theEvent type] == NSKeyDown)
    {
        if (self.window.firstResponder == self)
        {
            NSString * CIM = [theEvent charactersIgnoringModifiers];
            if (CIM.length && [CIM characterAtIndex:0] == ' ')
            {
                [self mouseDown:[NSEvent mouseEventWithType:NSLeftMouseDown
                                    location: [self convertPoint:self.frameCenter toView:nil]
                                    modifierFlags: [theEvent modifierFlags]
                                    timestamp: [theEvent timestamp]
                                    windowNumber: [theEvent windowNumber]
                                    context: [theEvent context]
                                    eventNumber: [theEvent eventNumber]
                                    clickCount: 1
                                    pressure: 1.0]];
                return YES;
            }
        }
    }
    return [super performKeyEquivalent:theEvent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValidInOtherWindow
- (BOOL)isValidInOtherWindow;
/*"Description Forthcoming. Usefull???
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setEnabled:NO];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValidInMainOrKeyWindow
- (BOOL)isValidInMainOrKeyWindow;
/*"Description Forthcoming. Usefull???
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setEnabled:YES];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the target of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the target responds to #{validateFooAction:} this message is sent to validate the receiver. If the target does not respond to #{validateFooAction}, then it is asked for #{validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = [super isValid4iTM3];
//LOG4iTM3(@"I AM %@VALID", (result? @"": @"NOT "));
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL)willPopUp;
/*"The receiver is always enabled. The validator is the target of its action. The receiver is continuous according to the answer of the validator through the #{isValid4iTM3} message. The menu of the receiver is also updated."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    const char * selectorName = sel_getName(self.action);
    size_t length = strlen(selectorName);
    if (!length)
        return NO;
    char * name = NSAllocateCollectable(strlen(selectorName)+9,0);
    if (name)
	{
		strcpy(name, selectorName);
		strcpy(name+strlen(selectorName)-1, "WillPopUp:");
//LOG4iTM3(@"selector name: <%s>", name);
		SEL willPopUpAction = sel_getUid(name);
		if (willPopUpAction) {
			id T = self.target?:[NSApp targetForAction:self.action];
			if (T && class_getInstanceMethod( T->isa, willPopUpAction)) {
                objc_msgSend(T, willPopUpAction, self) != nil;
			}
		}
	}
	[self setEnabled:(self.isValid4iTM3 || !self.isMixedEnabled || ([self.menu numberOfItems] > 0))];
	[self.menu update];
//END4iTM3;
    return YES;
}
@synthesize _Timer;
@synthesize _MixedAction;
@synthesize _CenteredArrow;
@synthesize _MixedEnabled;
@end

@implementation iTM2ButtonForward
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)irrelevant;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithFrame:NSMakeRect(0,0,32,31)])
    {
        [self.cell setBordered: YES];
        [self.cell setBezelStyle:NSCircularBezelStyle];
        [self.cell setControlSize:NSSmallControlSize];
        [self.cell setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        [self setCenteredArrow:NO];
        [self setMixedEnabled:YES];
        self.fixImage;
        self.title = @"";
        self.action = @selector(displayForwardPage:);
        self.target = nil;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
    self.fixImage;
    return;
}
@end

@implementation iTM2ButtonBack
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)irrelevant;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithFrame:NSMakeRect(0,0,32,31)])
    {
        [self.cell setBordered: YES];
        [self.cell setBezelStyle:NSCircularBezelStyle];
        [self.cell setControlSize:NSSmallControlSize];
        [self.cell setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        [self setCenteredArrow:NO];
        [self setMixedEnabled:YES];
        self.fixImage;
        self.title = @"";
        self.action = @selector(displayBackPage:);
        self.target = nil;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
    self.fixImage;
    return;
}
@end

NSString * const iTM2ToggleEditableNotification = @"iTM2ToggleEditableNotification";
NSString * const iTM2ToggleEditableKey = @"iTM2ToggleEditableKey";

@interface iTM2ButtonRWStatus(PRIVATE)
- (BOOL)validateAction:(id)sender;
@end;

#import "iTM2WindowKit.h"

@implementation iTM2ButtonRWStatus
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
    self.action = @selector(action:);
    self.target = self;
	[INC addObserver:self selector:@selector(documentEditedStatusNotified:) name:iTM2DocumentEditedStatusNotification object:self.window];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  documentEditedStatusNotified:
- (void)documentEditedStatusNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setEnabled:[self validateAction:self]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  action:
- (IBAction)action:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// finding the actual state of the art
    NSURL * url = [[self.window.windowController document] fileURL];
    BOOL old = [[DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:url error:NULL] fileIsImmutable];
    NSDictionary * D = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:!old] forKey:NSFileImmutable];
    if ([DFM setAttributes:D ofItemAtPath:url.path error:NULL]) {
        [sender setEnabled:[self validateAction:sender]];
    } else {
        LOG4iTM3(@"Could not change file attributes:\n%@\nat path:\n%@", D, url.path);
        iTM2Beep();
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAction:
- (BOOL)validateAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSDocument * doc = [self.window.windowController document];
    NSURL * url = doc.fileURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
    NSImage * I = [NSImage imageReadOnlyPencil4iTM3];
    BOOL editable = NO;
    BOOL enabled = NO;
    if ([[DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:url error:NULL] fileIsImmutable]) {
        I = [NSImage imageLock4iTM3];
        enabled = YES;
    } else if ([DFM isWritableFileAtPath:url.path]) {
        I = [NSImage imageUnlock4iTM3];
        editable = YES;
        enabled = YES;
    }
    self.image = I;
    [INC postNotificationName:iTM2ToggleEditableNotification
        object: self userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:editable]
            forKey: iTM2ToggleEditableKey]];
	[self setNeedsDisplay:YES];
//END4iTM3;
    return (![doc isDocumentEdited] && enabled);
}
@end

@interface iTM2CoffeeBreak: NSButton
{
@private
    NSView * _VCB;
}
+ (void)timedCoffeeBreak:(NSTimer *)timer;
+ (void)coffeeBreakNotified:(NSNotification *)notification;
- (void)coffeeBreakNotified:(NSNotification *)notification;
@property (retain) NSView * _VCB;
@end

NSString * const _iTM2CoffeeBreakNotification = @"_iTM2CoffeeBreakNotification";

@implementation iTM2CoffeeBreak
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
    self.title = @"Coffee";
    [self setImage:[NSImage imageJava4iTM3]];
    [self.cell setBordered: NO];
    [self setImagePosition:NSImageOnly];
    [self setButtonType:NSMomentaryChangeButton];
    self.target = self;
    self.action = @selector(blackboxAction:);
    srand(floor([NSDate timeIntervalSinceReferenceDate]));
    [INC removeObserver:self
            name: _iTM2CoffeeBreakNotification
                object: nil];
    [INC addObserver:self
            selector: @selector(coffeeBreakNotified:)
                name: _iTM2CoffeeBreakNotification
                    object: nil];
    [_VCB autorelease];
    _VCB = [[NSView alloc] initWithFrame:self.frame];
    [_VCB setAutoresizingMask:self.autoresizingMask];
    [self.class timedCoffeeBreak:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  blackboxAction:
- (IBAction)blackboxAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[[[NSAppleScript alloc] initWithSource:
        @"tell application \"Finder\" to say \"Please, notice that I tek mac doesn't know how to make tea either.\""]
            autorelease] executeAndReturnError: nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timedCoffeeBreak:
+ (void)timedCoffeeBreak:(NSTimer *)timer;
/*"When a revert to saved is performed (for example) the text storage changed and the line numbers must change according.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//START4iTM3;
    static BOOL firstTime = YES;
    if (firstTime)
    {
        firstTime = NO;
        [INC
            addObserver: self
                selector: @selector(coffeeBreakNotified:)
                    name: _iTM2CoffeeBreakNotification
                        object: nil];
    }
    [INC postNotificationName:_iTM2CoffeeBreakNotification object:timer];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  coffeeBreakNotified:
+ (void)coffeeBreakNotified:(NSNotification *)notification;
/*"When a revert to saved is performed (for example) the text storage changed and the line numbers must change according.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//START4iTM3;
	static char randstate[2048];
	if (initstate(time(NULL), randstate, 256)){
		if ([[(NSTimer *)[notification object] userInfo] boolValue])
			[NSTimer scheduledTimerWithTimeInterval:30*(3 + 2* random()/RAND_MAX)  target:self.class
										   selector: @selector(timedCoffeeBreak:) userInfo: [NSNumber numberWithBool:NO] repeats:NO];
		else
			[NSTimer scheduledTimerWithTimeInterval:60*(20 + 5* random()/RAND_MAX)  target:self.class
										   selector: @selector(timedCoffeeBreak:) userInfo: [NSNumber numberWithBool:YES] repeats:NO];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  coffeeBreakNotified:
- (void)coffeeBreakNotified:(NSNotification *)notification;
/*"When a revert to saved is performed (for example) the text storage changed and the line numbers must change according.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * superView;
    if ([[(NSTimer *)[notification object] userInfo] boolValue])
    {
        if (superView = [_VCB superview])
        {
//NSLog(@"showing coffee break");
            [self setFrame:_VCB.frame];
            [superView replaceSubview:_VCB with:self];
            [superView setNeedsDisplay:YES];
        }
    }
    else
    {
        if (superView = self.superview)
        {
//NSLog(@"hiding coffee break");
            [_VCB setFrame:self.frame];
            [superView replaceSubview:self with:_VCB];
            [superView setNeedsDisplay:YES];
        }
    }
    return;
}
@synthesize _VCB;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonKit

@interface iTM2ButtonNavigation(PRIVATE)
- (void)displayIcon;
- (id)initWithFrame:(NSRect)irrelevant;
- (void)drawRect:(NSRect)aRect;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonNavigation
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
@implementation iTM2ButtonNavigation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)irrelevant;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithFrame:NSMakeRect(0,0,32,31)])
    {
        [self.cell setBordered: YES];
        [self.cell setBezelStyle:NSCircularBezelStyle];
        [self.cell setControlSize:NSSmallControlSize];
        [self.cell setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        self.title = @"";
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super drawRect:aRect];
    self.displayIcon;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonNavigation

@implementation iTM2ButtonFirst
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSRect aRect = self.bounds;
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    [path relativeMoveToPoint:NSMakePoint(-3.62,+0)];
    [path relativeLineToPoint:NSMakePoint(+6.93,-5)];
    [path relativeLineToPoint:NSMakePoint(0,+10)];
    [path closePath];
    [path relativeMoveToPoint:NSMakePoint(0,5)];
    [path relativeLineToPoint:NSMakePoint(-2,0)];
    [path relativeLineToPoint:NSMakePoint(0,-10)];
    [path relativeLineToPoint:NSMakePoint(2,0)];
    [path closePath];
    {
        NSAffineTransform * transform = [[NSAffineTransform transform] retain];
        [transform translateXBy:3 yBy:3];
        [transform scaleBy:0.8];
        [path transformUsingAffineTransform:transform];
        [transform release];
    }
    [path fill];
    [path release];
    return;
}
@end

@implementation iTM2ButtonLast
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSRect aRect = self.bounds;
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    [path relativeMoveToPoint:NSMakePoint(+3.62,+0)];
    [path relativeLineToPoint:NSMakePoint(-6.93,+5)];
    [path relativeLineToPoint:NSMakePoint(0,-10)];
    [path closePath];
    [path relativeMoveToPoint:NSMakePoint(0,5)];
    [path relativeLineToPoint:NSMakePoint(2,0)];
    [path relativeLineToPoint:NSMakePoint(0,-10)];
    [path relativeLineToPoint:NSMakePoint(-2,0)];
    [path closePath];
    {
        NSAffineTransform * transform = [[NSAffineTransform transform] retain];
        [transform translateXBy:3 yBy:3];
        [transform scaleBy:0.8];
        [path transformUsingAffineTransform:transform];
        [transform release];
    }
    [path fill];
    [path release];
    return;
}
@end

@implementation iTM2ButtonPrevious
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSRect aRect = self.bounds;
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    [path relativeMoveToPoint:NSMakePoint(-4.62,+0)];
    [path relativeLineToPoint:NSMakePoint(+6.93,-5)];
    [path relativeLineToPoint:NSMakePoint(0,+10)];
    [path closePath];
    {
        NSAffineTransform * transform = [[NSAffineTransform transform] retain];
        [transform translateXBy:3 yBy:3];
        [transform scaleBy:0.8];
        [path transformUsingAffineTransform:transform];
        [transform release];
    }
    [path fill];
    [path release];
    return;
}
@end

@implementation iTM2ButtonNext
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSRect aRect = self.bounds;
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    [path relativeMoveToPoint:NSMakePoint(+4.62,+0)];
    [path relativeLineToPoint:NSMakePoint(-6.93,+5)];
    [path relativeLineToPoint:NSMakePoint(0,-10)];
    [path closePath];
    {
        NSAffineTransform * transform = [[NSAffineTransform transform] retain];
        [transform translateXBy:3 yBy:3];
        [transform scaleBy:0.8];
        [path transformUsingAffineTransform:transform];
        [transform release];
    }
    [path fill];
    [path release];
    return;
}
@end

@implementation iTM2ButtonPreviousPrevious
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSRect aRect = self.bounds;
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    [path relativeMoveToPoint:NSMakePoint(-1,+0)];
    [path relativeLineToPoint:NSMakePoint(+6.93,-5)];
    [path relativeLineToPoint:NSMakePoint(0,+10)];
    [path closePath];
    [path relativeMoveToPoint:NSMakePoint(-6.93,+0)];
    [path relativeLineToPoint:NSMakePoint(+6.93,-5)];
    [path relativeLineToPoint:NSMakePoint(0,+10)];
    [path closePath];
    {
        NSAffineTransform * transform = [[NSAffineTransform transform] retain];
        [transform translateXBy:3 yBy:3];
        [transform scaleBy:0.8];
        [path transformUsingAffineTransform:transform];
        [transform release];
    }
    [path fill];
    [path release];
    return;
}
@end

@implementation iTM2ButtonNextNext
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSRect aRect = self.bounds;
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    [path relativeMoveToPoint:NSMakePoint(+1,+0)];
    [path relativeLineToPoint:NSMakePoint(-6.93,+5)];
    [path relativeLineToPoint:NSMakePoint(0,-10)];
    [path closePath];
    [path relativeMoveToPoint:NSMakePoint(+6.93,+0)];
    [path relativeLineToPoint:NSMakePoint(-6.93,+5)];
    [path relativeLineToPoint:NSMakePoint(0,-10)];
    [path closePath];
    {
        NSAffineTransform * transform = [[NSAffineTransform transform] retain];
        [transform translateXBy:3 yBy:3];
        [transform scaleBy:0.8];
        [path transformUsingAffineTransform:transform];
        [transform release];
    }
    [path fill];
    [path release];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSButton(iTM2Foundation)

@implementation NSButton(iTM2ButtonKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonFirst
+ (NSButton *)buttonFirst;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonFirst alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonLast
+ (NSButton *)buttonLast;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonLast alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonPrevious
+ (NSButton *)buttonPrevious;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonPrevious alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonNext
+ (NSButton *)buttonNext;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonNext alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonPreviousPrevious
+ (NSButton *)buttonPreviousPrevious;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonPreviousPrevious alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonNextNext
+ (NSButton *)buttonNextNext;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonNextNext alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonForward
+ (NSButton *)buttonForward;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonForward alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonBack
+ (NSButton *)buttonBack;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2ButtonBack alloc] initWithFrame:NSZeroRect] autorelease];
}
@end

@interface NSButton(PRIVATE)
- (void)displayIcon;
@end

@implementation iTM2ButtonPlus
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super drawRect:aRect];
    self.displayIcon;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    static NSBezierPath * path;
    if (!path)
    {
        path = [[NSBezierPath bezierPath] retain];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineCapStyle:NSRoundLineCapStyle];
        NSRect aRect = self.bounds;
        float W = NSWidth(aRect)*0.03;
    //    [path setLineWidth:40*W];
        float H = NSWidth(aRect)*0.15;
        [path moveToPoint:NSMakePoint(NSMidX(aRect) - H - W, NSMidY(aRect) - W - 1)];
        [path relativeLineToPoint:NSMakePoint(0, 2*W)];
        [path relativeLineToPoint:NSMakePoint(H, 0)];
        [path relativeLineToPoint:NSMakePoint(0, H)];
        [path relativeLineToPoint:NSMakePoint(2*W, 0)];
        [path relativeLineToPoint:NSMakePoint(0, -H)];
        [path relativeLineToPoint:NSMakePoint(H, 0)];
        [path relativeLineToPoint:NSMakePoint(0, -2*W)];
        [path relativeLineToPoint:NSMakePoint(-H, 0)];
        [path relativeLineToPoint:NSMakePoint(0, -H)];
        [path relativeLineToPoint:NSMakePoint(-2*W, 0)];
        [path relativeLineToPoint:NSMakePoint(0, H)];
//        [path relativeMoveToPoint:NSMakePoint(-H, 0)];
        [path closePath];
    }
    [path fill];
    return;
}
@end

@implementation iTM2ButtonMinus
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super drawRect:aRect];
    self.displayIcon;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float alpha = self.isEnabled? 0.66:0.4;
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    static NSBezierPath * path;
    if (!path)
    {
        path = [[NSBezierPath bezierPath] retain];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineCapStyle:NSRoundLineCapStyle];
        NSRect aRect = self.bounds;
        float W = NSWidth(aRect)*0.03;
    //    [path setLineWidth:40*W];
        float H = NSWidth(aRect)*0.15;
        [path moveToPoint:NSMakePoint(NSMidX(aRect) - H - W, NSMidY(aRect) - W - 1)];
        [path relativeLineToPoint:NSMakePoint(0, 2*W)];
        [path relativeLineToPoint:NSMakePoint(H, 0)];
//        [path relativeLineToPoint:NSMakePoint(0, H)];
        [path relativeLineToPoint:NSMakePoint(2*W, 0)];
//        [path relativeLineToPoint:NSMakePoint(0, -H)];
        [path relativeLineToPoint:NSMakePoint(H, 0)];
        [path relativeLineToPoint:NSMakePoint(0, -2*W)];
        [path relativeLineToPoint:NSMakePoint(-H, 0)];
//        [path relativeLineToPoint:NSMakePoint(0, -H)];
        [path relativeLineToPoint:NSMakePoint(-2*W, 0)];
//        [path relativeLineToPoint:NSMakePoint(0, H)];
//        [path relativeMoveToPoint:NSMakePoint(-H, 0)];
        [path closePath];
    }
    [path fill];
    return;
}
@end

@implementation iTM2MixedButton
+ (void)initialize;
{
	[iTM2MixedButton setCellClass:[iTM2MixedButtonCell class]];
	return;
}
- (id)popUp;
{
	return popUp;
}
- (void)setPopUp:(id)argument;
{
	[popUp autorelease];
	popUp = [argument retain];
	return;
}
- (SEL)doubleAction;
{
	return [self.cell doubleAction];
}
- (void)setDoubleAction:(SEL)aSelector;
{
	[self.cell setDoubleAction: aSelector];
	return;
}
- (void)awakeFromNib;
{
    [super awakeFromNib];
	self.setup;
}
- (void)setup;
{
	if (![self.cell isKindOfClass:[iTM2MixedButtonCell class]])
	{
		iTM2MixedButtonCell * newCell = [[[iTM2MixedButtonCell alloc] init] autorelease];
		NSButtonCell * oldCell = self.cell;
		#define XFER(GETTER, SETTER) [newCell SETTER:[oldCell GETTER]]
		XFER(controlView, setControlView);
		XFER(type, setType);
		XFER(state, setState);
		XFER(target, setTarget);
		XFER(action, setAction);
		XFER(tag, setTag);
		XFER(title, setTitle);
		XFER(isEnabled, setEnabled);
		XFER(isContinuous, setContinuous);
		XFER(isEditable, setEditable);
		XFER(isSelectable, setSelectable);
		XFER(isBordered, setBordered);
		XFER(isBezeled, setBezeled);
		XFER(isScrollable, setScrollable);
	//- (BOOL)isOpaque;
		XFER(isHighlighted, setHighlighted);
		XFER(alignment, setAlignment);
		XFER(wraps, setWraps);
		XFER(font, setFont);
		XFER(image, setImage);
		XFER(controlTint, setControlTint);
		XFER(controlSize, setControlSize);
		XFER(representedObject, setRepresentedObject);
	//- (NSInteger)cellAttribute:(NSCellAttribute)aParameter;
	//- (void)setCellAttribute:(NSCellAttribute)aParameter to:(NSInteger)value;
		XFER(sendsActionOnEndEditing, setSendsActionOnEndEditing);
		XFER(baseWritingDirection, setBaseWritingDirection);
		XFER(lineBreakMode, setLineBreakMode);
		XFER(allowsUndo, setAllowsUndo);
		XFER(allowsMixedState, setAllowsMixedState);
	//- (void)setFloatingPointFormat:(BOOL)autoRange left:(NSUInteger)leftDigits right:(NSUInteger)rightDigits;
		XFER(title, setTitle);
		XFER(alternateTitle, setAlternateTitle);
		XFER(alternateImage, setAlternateImage);
		XFER(imagePosition, setImagePosition);
		XFER(highlightsBy, setHighlightsBy);
		XFER(showsStateBy, setShowsStateBy);
		XFER(isTransparent, setTransparent);
		XFER(keyEquivalent, setKeyEquivalent);
		XFER(keyEquivalentModifierMask, setKeyEquivalentModifierMask);
		XFER(keyEquivalentFont, setKeyEquivalentFont);
	//- (void)setButtonType:(NSButtonType)aType;
	//- (BOOL)isOpaque;
	//- (void)setFont:(NSFont *)fontObj;
		XFER(gradientType, setGradientType);
		XFER(imageDimsWhenDisabled, setImageDimsWhenDisabled);
		XFER(showsBorderOnlyWhileMouseInside, setShowsBorderOnlyWhileMouseInside);
		XFER(backgroundColor, setBackgroundColor);
		XFER(attributedTitle, setAttributedTitle);
		XFER(attributedAlternateTitle, setAttributedAlternateTitle);
		XFER(bezelStyle, setBezelStyle);
		XFER(sound, setSound);
		[self setCell:newCell];
	}
//- (void)setPeriodicDelay:(float)delay interval:(float)interval;
//- (void)getPeriodicDelay:(float *)delay interval:(float *)interval;
	if (popUp) {
		[self.cell setPopUpCell:popUp.cell];
    }
	self.popUp = nil;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolbarSizeMode:
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (sizeMode == NSToolbarSizeModeSmall)
	{
		[self.cell setControlSize:NSSmallControlSize];
		[self setFrame:NSMakeRect(0, 0, 24, 24)];
	}
	else
	{
		[self.cell setControlSize:NSRegularControlSize];
		[self setFrame:NSMakeRect(0, 0, 32, 32)];
	}
//END4iTM3;
    return;
}
@end

//NSPopUpButtonCell
@implementation iTM2MixedButtonCell
+ (void)initialize;
{
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithFloat:0.75], @"iTM2MixedButtonDelay",
			nil]];
	return;
}
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
	[super encodeWithCoder:aCoder];
	if (self.popUpCell) {
		[aCoder encodeObject:self.popUpCell forKey:@"popUpCell"];
	}
	[aCoder encodeObject:NSStringFromSelector(self.doubleAction) forKey:@"doubleActionName"];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	if (self = [super initWithCoder:(NSCoder *)aDecoder]) {
		NS_DURING
		self.popUpCell = [aDecoder decodeObjectForKey:@"popUpCell"];// *** Exception catched: *** -[NSKeyedUnarchiver decodeObjectForKey:]: missing class name for class
		NS_HANDLER
		NS_ENDHANDLER
		self.doubleAction = NSSelectorFromString([aDecoder decodeObjectForKey:@"doubleActionName"]);
	}
	return self;
}
- (void)setPopUpCell:(NSPopUpButtonCell *)argument;
{
	[iVarPopUpCell autorelease];
	iVarPopUpCell = [argument retain];
	[iVarPopUpCell setBordered: NO];
	[iVarPopUpCell setBezeled: NO];
	switch (self.controlSize) {
		case NSRegularControlSize: [iVarPopUpCell setControlSize:NSSmallControlSize]; break;
		case NSSmallControlSize:
		case NSMiniControlSize: [iVarPopUpCell setControlSize:NSMiniControlSize]; break;
	}
	return;
}
@synthesize popUpCell = iVarPopUpCell;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL)willPopUp;
/*"The receiver is always enabled. The validator is the target of its action. The receiver is continuous according to the answer of the validator through the #{isValid4iTM3} message. The menu of the receiver is also updated."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    const char * selectorName = sel_getName(self.action);
    size_t length = strlen(selectorName);
    if (!length) {
		selectorName = sel_getName(self.popUpCell.action);
		length = strlen(selectorName);
		if (!length) {
			return NO;
        }
	}
    char * name = NSAllocateCollectable(strlen(selectorName)+9,0);
    if (name) {
		strcpy(name, selectorName);
		strcpy(name+strlen(selectorName)-1, "WillPopUp:");
//LOG4iTM3(@"selector name: <%s>", name);
		SEL willPopUpAction = sel_getUid(name);
		if (willPopUpAction) {
			id T = self.target?:[NSApp targetForAction:self.action];
			if (T && class_getInstanceMethod(T->isa, willPopUpAction)) {
                objc_msgSend(T, willPopUpAction, self) != nil;
            }
		}
	}
	[self.menu update];
//END4iTM3;
    return YES;
}
@synthesize doubleAction = iVarDoubleAction;
- (void)setControlSize:(NSControlSize)size;
{
	[super setControlSize:(NSControlSize)size];
	switch(size)
	{
		case NSRegularControlSize: [self.popUpCell setControlSize:NSSmallControlSize]; break;
		case NSSmallControlSize:
		case NSMiniControlSize: [self.popUpCell setControlSize:NSMiniControlSize]; break;
	}
	return;
}
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
{
	NSImage * I = self.image;
	NSSize maxSize = NSZeroSize;
	for (NSImageRep * IR in I.representations) {
		NSSize size = [IR size];
		if (size.width > maxSize.width) {
			maxSize = size;
        }
	}
	if (self.controlSize == NSSmallControlSize) {
		maxSize.width *= 0.75;
		maxSize.height *= 0.75;
		NSImage * newI = [[I copy] autorelease];
		[newI setSize:maxSize];
		self.image = newI;
		[super drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView];
		self.image = I;
	} else {
		NSImage * newI = [[I copy] autorelease];
		[newI setSize:maxSize];
		self.image = newI;
		[super drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView];
		self.image = I;
	}
	if ([self.popUpCell pullsDown]) {
		cellFrame.origin.y = NSMinY(cellFrame) + 0.825 * cellFrame.size.height - 0.5 * self.popUpCell.cellSize.height;
		cellFrame.size.height = self.popUpCell.cellSize.height;
	}
	cellFrame.origin.x = NSMaxX(cellFrame) - 20;
	cellFrame.size.width = 20;
	[self.popUpCell drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = self.isDoubleValid4iTM3;
//END4iTM3;
	return [super isValid4iTM3] || result;// both validators are called!
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDoubleValid4iTM3
- (BOOL)isDoubleValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(NSStringFromSelector(self.action));
	BOOL result = YES;
	SEL action = self.doubleAction;
	static const char * iTM2ANSICapitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (action)
    {
        id validatorTarget = [NSApp targetForAction:action to:self.target from:self.controlView]?:
			[NSApp targetForAction:action to:self.controlView.window.firstResponder from:self.controlView];
		if (validatorTarget)
		{
			const char * selectorName = sel_getName(action);
			char * name = NSAllocateCollectable(strlen(selectorName)+9,0);
			if (name)
			{
				strcpy(name, "validate");
				strcpy(name+8, selectorName);
				if ((name[8]>='a') && (name[8]<='z'))
					name[8] = iTM2ANSICapitals[name[8]-'a'];
			//LOG4iTM3(@"selector name: <%s>", name);
				SEL validatorAction = sel_getUid(name);
				if (validatorAction && class_getInstanceMethod(validatorTarget->isa, validatorAction)) {
					//END4iTM3;
                    id sender = ([(id)self.controlView action] == self.action?(id)self.controlView:self);
                    result = (BOOL)((NSInteger)(objc_msgSend(validatorTarget, validatorAction, sender)) & 0xFF);//BOOL
                    [self setEnabled:result];
				}
			}
		}
    }
//END4iTM3;
	return result;
}
- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag;
{
	if (!self.popUpCell) {
		return [super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:flag];
    }
	[self highlight:YES withFrame:cellFrame inView:controlView];
	if (self.isDoubleValid4iTM3) {
		NSDate * topDate = [NSDate dateWithTimeIntervalSinceNow:[SUD floatForKey:@"iTM2MixedButtonDelay"]];
		NSDate * clickDate = [NSDate dateWithTimeIntervalSinceNow:[SUD floatForKey:@"com.apple.mouse.doubleClickThreshold"]];
nextMouseUp:
		if ([NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES]) {
			// catching a second click
			if ([NSApp targetForAction:self.doubleAction to:self.target from:self]) {
				while([[NSDate date] compare:(id)clickDate] == NSOrderedAscending) {
					if ([NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES]) {
						[NSApp nextEventMatchingMask:NSLeftMouseDownMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES];
						[NSApp sendAction:self.doubleAction to:self.target from:controlView];
						[self highlight:NO withFrame:cellFrame inView:controlView];
						return YES;
					}
				}
			}
			[NSApp sendAction:self.action to:self.target from:controlView];
			[self highlight:NO withFrame:cellFrame inView:controlView];
			return YES;
		} else if ([[NSDate date] compare:(id)topDate] == NSOrderedAscending) {
			goto nextMouseUp;
		}
	}
	if (!self.willPopUp) {
		return NO;
    }
	NSControlSize oldPopUpSize = [self.popUpCell controlSize];
	[self.popUpCell setControlSize:self.controlSize];
	BOOL result = NO;
	if (self.popUpCell.pullsDown) {
		NSRect popUpFrame = cellFrame;
		popUpFrame.origin.y = NSMaxY(cellFrame) - self.popUpCell.cellSize.height;
		popUpFrame.size.height = self.popUpCell.cellSize.height;
		result = [self.popUpCell trackMouse:theEvent inRect:popUpFrame ofView:controlView untilMouseUp:flag];
	} else {
		result = [self.popUpCell trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:flag];
	}
	[self.popUpCell setControlSize:oldPopUpSize];
	[self highlight:NO withFrame:cellFrame inView:controlView];
	return result;
}
@end
