/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2ButtonKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ImageKit.h>
#import <objc/objc-class.h>

#define BUNDLE [iTM2ButtonRWStatus classBundle]

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * path = [B pathForImageResource:name];
    NSImage * I = nil;
    if(![path length] || !(I = [[[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path] autorelease]))
        NSLog(@"%@ %#x error: Could not find a %@ image, PLEASE report BUG iTM202103",
            NSStringFromClass([self class]), NSStringFromSelector(_cmd), self, name);
    else
    {
//NSLog(@"INFO: image path: %@", path);
        [self setImage:I];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self fixImageNamed:(NSString *) name inBundle:[self classBundle]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  fixImage
- (void)fixImage;
/*"This one calls the above method with the receiver's bundle as second argument.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self fixImageNamed:NSStringFromClass([self class])];
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
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:0.25], iTM2UDMixedButtonDelayKey,
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)aRect;
/*"One button, one target. No border."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    self = [super initWithFrame:aRect];
    [self awakeFromNib];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self cell] setHighlightsBy:NSContentsCellMask];
//    [self setBordered:NO];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Timer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setTimer:
- (void)setTimer:(NSTimer *)aTimer;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![aTimer isEqual:_Timer])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _CenteredArrow;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCenteredArrow:
- (void)setCenteredArrow:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _MixedEnabled;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMixedEnabled:
- (void)setMixedEnabled:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _MixedEnabled = aFlag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mixedAction
- (SEL)mixedAction;
/*"#{-action} corresponds to the button's normal mode whereas #{-mixedAction} corresponds to the button's pull down mode. This message is sent when the timer has fired. It is used for example for templates buttons: the help menu stores an invocation and the %mixedAction invokes it once the menu is totally dismissed to avoid weird window positions. The %mixedAction and the %action do not participate to any validating procedure, but subclasses will certainly use them."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _MixedAction;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMixedAction:
- (void)setMixedAction:(SEL)anAction;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([theEvent clickCount] == 1)
    {
        [self willPopUp];
        if([self isEnabled])
            if([[self menu] numberOfItems] > 0)
            {
                [self highlight:YES];
                [[self cell] setState:NSOnState];
                [self display];
                NSTimeInterval timeInterval = [self isMixedEnabled] ? [SUD floatForKey:@"iTM2DoubleClickDelay"]:0;
#if 1
				NSDate * date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
				if(![NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:date inMode:NSDefaultRunLoopMode dequeue:NO])
				{
					[self popUpContextMenuWithEvent:theEvent];
					[self highlight:NO];
					[[self cell] setState:NSOffState];
				#if 0
					// crash here, don't know why
					[[self target] performSelector:[self mixedAction] withObject:self afterDelay:0];
				#else
					[self sendAction:[self mixedAction] to:[self target]];
				#endif
					[[self window] update];
					
				}
#else
                [self setTimer:[NSTimer scheduledTimerWithTimeInterval:timeInterval
                                    target: self selector: @selector(timerHasFired:) userInfo: theEvent repeats: NO]];
#endif
            }
            else if(![self isMixedEnabled])
            {
                [super mouseDown:theEvent];
            }
			else
			{
				iTM2_LOG(@"***  WEIRD: no menu in iTM2ButtonMixed: %@, %@", self, [self menu]);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self popUpContextMenuWithEvent:[aTimer userInfo]];
    [self setTimer:nil];
    [self highlight:NO];
    [[self cell] setState:NSOffState];
#if 0
    // crash here, don't know why
    [[self target] performSelector:[self mixedAction] withObject:self afterDelay:0];
#else
    [self sendAction:[self mixedAction] to:[self target]];
#endif
    [[self window] update];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= popUpContextMenuWithEvent:
- (void)popUpContextMenuWithEvent:(NSEvent *)theEvent;
/*"Use #{-popUpContextMenu:withEvent:forView:} to display the menu."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSMenu popUpContextMenu:[self menu]
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setTimer:nil];
    if([self isMixedEnabled])
        [super mouseDown:theEvent];
    [super mouseUp:theEvent];
    [self highlight:NO];
    [[self cell] setState:NSOffState];
    [self display];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL)willPopUp;
/*"The receiver is always enabled. The validator is the target of its action. The receiver is continuous according to the answer of the validator through the #{isValid} message. The menu of the receiver is also updated."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    const char * selectorName = sel_getName([self action]);
    int length = strlen(selectorName);
    if(!length)
        return NO;
    char * name = malloc(strlen(selectorName)+9);
    if(name)
	{
		strcpy(name, selectorName);
		strcpy(name+strlen(selectorName)-1, "WillPopUp:");
//iTM2_LOG(@"selector name: <%s>", name);
		SEL willPopUpAction = sel_getUid(name);
		free(name);
		name = nil;
		if(willPopUpAction)
		{
			id T = [self target]?:[NSApp targetForAction:[self action]];
			if(T)
			{
				Method willPopUpMethod = ((id)T == (id)(T->isa)?
					class_getClassMethod((id)(T->isa), willPopUpAction):
						class_getInstanceMethod((id)(T->isa), willPopUpAction));
				if(willPopUpMethod)
					objc_msgSend(T, willPopUpAction, self) != nil;
			}
		}
	}
	[self setEnabled:([self isValid] || ![self isMixedEnabled] || ([[self menu] numberOfItems] > 0))];
	[[self menu] update];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc:
- (void)dealloc;
/*"Cleans the timer."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setTimer:nil];
    [super dealloc];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect
- (void)drawRect:(NSRect)aRect;
/*"Adding a small rectangle drawn when the receiver is ON to indicate that there is a menu to pull down."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super drawRect:aRect];
    if(([[self menu] numberOfItems] > 0) && (([self action] == NULL) || ([[self cell] state]==NSOnState)))
    {
        NSBezierPath * path = [NSBezierPath bezierPath];
        if([self isCenteredArrow])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([theEvent type] == NSKeyDown)
    {
        if([[self window] firstResponder] == self)
        {
            NSString * CIM = [theEvent charactersIgnoringModifiers];
            if([CIM length] && [CIM characterAtIndex:0] == ' ')
            {
                [self mouseDown:[NSEvent mouseEventWithType:NSLeftMouseDown
                                    location: [self convertPoint:[self frameCenter] toView:nil]
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setEnabled:YES];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the target of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the target responds to #{validateFooAction:} this message is sent to validate the receiver. If the target does not respond to #{validateFooAction}, then it is asked for #{validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super isValid];
//iTM2_LOG(@"I AM %@VALID", (result? @"": @"NOT "));
	return result;
}
@end

@implementation iTM2ButtonForward
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)irrelevant;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:NSMakeRect(0,0,32,31)])
    {
        [self setBordered:YES];
        [[self cell] setBezelStyle:NSCircularBezelStyle];
        [[self cell] setControlSize:NSSmallControlSize];
        [[self cell] setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        [self setCenteredArrow:NO];
        [self setMixedEnabled:YES];
        [self fixImage];
        [self setTitle:@""];
        [self setAction:@selector(displayForwardPage:)];
        [self setTarget:nil];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super awakeFromNib];
    [self fixImage];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:NSMakeRect(0,0,32,31)])
    {
        [self setBordered:YES];
        [[self cell] setBezelStyle:NSCircularBezelStyle];
        [[self cell] setControlSize:NSSmallControlSize];
        [[self cell] setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        [self setCenteredArrow:NO];
        [self setMixedEnabled:YES];
        [self fixImage];
        [self setTitle:@""];
        [self setAction:@selector(displayBackPage:)];
        [self setTarget:nil];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super awakeFromNib];
    [self fixImage];
    return;
}
@end

NSString * const iTM2ToggleEditableNotification = @"iTM2ToggleEditableNotification";
NSString * const iTM2ToggleEditableKey = @"iTM2ToggleEditableKey";

@interface iTM2ButtonRWStatus(PRIVATE)
- (BOOL)validateAction:(id)sender;
@end;

#import <iTM2Foundation/iTM2WindowKit.h>

@implementation iTM2ButtonRWStatus
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setAction:@selector(action:)];
    [self setTarget:self];
	[INC addObserver:self selector:@selector(documentEditedStatusNotified:) name:iTM2DocumentEditedStatusNotification object:[self window]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[INC removeObserver:self];
	[INC removeObserver:nil name:nil object:self];
	[super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  documentEditedStatusNotified:
- (void)documentEditedStatusNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
// finding the actual state of the art
    NSString * path = [[[[[self window] windowController] document] fileName] stringByResolvingSymlinksAndFinderAliasesInPath];
    BOOL old = [[DFM fileAttributesAtPath:path traverseLink:YES] fileIsImmutable];
    NSDictionary * D = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:!old] forKey:NSFileImmutable];
    if([DFM changeFileAttributes:D atPath:path])
        [sender setEnabled:[self validateAction:sender]];
    else
    {
        NSLog(@"Could not change file attributes:\n%@\nat path:\n%@", D, path);
        iTM2Beep();
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAction:
- (BOOL)validateAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSDocument * doc = [[[self window] windowController] document];
    NSString * path = [[doc fileName] stringByResolvingSymlinksAndFinderAliasesInPath];
    NSImage * I = [NSImage iTM2_imageReadOnlyPencil];
    BOOL editable = NO;
    BOOL enabled = NO;
    if([[DFM fileAttributesAtPath:path traverseLink:YES] fileIsImmutable])
    {
        I = [NSImage iTM2_imageLock];
        enabled = YES;
    }
    else if([DFM isWritableFileAtPath:path])
    {
        I = [NSImage iTM2_imageUnlock];
        editable = YES;
        enabled = YES;
    }
    [self setImage:I];
    [INC postNotificationName:iTM2ToggleEditableNotification
        object: self userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:editable]
            forKey: iTM2ToggleEditableKey]];
	[self setNeedsDisplay:YES];
//iTM2_END;
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
@end

NSString * const _iTM2CoffeeBreakNotification = @"_iTM2CoffeeBreakNotification";

@implementation iTM2CoffeeBreak
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:self];
    [_VCB autorelease];
    _VCB = nil;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setTitle:@"Coffee"];
    [self setImage:[NSImage iTM2_imageJava]];
    [self setBordered:NO];
    [self setImagePosition:NSImageOnly];
    [self setButtonType:NSMomentaryChangeButton];
    [self setTarget:self];
    [self setAction:@selector(blackboxAction:)];
    srand(floor([NSDate timeIntervalSinceReferenceDate]));
    [INC removeObserver:self
            name: _iTM2CoffeeBreakNotification
                object: nil];
    [INC addObserver:self
            selector: @selector(coffeeBreakNotified:)
                name: _iTM2CoffeeBreakNotification
                    object: nil];
    [_VCB autorelease];
    _VCB = [[NSView allocWithZone:[self zone]] initWithFrame:[self frame]];
    [_VCB setAutoresizingMask:[self autoresizingMask]];
    [[self class] timedCoffeeBreak:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  blackboxAction:
- (IBAction)blackboxAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[[NSAppleScript allocWithZone:[self zone]] initWithSource:
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_START;
    static BOOL firstTime = YES;
    if(firstTime)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_START;
    if([[(NSTimer *)[notification object] userInfo] boolValue])
        [NSTimer scheduledTimerWithTimeInterval:30*(3 + 2* rand()/RAND_MAX)  target:[self class]
            selector: @selector(timedCoffeeBreak:) userInfo: [NSNumber numberWithBool:NO] repeats:NO];
    else
        [NSTimer scheduledTimerWithTimeInterval:60*(20 + 5* rand()/RAND_MAX)  target:[self class]
            selector: @selector(timedCoffeeBreak:) userInfo: [NSNumber numberWithBool:YES] repeats:NO];

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  coffeeBreakNotified:
- (void)coffeeBreakNotified:(NSNotification *)notification;
/*"When a revert to saved is performed (for example) the text storage changed and the line numbers must change according.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSView * superView;
    if([[(NSTimer *)[notification object] userInfo] boolValue])
    {
        if(superView = [_VCB superview])
        {
//NSLog(@"showing coffee break");
            [self setFrame:[_VCB frame]];
            [superView replaceSubview:_VCB with:self];
            [superView setNeedsDisplay:YES];
        }
    }
    else
    {
        if(superView = [self superview])
        {
//NSLog(@"hiding coffee break");
            [_VCB setFrame:[self frame]];
            [superView replaceSubview:self with:_VCB];
            [superView setNeedsDisplay:YES];
        }
    }
    return;
}
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:NSMakeRect(0,0,32,31)])
    {
        [self setBordered:YES];
        [[self cell] setBezelStyle:NSCircularBezelStyle];
        [[self cell] setControlSize:NSSmallControlSize];
        [[self cell] setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        [self setTitle:@""];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super drawRect:aRect];
    [self displayIcon];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSPoint center = NSZeroPoint;
    NSRect aRect = [self bounds];
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    center = [path currentPoint];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSPoint center = NSZeroPoint;
    NSRect aRect = [self bounds];
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    center = [path currentPoint];
    [NSColor setIgnoresAlpha:NO];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSPoint center = NSZeroPoint;
    NSRect aRect = [self bounds];
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    center = [path currentPoint];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSPoint center = NSZeroPoint;
    NSRect aRect = [self bounds];
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    center = [path currentPoint];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSPoint center = NSZeroPoint;
    NSRect aRect = [self bounds];
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    center = [path currentPoint];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    NSBezierPath * path = [[NSBezierPath bezierPath] retain];
    NSPoint center = NSZeroPoint;
    NSRect aRect = [self bounds];
    [path setLineJoinStyle:NSRoundLineJoinStyle];
    [path moveToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect)-1.5)];
    center = [path currentPoint];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonFirst alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonLast
+ (NSButton *)buttonLast;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonLast alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonPrevious
+ (NSButton *)buttonPrevious;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonPrevious alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonNext
+ (NSButton *)buttonNext;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonNext alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonPreviousPrevious
+ (NSButton *)buttonPreviousPrevious;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonPreviousPrevious alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonNextNext
+ (NSButton *)buttonNextNext;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonNextNext alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonForward
+ (NSButton *)buttonForward;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2ButtonForward alloc] initWithFrame:NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonBack
+ (NSButton *)buttonBack;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super drawRect:aRect];
    [self displayIcon];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    static NSBezierPath * path;
    if(!path)
    {
        path = [[NSBezierPath bezierPath] retain];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineCapStyle:NSRoundLineCapStyle];
        NSRect aRect = [self bounds];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super drawRect:aRect];
    [self displayIcon];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIcon
- (void)displayIcon;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    [NSColor setIgnoresAlpha:NO];
    [[[NSColor blackColor] colorWithAlphaComponent:alpha] set];
    static NSBezierPath * path;
    if(!path)
    {
        path = [[NSBezierPath bezierPath] retain];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineCapStyle:NSRoundLineCapStyle];
        NSRect aRect = [self bounds];
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
- (void)dealloc;
{
	[self setPopUp:nil];
	[super dealloc];
	return;
}
- (SEL)doubleAction;
{
	return [[self cell] doubleAction];
}
- (void)setDoubleAction:(SEL)aSelector;
{
	[[self cell] setDoubleAction:aSelector];
	return;
}
- (void)awakeFromNib;
{
	[self setup];
}
- (void)setup;
{
	if(![[self cell] isKindOfClass:[iTM2MixedButtonCell class]])
	{
		iTM2MixedButtonCell * newCell = [[[iTM2MixedButtonCell allocWithZone:[self zone]] init] autorelease];
		NSButtonCell * oldCell = [self cell];
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
	//- (int)cellAttribute:(NSCellAttribute)aParameter;
	//- (void)setCellAttribute:(NSCellAttribute)aParameter to:(int)value;
		XFER(sendsActionOnEndEditing, setSendsActionOnEndEditing);
		XFER(baseWritingDirection, setBaseWritingDirection);
		XFER(lineBreakMode, setLineBreakMode);
		XFER(allowsUndo, setAllowsUndo);
		XFER(allowsMixedState, setAllowsMixedState);
	//- (void)setFloatingPointFormat:(BOOL)autoRange left:(unsigned int)leftDigits right:(unsigned int)rightDigits;
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
	if(popUp)
		[[self cell] setPopUpCell:[popUp cell]];
	[self setPopUp:nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolbarSizeMode:
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(sizeMode == NSToolbarSizeModeSmall)
	{
		[[self cell] setControlSize:NSSmallControlSize];
		[self setFrame:NSMakeRect(0, 0, 24, 24)];
	}
	else
	{
		[[self cell] setControlSize:NSRegularControlSize];
		[self setFrame:NSMakeRect(0, 0, 32, 32)];
	}
//iTM2_END;
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
	if(popUpCell)
	{
		[aCoder encodeObject:popUpCell forKey:@"popUpCell"];
	}
	[aCoder encodeObject:NSStringFromSelector([self doubleAction]) forKey:@"doubleActionName"];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	if(self = [super initWithCoder:(NSCoder *)aDecoder])
	{
		[self setPopUpCell:[aDecoder decodeObjectForKey:@"popUpCell"]];
		[self setDoubleAction:NSSelectorFromString([aDecoder decodeObjectForKey:@"doubleActionName"])];
	}
	return self;
}
- (id)popUpCell;
{
	return popUpCell;
}
- (void)setPopUpCell:(id)argument;
{
	[popUpCell autorelease];
	popUpCell = [argument retain];
	[popUpCell setBordered:NO];
	[popUpCell setBezeled:NO];
	switch([self controlSize])
	{
		case NSRegularControlSize: [popUpCell setControlSize:NSSmallControlSize]; break;
		case NSSmallControlSize:
		case NSMiniControlSize: [popUpCell setControlSize:NSMiniControlSize]; break;
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL)willPopUp;
/*"The receiver is always enabled. The validator is the target of its action. The receiver is continuous according to the answer of the validator through the #{isValid} message. The menu of the receiver is also updated."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    const char * selectorName = sel_getName([self action]);
    int length = strlen(selectorName);
    if(!length)
	{
		selectorName = sel_getName([popUpCell action]);
		length = strlen(selectorName);
		if(!length)
			return NO;
	}
    char * name = malloc(strlen(selectorName)+9);
    if(name)
	{
		strcpy(name, selectorName);
		strcpy(name+strlen(selectorName)-1, "WillPopUp:");
//iTM2_LOG(@"selector name: <%s>", name);
		SEL willPopUpAction = sel_getUid(name);
		free(name);
		name = nil;
		if(willPopUpAction)
		{
			id T = [self target]?:[NSApp targetForAction:[self action]];
			if(T)
			{
				Method willPopUpMethod = ((id)T == (id)(T->isa)?
					class_getClassMethod((id)(T->isa), willPopUpAction):
						class_getInstanceMethod((id)(T->isa), willPopUpAction));
				if(willPopUpMethod)
					objc_msgSend(T, willPopUpAction, self) != nil;
			}
		}
	}
	[[self menu] update];
//iTM2_END;
    return YES;
}
- (SEL)doubleAction;
{
	return doubleAction;
}
- (void)setDoubleAction:(SEL)aSelector;
{
	doubleAction = aSelector;
	return;
}
- (void)setControlSize:(NSControlSize)size;
{
	[super setControlSize:(NSControlSize)size];
	switch(size)
	{
		case NSRegularControlSize: [popUpCell setControlSize:NSSmallControlSize]; break;
		case NSSmallControlSize:
		case NSMiniControlSize: [popUpCell setControlSize:NSMiniControlSize]; break;
	}
	return;
}
- (void)dealloc;
{
	[self setPopUpCell:nil];
	[super dealloc];
	return;
}
- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag;
{
	if(!popUpCell)
		return [super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:flag];
	[self highlight:YES withFrame:cellFrame inView:controlView];
	if([self isDoubleValid])
	{
		NSDate * topDate = [NSDate dateWithTimeIntervalSinceNow:[SUD floatForKey:@"iTM2MixedButtonDelay"]];
		NSDate * clickDate = [NSDate dateWithTimeIntervalSinceNow:[SUD floatForKey:@"com.apple.mouse.doubleClickThreshold"]];
		NSEvent * E;
nextMouseUp:
		if(E = [NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES])
		{
			// catching a second click
			if([NSApp targetForAction:[self doubleAction] to:[self target] from:self])
			{
				while([[NSDate date] compare:(id)clickDate] == NSOrderedAscending)
				{
					if(E = [NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES])
					{
						[NSApp nextEventMatchingMask:NSLeftMouseDownMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES];
						[NSApp sendAction:[self doubleAction] to:[self target] from:controlView];
						[self highlight:NO withFrame:cellFrame inView:controlView];
						return YES;
					}
				}
			}
			[NSApp sendAction:[self action] to:[self target] from:controlView];
			[self highlight:NO withFrame:cellFrame inView:controlView];
			return YES;
		}
		else if([[NSDate date] compare:(id)topDate] == NSOrderedAscending)
		{
			goto nextMouseUp;
		}
	}
	if(![self willPopUp])
		return NO;
	NSControlSize oldPopUpSize = [popUpCell controlSize];
	[popUpCell setControlSize:[self controlSize]];
	BOOL result = NO;
	if([popUpCell pullsDown])
	{
		NSRect popUpFrame = cellFrame;
		popUpFrame.origin.y = NSMaxY(cellFrame) - [popUpCell cellSize].height;
		popUpFrame.size.height = [popUpCell cellSize].height;
		result = [popUpCell trackMouse:theEvent inRect:popUpFrame ofView:controlView untilMouseUp:flag];
	}
	else
	{
		result = [popUpCell trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:flag];
	}
	[popUpCell setControlSize:oldPopUpSize];
	[self highlight:NO withFrame:cellFrame inView:controlView];
	return result;
}
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
{
	NSImage * I = [self image];
	NSEnumerator * E = [[I representations] objectEnumerator];
	NSImageRep * IR;
	NSSize maxSize = NSZeroSize;
	while(IR = [E nextObject])
	{
		NSSize size = [IR size];
		if(size.width > maxSize.width)
			maxSize = size;
	}
	if([self controlSize] == NSSmallControlSize)
	{
		maxSize.width *= 0.75;
		maxSize.height *= 0.75;
		NSImage * newI = [[I copy] autorelease];
		[newI setSize:maxSize];
		[self setImage:newI];
		[super drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView];
		[self setImage:I];
	}
	else
	{
		NSImage * newI = [[I copy] autorelease];
		[newI setSize:maxSize];
		[self setImage:newI];
		[super drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView];
		[self setImage:I];
	}
	if([popUpCell pullsDown])
	{
		cellFrame.origin.y = NSMinY(cellFrame) + 0.825 * cellFrame.size.height - 0.5 * [popUpCell cellSize].height;
		cellFrame.size.height = [popUpCell cellSize].height;
	}
	cellFrame.origin.x = NSMaxX(cellFrame) - 20;
	cellFrame.size.width = 20;
	[popUpCell drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [self isDoubleValid];
//iTM2_END;
	return [super isValid] || result;// both validators are called!
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDoubleValid
- (BOOL)isDoubleValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(NSStringFromSelector([self action]));
	BOOL result = YES;
	SEL action = [self doubleAction];
	static const char * iTM2ANSICapitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if(action)
    {
        id validatorTarget = [NSApp targetForAction:action to:[self target] from:[self controlView]]?:
			[NSApp targetForAction:action to:[[[self controlView] window] firstResponder] from:[self controlView]];
		if(validatorTarget)
		{
			const char * selectorName = sel_getName(action);
			char * name = malloc(strlen(selectorName)+9);
			if(name)
			{
				strcpy(name, "validate");
				strcpy(name+8, selectorName);
				if((name[8]>='a') && (name[8]<='z'))
					name[8] = iTM2ANSICapitals[name[8]-'a'];
			//iTM2_LOG(@"selector name: <%s>", name);
				SEL validatorAction = sel_getUid(name);
				free(name); name = nil;
				if(validatorAction)
				{
					Method validatorMethod = ((id)validatorTarget == (id)([validatorTarget class])?
						class_getClassMethod((id)(validatorTarget), validatorAction):
						class_getInstanceMethod((id)(validatorTarget->isa), validatorAction));
					if(validatorMethod)
					{
					//iTM2_END;
						id sender = ([(id)[self controlView] action] == [self action]?(id)[self controlView]:self);
						result = (int)(objc_msgSend(validatorTarget, validatorAction, sender)) & 0xFF;//BOOL
						[self setEnabled:result];
					}
				}
			}
		}
    }
//iTM2_END;
	return result;
}
@end
