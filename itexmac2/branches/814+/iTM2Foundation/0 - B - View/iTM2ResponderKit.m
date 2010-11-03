/*
//
//  @version Subversion: $Id: iTM2ResponderKit.m 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Nov 27 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import "iTM2ResponderKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2Runtime.h"
#import "iTM2BundleKit.h"
#import "iTM2Invocation.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSResponder(iTeXMac2)  

@interface NSResponder(iTeXMac2Private)
/*"Designated initializer and... Private use only."*/
+ (id)responderForWindow:(NSWindow *)aWindow;
+ (BOOL)responder:(NSResponder*)aResponder hasAmongNextResponders:(NSResponder*)anotherResponder;
- (BOOL)insertInResponderChainAfter:(NSResponder*)responder;
- (void)windowWillClose:(NSNotification *)notification;
@end

@implementation NSResponder(iTeXMac2)
/*"The purpose is to insert a new responder in the responder chain to observe and catch some messages or respond to them.
This allows to split code in logically different units and it is an alternative to subclass.
When we improve an object with further methods, we can either add a new responder or subclass an existing one.
Both methods may be used.

As suggested by appleª in the NSView documentation, we can insert responders after the main window content view
or after the window delegate.

There might be a bug/memory leak when the window is closed but not released (as for iTeXMac2 project windows).
Better design is needed."*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  uninstallInNSAppResponderChain
- (void)uninstallInNSAppResponderChain;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSResponder * previous = NSApp;
	NSResponder * next;
	while(next = [previous nextResponder])
		if (next == self)
		{
			[previous setNextResponder:[next nextResponder]];
			self.autorelease;
			return;
		}
		else
			previous = next;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  installInResponderChainAfterNSApp
+ (void)installInResponderChainAfterNSApp;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iTM2DebugEnabled)
    {
        LOG4iTM3(@"Installing the responder %@ after the application object %@...", self, NSApp);
    }
	id R = self.new;// not released, should work the same with GC
	NSAssert1([R insertInResponderChainAfter:NSApp],@"Responder not installed:%@",R);
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=  installResponderForWindow:
+ (void)installResponderForWindow:(NSWindow *)aWindow;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    id responder = [self.alloc init];
    if ([responder insertInResponderChainAfter:aWindow.contentView]) {
        [DNC addObserver:responder
            selector: @selector(responderWindowWillClose:)
                name: NSWindowWillCloseNotification
                    object: aWindow];
    }
    
    #if 0
    NSLog(@"installResponderForWindow: ==================================================");
    {
        NSScanner * S = [NSScanner scannerWithString:[DNC description]];
        NSString * STOP = NSWindowWillCloseNotification;
        while(([S scanUpToString:STOP intoString:nil], ![S isAtEnd]))  {
            NSUInteger begin, end;
//NSLog(@"GLS");
            [[S string] getLineStart:&begin end:nil contentsEnd:&end forRange:iTM3MakeRange([S scanLocation], ZER0)];
            NSLog([[S string] substringWithRange:iTM3MakeRange(begin, end-begin)]);
            [S scanString:STOP intoString:nil];
        }
    }
    #endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=  responderForWindow:
+ (id)responderForWindow:(NSWindow *)aWindow;
/*"Scans the responder chain after aWindow's content view, if there is already a NSResponder
of class self.class that will be able to send an apropriate Notification for example, or respond to appropriate messages.
If it is not the case, we create such an object.

Note that only the 100 first objects in the chain are investigated. Beware of loops."*/
{DIAGNOSTIC4iTM3;
    NSResponder * responder = aWindow.contentView;
    id nextResponder;
    NSUInteger firewall = 256;
    while((nextResponder = [responder nextResponder]) &&
                    [nextResponder isKindOfClass:[NSResponder class]] &&
                                firewall--)
        if ([nextResponder isKindOfClass:self.class])
            return nextResponder;
        else
            responder = nextResponder;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=  responder:hasAmongNextResponders:
+ (BOOL)responder:(NSResponder*)aResponder hasAmongNextResponders:(NSResponder *)anotherResponder;
/*"We should not insert in the responder chain starting from aResponder, an object that is already in it.
It would remove some previously registered responders and would cause unexpected effects."*/
{DIAGNOSTIC4iTM3;
    NSResponder * nextResponder = [aResponder nextResponder];
    if (!anotherResponder)
        return YES;
    else if (!nextResponder)
        return NO;
    else if ([nextResponder isEqual:anotherResponder])
        return YES;
    else
        // the answer is NO if either nextResponder==nil or
        // "responder" does not match any subsequent responder
        return [self responder:nextResponder hasAmongNextResponders:anotherResponder];
}
//=-=-=-=-=-=-=-=-=-=-=-=-= responderWindowWillClose:
- (void)responderWindowWillClose:(NSNotification *)aNotification;
/*"The receiver just send the #{autorelease} message to itself."*/
{DIAGNOSTIC4iTM3;
    [DNC removeObserver:self name:nil object:nil];
    self.autorelease;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=  insertInResponderChainAfter:
- (BOOL)insertInResponderChainAfter:(NSResponder *)aResponder;
/*"Inserts the receiver in the responder chain just after aResponder, if it is not already there."*/
{DIAGNOSTIC4iTM3;
    // we must preserve the existing chain
    if (![NSResponder responder:aResponder hasAmongNextResponders:self])
    {
        [self setNextResponder:[aResponder nextResponder]];
        [aResponder setNextResponder:self];
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=  __performFakeActionWithArguments:attributes:
- (BOOL)__performFakeActionWithArguments:(NSArray *)arguments attributes:(NSDictionary *)attributes;
/*"The default implementation does nothing."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=  performAction:withArguments:attributes:
- (BOOL)performAction:(NSString *)action withArguments:(NSArray *)arguments attributes:(NSDictionary *)attributes;
/*"The default implementation does nothing."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self]
        __performFakeActionWithArguments:arguments attributes:attributes];
	action = [NSString stringWithFormat:@"perform%@ActionWithArguments:attributes:",action.capitalizedString];
	SEL selector = NSSelectorFromString(action);
	if ([I.methodSignature isEqual: [self methodSignatureForSelector:selector]]) {
		[I setSelector:selector];
        [I invoke];
        BOOL R = NO;
        [I getReturnValue:&R];
        if (R) {
            return YES;
        }
	}
//END4iTM3;
    return [self.nextResponder performAction:action withArguments:arguments attributes:attributes];
}
@end

@implementation NSWindow(iTM2ResponderKit)
//=-=-=-=-=-=-=-=-=-=-=  performAction:withArguments:attributes:
- (BOOL)performAction:(NSString *)action withArguments:(NSArray *)arguments attributes:(NSDictionary *)attributes;
/*"The default implementation does nothing."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [super performAction:action withArguments:arguments attributes:attributes]
		|| [self.windowController performAction:action withArguments:arguments attributes:attributes];
}
@end

@implementation NSView(iTM2ResponderKit)
//=-=-=-=-=-=-=-=-=-=-=  performAction:withArguments:attributes:
- (BOOL)performAction:(NSString *)action withArguments:(NSArray *)arguments attributes:(NSDictionary *)attributes;
/*"The default implementation does nothing."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if ([super performAction:action withArguments:arguments attributes:attributes])
	{
		return YES;
	}
	if (self.superview)
	{
		return [self.superview performAction:action withArguments:arguments attributes:attributes];
	}
	return [self.window performAction:action withArguments:arguments attributes:attributes];
}
@end

@implementation iTM2SharedResponder
@end

@implementation iTM2AutoInstallResponder
@end

@implementation NSApplication(iTM2AutoInstallResponder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AutoInstallResponderCompleteWillFinishLaunching4iTM3
- (void)iTM2AutoInstallResponderCompleteWillFinishLaunching4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * toInstall = [NSMutableArray array];
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[iTM2AutoInstallResponder class]];
	NSUInteger i = PA.count;
	while (i--)
	{
		Class C = (Class)[PA pointerAtIndex:i];
		if (C != self.class)
		{
			NSString * className = NSStringFromClass(C);
			NSMutableString * K = [className mutableCopy];
			if ((K.length > 3) && ([K insertString:@"NO" atIndex:4], [SUD boolForKey:K]))
			{
				LOG4iTM3(@"No %@ available, to activate:", className);
				NSLog(@"terminal%% defaults remove %@ %@", [[NSBundle mainBundle] bundleIdentifier], K);
			}
			else
			{
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"%@ available, to deactivate:", className);
					NSLog(@"terminal%% defaults write %@ %@ 'YES'", [[NSBundle mainBundle] bundleIdentifier], K);
				}
				id R = [[C alloc] init];
				NSAssert1([R insertInResponderChainAfter:self],@"Responder %@ not installed after NSApp", R);
				[toInstall addObject:C];
			}
		}
	}
	NSResponder * R = self;
	while(R = [R nextResponder])
	{
//NSLog(@"R is: %@", R);
		[toInstall removeObject:[R class]];
	}
	if (toInstall.count)
	{
		LOG4iTM3(@"..........  ERROR: Not all the responders are installed...missing %@", toInstall);
	}
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Here is the list of the next responders of NSApp");
		NSResponder * R = self;
		while(R = [R nextResponder])
		{
			NSLog(@"R is: %@", R);
		}
	}
	MILESTONE4iTM3((@"iTM2AutoInstallResponder"),(@"Responders are missing, this is critical"));
//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSResponder(iTeXMac2)  
