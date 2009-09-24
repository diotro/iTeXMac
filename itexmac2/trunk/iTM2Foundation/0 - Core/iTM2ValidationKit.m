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
- (BOOL)iTM2_validateUserInterfaceItems;{return YES;}
- (BOOL)iTM2_validateContent;{return YES;}
- (BOOL)iTM2_validateWindowContent;{return YES;}
- (BOOL)iTM2_validateWindowsContents;{return YES;}
- (BOOL)iTM2_isValid;{return YES;}
+ (iTM2ValidationStatus)iTM2_target:(id)validatorTarget validateUserInterfaceItem:(id)sender;{return YES;}
- (BOOL)validateUserInterfaceItem:(id)sender;{return YES;}
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;{return YES;}
+ (BOOL)validateMenuItem:(id <NSMenuItem>)sender;{return YES;}
- (NSWindow *)window;{return nil;}
@end
#else

static const char * iTM2ValidationANSICapitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSControl(iTM2Validation)
/*"Description forthcoming."*/
@implementation NSCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
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
		result = [super iTM2_isValid];
//iTM2_END;
	return result;
}
@end

#if 0
@implementation NSPopUpButtonCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super iTM2_isValid];// might change the menu...
	NSMenu * M = [self menu];
	[M update];// or here EXC_BAD_ACCESS when quitting and something else (iTM2LaTeXScriptGraphicsButton:is the menu shared?)
//iTM2_END;
	return result;
}
@end
#endif

@implementation NSControl(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self cell])
		return [[self cell] iTM2_isValid];
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
		result = [super iTM2_isValid];
//iTM2_END;
	return result;
}
@end

@implementation NSTextFieldCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super iTM2_isValid] || [[(id)[self controlView] currentEditor] isEqual:[[[self controlView] window] firstResponder]];
//iTM2_END;
	// the validator is given a chance to invalidate the receiver, even if it is a first responder
    return result;
}
@end

@implementation NSMatrix(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning BUG: problem with key binding
	[self setEnabled:[super iTM2_isValid]];
	BOOL result = NO;
//iTM2_END;
	NSEnumerator * E = [[self cells] objectEnumerator];
	NSCell * C;
	while(C = [E nextObject])
		if([C iTM2_isValid])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The validator is the delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(validateTabView:)])
		[delegate performSelector:@selector(validateTabView:) withObject:self];
	return [super iTM2_isValid];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateUserInterfaceItems
- (BOOL)iTM2_validateUserInterfaceItems;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![self iTM2_isValid])
    {
        BOOL flag = YES;
        NSEnumerator * E = [[self subviews] objectEnumerator];
        NSView * V;
        while(V = [E nextObject])
            flag = [V iTM2_validateUserInterfaceItems] && flag;
//iTM2_END;
        return flag;
    }
    else
        return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isValid
- (BOOL)iTM2_isValid;
/*"Called by iTM2_validateUserInterfaceItems (NSView). The default implementation returns NO, which causes the view to forward the #{iTM2_validateUserInterfaceItems} message to its subviews.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateWindowContent
- (BOOL)iTM2_validateWindowContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self window] iTM2_validateContent];
}
@end

@implementation NSWindow(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateContent
- (BOOL)iTM2_validateContent;
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
    BOOL flag = [[self contentView] iTM2_validateUserInterfaceItems];
    NSEnumerator * E = [[self drawers] objectEnumerator];
    id D;
    while(D = [E nextObject])
        flag = [D iTM2_validateContent] && flag;
	if(D = [self attachedSheet])
        flag = [D iTM2_validateContent] && flag;
	E = [[self childWindows] objectEnumerator];
    while(D = [E nextObject])
        flag = [D iTM2_validateContent] && flag;
    return flag;
}
@end

@implementation NSWindow(iTM2ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_orderWindow:relativeTo:
- (void)SWZ_iTM2Valid_orderWindow:(NSWindowOrderingMode)place relativeTo:(int)otherWin;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(place != NSWindowOut)
		[self iTM2_validateContent];
    [self SWZ_iTM2Valid_orderWindow:place relativeTo:otherWin];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_orderFrontRegardless
- (void)SWZ_iTM2Valid_orderFrontRegardless;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self iTM2_validateContent];
    [self SWZ_iTM2Valid_orderFrontRegardless];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_becomeKeyWindow
- (void)SWZ_iTM2Valid_becomeKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self SWZ_iTM2Valid_becomeKeyWindow];
	[self iTM2_validateContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_resignKeyWindow
- (void)SWZ_iTM2Valid_resignKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self SWZ_iTM2Valid_resignKeyWindow];
	if([self isVisible])
	{
		[self iTM2_validateContent];
	}
//iTM2_END;
    return;
}
@end

@implementation NSDrawer(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateContent
- (BOOL)iTM2_validateContent;
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
	return ([self state] == NSDrawerClosedState) || (S.width>0 && S.height>0 && [V iTM2_validateUserInterfaceItems]);
}
@end

#import <objc/objc-class.h>

@implementation NSWindowController(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateWindowContent
- (BOOL)iTM2_validateWindowContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//  the following one is satisfying because it does not load the window as side effect...
    return [self isWindowLoaded] && [[self window] isVisible] && [[self window] iTM2_validateContent];
}
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>
@implementation NSDocument(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_validateMenuItem:
- (BOOL)SWZ_iTM2Valid_validateMenuItem:(id)sender;
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
		int status = [[self class] iTM2_target:self validateUserInterfaceItem:sender];
		if(status == iTM2ValidationStatusYES)
		{
			return YES;
		}
		if(status == iTM2ValidationStatusNO)
		{
			return NO;
		}
	}
    return [sender submenu]!=nil || [self SWZ_iTM2Valid_validateMenuItem:sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateWindowsContents
- (BOOL)iTM2_validateWindowsContents;
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
        flag = [WC iTM2_validateWindowContent] && flag;
//iTM2_END;
    return flag;
}
@end

@implementation NSTextView(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_validateMenuItem:
- (BOOL)SWZ_iTM2Valid_validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector([sender action]), [sender target]);
	int status = [[self class] iTM2_target:self validateUserInterfaceItem:sender];
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
	return [[self class] iTM2_target:self validateUserInterfaceItem:(id) sender]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_target:validateUserInterfaceItem:
+ (iTM2ValidationStatus)iTM2_target:(id)validatorTarget validateUserInterfaceItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!validatorTarget)
	{
        return iTM2ValidationStatusNO;
	}
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
- (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector([sender action]), [sender target]);
    return [sender action] && ([[self class] iTM2_target:self validateUserInterfaceItem:sender] == iTM2ValidationStatusNO)?NO:YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
+ (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [sender action] && ([self iTM2_target:self validateUserInterfaceItem:sender] == iTM2ValidationStatusNO)?NO:YES;
}
@end

@implementation iTM2Application(ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(id)sender;
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
		int status = [[self class] iTM2_target:self validateUserInterfaceItem:sender];
		if(status == iTM2ValidationStatusYES)
		{
			return YES;
		}
		if(status == iTM2ValidationStatusNO)
		{
			[[self class] iTM2_target:self validateUserInterfaceItem:sender];
			return NO;
		}
	}
    return ([sender submenu]!=nil) || [super validateMenuItem:sender];
}
@end

@implementation NSTabView(iTM2ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_selectTabViewItem:
- (void)SWZ_iTM2Valid_selectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self SWZ_iTM2Valid_selectTabViewItem:tabViewItem];
	[[[self selectedTabViewItem] view] iTM2_validateUserInterfaceItems];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateContent
- (BOOL)iTM2_validateContent;
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


@implementation NSToolbarItem(iTM2ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_validate
- (void)SWZ_iTM2Valid_validate;
/*"This is the validation protocol "invented". Sends a iTM2_validateUserInterfaceItems to the view if any, or calls the inherited method.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Test, blinkering? don't call super ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSView * view = [self view];
    if(view)
	{
        [view iTM2_validateUserInterfaceItems];
	}
    else
	{
        [self SWZ_iTM2Valid_validate];
	}
//iTM2_END;
    return;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>

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
	[NSTextView iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_validateMenuItem:)];
	[NSToolbarItem iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_validate)];
	[NSTabView iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_selectTabViewItem:)];
	[NSDocument iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_validateMenuItem:)];
	[NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_orderWindow:relativeTo:)];
	[NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_orderFrontRegardless)];
	[NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_becomeKeyWindow)];
	[NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Valid_resignKeyWindow)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
@end
//__iTM2_AUTO_VALIDATION_OFF__

#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSView(Validate)

