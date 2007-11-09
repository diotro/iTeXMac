/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Sep 09 2001.
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

#import <iTM2Foundation/iTM2ValidationKit.h>
#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>
#import <iTM2Foundation/iTM2BundleKit.h>

#ifdef __iTM2_AUTO_VALIDATION_OFF__
#warning Auto validation is OFF, undefine the __iTM2_AUTO_VALIDATION_OFF__ preprocessor macro
@implementation NSObject(iTM2Validation)
- (BOOL)validateUserInterfaceItems;{return YES;}
- (BOOL)validateContent;{return YES;}
- (BOOL)validateWindowContent;{return YES;}
- (BOOL)validateWindowsContents;{return YES;}
- (BOOL)isValid;{return YES;}
- (NSWindow *)window;{return nil;}
- (BOOL)validateUserInterfaceItem:(id)sender;{return YES;}
+ (iTM2ValidationStatus)target:(id)validatorTarget validateUserInterfaceItem:(id)sender;{return YES;}
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;{return YES;}
+ (BOOL)validateMenuItem:(id <NSMenuItem>)sender;{return YES;}
@end
#else

static const char * iTM2ValidationANSICapitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSControl(iTM2Validation)
/*"Description forthcoming."*/
@implementation NSCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end

@implementation NSActionCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(NSStringFromSelector([self action]));
	BOOL result = YES;
	SEL action = [self action];
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
					name[8] = iTM2ValidationANSICapitals[name[8]-'a'];
//iTM2_LOG(@"validator name: <%s>", name);
				SEL validatorAction = sel_getUid(name);
				free(name); name = nil;
				if(validatorAction)
				{
					Method validatorMethod = ((id)validatorTarget == (id)(validatorTarget->isa)?
						class_getClassMethod((id)(validatorTarget->isa), validatorAction):
						class_getInstanceMethod((id)(validatorTarget->isa), validatorAction));
					if(validatorMethod)
					{
					//iTM2_END;
						id sender = ([(id)[self controlView] action] == [self action]?(id)[self controlView]:self);
						result = (int)(objc_msgSend(validatorTarget, validatorAction, sender)) & 0xFF;//BOOL
						[self setEnabled:result];
					}
					else
						result = YES;
				}
				else
					result = YES;
			}
			else
				result = YES;
		}
		else
			result = YES;
    }
	else
		result = [super isValid];
//iTM2_END;
	return result;
}
@end

#if 0
@implementation NSPopUpButtonCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super isValid];// might change the menu...
	NSMenu * M = [self menu];
	[M update];// or here EXC_BAD_ACCESS when quitting and something else (iTM2LaTeXScriptGraphicsButton:is the menu shared?)
//iTM2_END;
	return result;
}
@end
#endif

@implementation NSControl(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self cell])
		return [[self cell] isValid];
	// the color well has no cell!
	BOOL result = YES;
	SEL action = [self action];
    if(action)
    {
        id validatorTarget = [NSApp targetForAction:action to:[self target] from:self]?:
			[NSApp targetForAction:action to:[[self window] firstResponder] from:self];
		if(validatorTarget)
		{
			const char * selectorName = sel_getName(action);
			char * name = malloc(strlen(selectorName)+9);
			if(name)
			{
				strcpy(name, "validate");
				strcpy(name+8, selectorName);
				if((name[8]>='a') && (name[8]<='z'))
					name[8] = iTM2ValidationANSICapitals[name[8]-'a'];
			//iTM2_LOG(@"selector name: <%s>", name);
				SEL validatorAction = sel_getUid(name);
				free(name); name = nil;
				if(validatorAction)
				{
					Method validatorMethod = ((id)validatorTarget == (id)(validatorTarget->isa)? class_getClassMethod((id)(validatorTarget->isa), validatorAction): class_getInstanceMethod((id)(validatorTarget->isa), validatorAction));
					if(validatorMethod)
					{
					//iTM2_END;
						result = (int)objc_msgSend(validatorTarget, validatorAction, self) & 0xFF;//BOOL
						[self setEnabled:result];
					}
					else
						result = YES;
				}
				else
					result = YES;
			}
			else
				result = YES;
		}
		else
			result = YES;
    }
	else
		result = [super isValid];
//iTM2_END;
	return result;
}
@end

@implementation NSTextFieldCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super isValid] || [[(id)[self controlView] currentEditor] isEqual:[[[self controlView] window] firstResponder]];
//iTM2_END;
	// the validator is given a chance to invalidate the receiver, even if it is a first responder
    return result;
}
@end

@implementation NSMatrix(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning BUG: problem with key binding
	[self setEnabled:[super isValid]];
	BOOL result = NO;
//iTM2_END;
	NSEnumerator * E = [[self cells] objectEnumerator];
	NSCell * C;
	while(C = [E nextObject])
		if([C isValid])
		{
			[C setEnabled:YES];
			result = YES;
		}
		else
			[C setEnabled:NO];
    return result;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSTabView(iTM2Validation)

@implementation NSTabView(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The validator is the delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(validateTabView:)])
		[delegate performSelector:@selector(validateTabView:) withObject:self];
	return [super isValid];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSelectNextTabViewItem:
- (BOOL)validateSelectNextTabViewItem:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 02/28/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self indexOfTabViewItem:[self selectedTabViewItem]]+1 < [self numberOfTabViewItems];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSelectPreviousTabViewItem:
- (BOOL)validateSelectPreviousTabViewItem:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 02/28/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self indexOfTabViewItem:[self selectedTabViewItem]]>0;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSView(iTeXMac2Validate)
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
@implementation NSView(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUserInterfaceItems
- (BOOL)validateUserInterfaceItems;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![self isValid])
    {
        BOOL flag = YES;
        NSEnumerator * E = [[self subviews] objectEnumerator];
        NSView * V;
        while(V = [E nextObject])
            flag = [V validateUserInterfaceItems] && flag;
//iTM2_END;
        return flag;
    }
    else
        return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Called by validateUserInterfaceItems (NSView). The default implementation returns NO, which causes the view to forward the #{validateUserInterfaceItems} message to its subviews.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent
- (BOOL)validateWindowContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self window] validateContent];
}
@end

@implementation NSWindow(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateContent
- (BOOL)validateContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
#if __iTM2_DEVELOPMENT__
printf("Currently validating: %s from document %s in zone %#x\n", [[self title] lossyCString],
	[[[[self windowController] document] description] lossyCString], (unsigned int)[self zone]);
#endif
//iTM2_START;
    BOOL flag = [[self contentView] validateUserInterfaceItems];
    NSEnumerator * E = [[self drawers] objectEnumerator];
    id D;
    while(D = [E nextObject])
        flag = [D validateContent] && flag;
	if(D = [self attachedSheet])
        flag = [D validateContent] && flag;
	E = [[self childWindows] objectEnumerator];
    while(D = [E nextObject])
        flag = [D validateContent] && flag;
    return flag;
}
@end

@interface NSWindow_iTM2ValidationKit_Validation: NSWindow
@end
@implementation NSWindow_iTM2ValidationKit_Validation
// I assume that order front and order back both call orderWindow:relativeTo:
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFront:
- (void)orderFront:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateContent];
    [super orderFront:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderBack:
- (void)orderBack:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateContent];
    [super orderBack:sender];
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderWindow:relativeTo:
- (void)orderWindow:(NSWindowOrderingMode)place relativeTo:(int)otherWin;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(place != NSWindowOut)
		[self validateContent];
    [super orderWindow:place relativeTo:otherWin];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFrontRegardless
- (void)orderFrontRegardless;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self validateContent];
    [super orderFrontRegardless];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  becomeKeyWindow
- (void)becomeKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super becomeKeyWindow];
	[self validateContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resignKeyWindow
- (void)resignKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super resignKeyWindow];
	if([self isVisible])
	{
		[self validateContent];
	}
//iTM2_END;
    return;
}
@end

@implementation NSDrawer(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateContent
- (BOOL)validateContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * V = [self contentView];
	NSSize S = [V visibleRect].size;
//iTM2_END;
	return ([self state] == NSDrawerClosedState) || (S.width>0 && S.height>0 && [V validateUserInterfaceItems]);
}
@end

#import <objc/objc-class.h>

@implementation NSWindowController(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent
- (BOOL)validateWindowContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//  the following one is satisfying because it does not load the window as side effect...
    return [self isWindowLoaded] && [[self window] isVisible] && [[self window] validateContent];
}
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>
@interface NSDocument_iTM2Validation: NSDocument
@end
@implementation NSDocument_iTM2Validation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector([sender action]), [sender target]);
	if([sender action])
	{
		int status = [isa target:self validateUserInterfaceItem:sender];
		if(status == iTM2ValidationStatusYES)
		{
			return YES;
		}
		if(status == iTM2ValidationStatusNO)
		{
			return NO;
		}
	}
    return [sender submenu]!=nil || [super validateMenuItem:sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowsContents
- (BOOL)validateWindowsContents;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL flag = YES;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [E nextObject])
        flag = [WC validateWindowContent] && flag;
//iTM2_END;
    return flag;
}
@end

@interface NSTextView_iTM2Validation: NSTextView
@end
@implementation NSTextView_iTM2Validation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSTextView_iTM2Validation poseAsClass:[NSTextView class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector([sender action]), [sender target]);
	int status = [isa target:self validateUserInterfaceItem:sender];
    return status == iTM2ValidationStatusYES?YES:
		(status == iTM2ValidationStatusNO?NO:[super validateMenuItem:(id) sender]);
}
@end

@implementation NSObject(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= noop:
- (IBAction)noop:(id)sender;// do nothing: message catcher
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateNoop:
- (BOOL)validateNoop:(id)sender;// always return NO such that the sender is not enabled...
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateUserInterfaceItem:
- (BOOL)validateUserInterfaceItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [isa target:self validateUserInterfaceItem:(id) sender]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= target:validateUserInterfaceItem:
+ (iTM2ValidationStatus)target:(id)validatorTarget validateUserInterfaceItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!validatorTarget)
        return iTM2ValidationStatusNO;
    const char * selectorName = sel_getName([sender action]);
    int length = strlen(selectorName);
    if(!length)
        return iTM2ValidationStatusNO;
    char * name = malloc(strlen(selectorName)+9);
    if(!name)
        return iTM2ValidationStatusUnkonwn;
    strcpy(name, "validate");
    strcpy(name+8, selectorName);
    if((name[8]>='a') && (name[8]<='z'))
        name[8] = iTM2ValidationANSICapitals[name[8]-'a'];
//iTM2_LOG(@"validator name: <%s>", name);
    SEL validatorAction = sel_getUid(name);
    free(name);
    name = nil;
    if(!validatorAction)
        return iTM2ValidationStatusUnkonwn;
    Method validatorMethod = ((id)validatorTarget == (id)(validatorTarget->isa)? class_getClassMethod((id)(validatorTarget->isa), validatorAction): class_getInstanceMethod((id)(validatorTarget->isa), validatorAction));
    if(!validatorMethod)
        return iTM2ValidationStatusUnkonwn;
//iTM2_END;
	id result = objc_msgSend(validatorTarget, validatorAction, sender);
//iTM2_LOG(@"%@: %#x", NSStringFromSelector(validatorAction), result);
	if((int)result & 0xFF)
	{
		return iTM2ValidationStatusYES;
	}
	else
	{
		return iTM2ValidationStatusNO;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector([sender action]), [sender target]);
    return [sender action] && ([isa target:self validateUserInterfaceItem:sender] == iTM2ValidationStatusNO)?NO:YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
+ (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [sender action] && ([self target:self validateUserInterfaceItem:sender] == iTM2ValidationStatusNO)?NO:YES;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ValidationSwizzle_validateMenuItem:
- (BOOL)iTM2ValidationSwizzle_validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [isa target:self validateUserInterfaceItem:sender] || [self iTM2ValidationSwizzle_validateMenuItem:(id <NSMenuItem>) sender];
}
#endif
@end

@implementation iTM2Application(ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector([sender action]), [sender target]);
	if([sender action])
	{
		int status = [isa target:self validateUserInterfaceItem:sender];
		if(status == iTM2ValidationStatusYES)
		{
			return YES;
		}
		if(status == iTM2ValidationStatusNO)
		{
			[isa target:self validateUserInterfaceItem:sender];
			return NO;
		}
	}
    return ([sender submenu]!=nil) || [super validateMenuItem:sender];
}
@end

@interface NSTabView_iTM2ValidationKit : NSTabView
- (void)selectTabViewItem:(NSTabViewItem *)tabViewItem;
@end
@implementation NSTabView_iTM2ValidationKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectTabViewItem:
- (void)selectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super selectTabViewItem:tabViewItem];
	[[[self selectedTabViewItem] view] validateUserInterfaceItems];
//iTM2_END;
    return;
}
@end

@implementation NSToolbar(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  window
- (NSWindow *)window;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return _window;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateContent
- (BOOL)validateContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * items = [self items];
	NSEnumerator * E = [items objectEnumerator];
	NSToolbarItem * item = nil;
	while(item = [E nextObject])
	{
		[item validate];
	}
//iTM2_END;
	return YES;
}
@end


@interface NSToolbarItem_iTM2ValidationKit: NSToolbarItem
@end
@implementation NSToolbarItem_iTM2ValidationKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validate
- (void)validate;
/*"This is the validation protocol "invented". Sends a validateUserInterfaceItems to the view if any, or calls the inherited method.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Test, blinkering? don't call super ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSView * view = [self view];
    if(view)
        [view validateUserInterfaceItems];
    else
        [super validate];
//iTM2_END;
    return;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSWindow_iTM2ValidationKit_Validation poseAsClass:[NSWindow class]];
	[NSDocument_iTM2Validation poseAsClass:[NSDocument class]];// swizzling does not work
	[NSTextView_iTM2Validation poseAsClass:[NSTextView class]];
	[NSTabView_iTM2ValidationKit poseAsClass:[NSTabView class]];
	[NSToolbarItem_iTM2ValidationKit poseAsClass:[NSToolbarItem class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
@end
//__iTM2_AUTO_VALIDATION_OFF__

#if 0
@interface NSTextFinderButton_DEBUG: NSButton
@end
@implementation NSTextFinderButton_DEBUG
+ (void)load;{[self poseAsClass:[NSButton class]];}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid
- (BOOL)isValid;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(NSStringFromSelector([self action]));
	if([self action] == @selector(performFindPanelAction:))
	{
        id validator = [NSApp targetForAction:@selector(performFindPanelAction:) to:[[NSApp mainWindow] firstResponder] from:self];
		if(validator)
			[self setEnabled:([isa target:validator validateUserInterfaceItem:(id)self]>0)];
		[self setTarget:validator];
		iTM2_LOG(@"validator is: %@", validator);
	}
	else
		return [super isValid];
//iTM2_END;
    return YES;
}
@end
#endif

#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSView(Validate)

