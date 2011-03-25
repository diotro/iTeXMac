/*
//
//  @version Subversion: $Id: iTM2ValidationKit.m 794 2009-10-04 12:33:28Z jlaurens $ 
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

#import "iTM2ValidationKit.h"
#import "iTM2BundleKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Runtime.h"
#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

#ifdef __iTM2_AUTO_VALIDATION_OFF__
#warning Auto validation is OFF, undefine the __iTM2_AUTO_VALIDATION_OFF__ preprocessor macro
@implementation NSObject(iTM2Validation)
- (BOOL)validateUserInterfaceItems4iTM3;{return YES;}
- (BOOL)isContentValid4iTM3;{return YES;}
- (BOOL)isWindowContentValid4iTM3;{return YES;}
- (BOOL)isWindowContentValid4iTM3;{return YES;}
- (BOOL)isValid4iTM3;{return YES;}
+ (iTM2ValidationStatus)target4iTM3:(id)validatorTarget validateUserInterfaceItem:(id)sender;{return YES;}
- (BOOL)validateUserInterfaceItem:(id)sender;{return YES;}
- (BOOL)validateMenuItem:(NSMenuItem *)sender;{return YES;}
+ (BOOL)validateMenuItem:(NSMenuItem *)sender;{return YES;}
- (NSWindow *)window;{return nil;}
@end
#else

static const char * iTM2ValidationANSICapitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSControl(iTM2Validation)
/*"Description forthcoming."*/
@implementation NSCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
@end

@implementation NSActionCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(NSStringFromSelector(self.action));
	BOOL result = YES;
	SEL action = self.action;
    if (action)
    {
        id validatorTarget = [NSApp targetForAction:action to:self.target from:self.controlView]?:
			[NSApp targetForAction:action to:self.controlView.window.firstResponder from:self.controlView];
		if (validatorTarget)
		{
			const char * selectorName = sel_getName(action);
			char * name = malloc(strlen(selectorName)+9);
			if (name)
			{
				strcpy(name, "validate");
				strcpy(name+8, selectorName);
				if ((name[8]>='a') && (name[8]<='z'))
					name[8] = iTM2ValidationANSICapitals[name[8]-'a'];
//LOG4iTM3(@"validator name: <%s>", name);
				SEL validatorAction = sel_getUid(name);
				free(name); name = nil;
				if (validatorAction && class_getInstanceMethod(validatorTarget->isa, validatorAction)) {
					//END4iTM3;
                    id sender = ([(id)self.controlView action] == self.action?(id)self.controlView:self);
                    result = (NSInteger)(objc_msgSend(validatorTarget, validatorAction, sender)) & 0xFF;//BOOL
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
		result = [super isValid4iTM3];
//END4iTM3;
	return result;
}
@end

#if 0
@implementation NSPopUpButtonCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = [super isValid4iTM3];// might change the menu...
	NSMenu * M = self.menu;
	[M update];// or here EXC_BAD_ACCESS when quitting and something else (iTM2LaTeXScriptGraphicsButton:is the menu shared?)
//END4iTM3;
	return result;
}
@end
#endif

@implementation NSControl(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.cell)
		return [self.cell isValid4iTM3];
	// the color well has no cell!
	BOOL result = YES;
	SEL action = self.action;
    if (action)
    {
        id validatorTarget = [NSApp targetForAction:action to:self.target from:self]?:
			[NSApp targetForAction:action to:self.window.firstResponder from:self];
		if (validatorTarget)
		{
			const char * selectorName = sel_getName(action);
			char * name = malloc(strlen(selectorName)+9);
			if (name)
			{
				strcpy(name, "validate");
				strcpy(name+8, selectorName);
				if ((name[8]>='a') && (name[8]<='z'))
					name[8] = iTM2ValidationANSICapitals[name[8]-'a'];
			//LOG4iTM3(@"selector name: <%s>", name);
				SEL validatorAction = sel_getUid(name);
				free(name); name = nil;
				if (validatorAction && class_getInstanceMethod(validatorTarget->isa, validatorAction)) {
                //END4iTM3;
                    result = (NSInteger)objc_msgSend(validatorTarget, validatorAction, self) & 0xFF;//BOOL
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
		result = [super isValid4iTM3];
//END4iTM3;
	return result;
}
@end

@implementation NSTextFieldCell(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = [super isValid4iTM3] || [[(id)self.controlView currentEditor] isEqual:self.controlView.window.firstResponder];
//END4iTM3;
	// the validator is given a chance to invalidate the receiver, even if it is a first responder
    return result;
}
@end

@implementation NSMatrix(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the object responding to the action, either the validatorTarget of the receiver of an object in the responder chain (or the window delegate). The standard validating process is extended. Assuming the action of the receiver is #{fooAction:}, and the validatorTarget responds to #{validateFooAction:} this message is sent to validate the receiver. If the validatorTarget does not respond to #{validateFooAction}, then it is asked for #{target:validateUserInterfaceItem:} as usual.
Version history: jlaurens AT users DOT sourceforge DOT net
- 3.0: Latest Revision: Sat Feb 20 10:44:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning BUG: problem with key binding
	[self setEnabled:[super isValid4iTM3]];
	BOOL result = NO;
//END4iTM3;
	for (NSCell * C in self.cells) {
        if ([C isValid4iTM3])
        {
            [C setEnabled:YES];
            result = YES;
        } else {
            [C setEnabled:NO];
        }
    }
    return result;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSTabView(iTM2Validation)

@implementation NSTabView(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The validator is the delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(validateTabView:)])
		[delegate performSelector:@selector(validateTabView:) withObject:self];
	return [super isValid4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSelectNextTabViewItem:
- (BOOL)validateSelectNextTabViewItem:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 02/28/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self indexOfTabViewItem:self.selectedTabViewItem]+1 < self.numberOfTabViewItems;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSelectPreviousTabViewItem:
- (BOOL)validateSelectPreviousTabViewItem:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 02/28/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self indexOfTabViewItem:self.selectedTabViewItem]>ZER0;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSView(iTeXMac2Validate)
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
@implementation NSView(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUserInterfaceItems4iTM3
- (BOOL)validateUserInterfaceItems4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.isValid4iTM3)
    {
        BOOL flag = YES;
        for (NSView * V in self.subviews)
            flag = [V validateUserInterfaceItems4iTM3] && flag;
//END4iTM3;
        return flag;
    }
    else
        return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Called by validateUserInterfaceItems4iTM3 (NSView). The default implementation returns NO, which causes the view to forward the #{validateUserInterfaceItems4iTM3} message to its subviews.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWindowContentValid4iTM3
- (BOOL)isWindowContentValid4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.window isContentValid4iTM3];
}
@end

@implementation NSWindow(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isContentValid4iTM3
- (BOOL)isContentValid4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
#if __iTM3_DEVELOPMENT__
    printf("Currently validating: %s from document %s in zone %#lx\n", [self.title UTF8String],
           [[[self.windowController document] description] UTF8String], (NSUInteger)self.zone);
#endif
    //START4iTM3;
    BOOL flag = [self.contentView validateUserInterfaceItems4iTM3];
    id D;
    for (D in self.drawers)
        flag = [D isContentValid4iTM3] && flag;
	if ((D = self.attachedSheet))
        flag = [D isContentValid4iTM3] && flag;
	for (D in self.childWindows)
        flag = [D isContentValid4iTM3] && flag;
    return flag;
}
@end

@implementation NSWindow(iTM2ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_orderWindow:relativeTo:
- (void)SWZ_iTM2Valid_orderWindow:(NSWindowOrderingMode)place relativeTo:(NSInteger)otherWin;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (place != NSWindowOut)
		[self isContentValid4iTM3];
    [self SWZ_iTM2Valid_orderWindow:place relativeTo:otherWin];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_orderFrontRegardless
- (void)SWZ_iTM2Valid_orderFrontRegardless;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self isContentValid4iTM3];
    [self SWZ_iTM2Valid_orderFrontRegardless];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_becomeKeyWindow
- (void)SWZ_iTM2Valid_becomeKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self SWZ_iTM2Valid_becomeKeyWindow];
	[self isContentValid4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_resignKeyWindow
- (void)SWZ_iTM2Valid_resignKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self SWZ_iTM2Valid_resignKeyWindow];
	if (self.isVisible) {
		[self isContentValid4iTM3];
	}
//END4iTM3;
    return;
}
@end

@implementation NSDrawer(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isContentValid4iTM3
- (BOOL)isContentValid4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
	NSView * V = self.contentView;
	NSSize S = [V visibleRect].size;
    //END4iTM3;
	return (self.state == NSDrawerClosedState) || (S.width>0 && S.height>0 && [V validateUserInterfaceItems4iTM3]);
}
@end

@implementation NSWindowController(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWindowContentValid4iTM3
- (BOOL)isWindowContentValid4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//  the following one is satisfying because it does not load the window as side effect...
    return self.isWindowLoaded && [self.window isVisible] && [self.window isContentValid4iTM3];
}
@end

@implementation NSDocument(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_validateMenuItem:
- (BOOL)SWZ_iTM2Valid_validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector(sender.action), sender.target);
	if (sender.action) {
		iTM2ValidationStatus status = [self.class target4iTM3:self validateUserInterfaceItem:sender];
		if (status == iTM2ValidationStatusYES) {
			return YES;
		}
		if (status == iTM2ValidationStatusNO) {
			return NO;
		}
	}
    return [sender submenu]!=nil || [self SWZ_iTM2Valid_validateMenuItem:sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWindowContentValid4iTM3
- (BOOL)isWindowContentValid4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL flag = YES;
    for (NSWindowController * WC in self.windowControllers)
        flag = [WC isWindowContentValid4iTM3] && flag;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector(sender.action), sender.target);
	iTM2ValidationStatus status = [self.class target4iTM3:self validateUserInterfaceItem:sender];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateNoop:
- (BOOL)validateNoop:(id)sender;// always return NO such that the sender is not enabled...
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateUserInterfaceItem:
- (BOOL)validateUserInterfaceItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.class target4iTM3:self validateUserInterfaceItem:(id) sender]>ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= target4iTM3:validateUserInterfaceItem:
+ (iTM2ValidationStatus)target4iTM3:(id)validatorTarget validateUserInterfaceItem:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!validatorTarget)
	{
        return iTM2ValidationStatusNO;
	}
    const char * selectorName = sel_getName(sender.action);
    if (!strlen(selectorName)) {
        return iTM2ValidationStatusNO;
    }
    char * name = malloc(strlen(selectorName)+9);
    if (!name) {
        return iTM2ValidationStatusUnkonwn;
    }
    strcpy(name, "validate");
    strcpy(name+8, selectorName);
    if ((name[8]>='a') && (name[8]<='z'))
        name[8] = iTM2ValidationANSICapitals[name[8]-'a'];
//LOG4iTM3(@"validator name: <%s>", name);
    SEL validatorAction = sel_getUid(name);
    free(name); name = nil;
    if (!validatorAction) {
        return iTM2ValidationStatusUnkonwn;
    }
    if (!class_getInstanceMethod([validatorTarget class], validatorAction)) {
        return iTM2ValidationStatusUnkonwn;
    }
//END4iTM3;
	id result = objc_msgSend(validatorTarget, validatorAction, sender);
//LOG4iTM3(@"%@: %#x", NSStringFromSelector(validatorAction), result);
	return (NSInteger)result & 0xFF?iTM2ValidationStatusYES:iTM2ValidationStatusNO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector(sender.action), sender.target);
    return sender.action && ([self.class target4iTM3:self validateUserInterfaceItem:sender] == iTM2ValidationStatusNO)?NO:YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
+ (BOOL)validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return sender.action && ([self target4iTM3:self validateUserInterfaceItem:sender] == iTM2ValidationStatusNO)?NO:YES;
}
@end

@implementation iTM2Application(ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is: %@ (action: %@, target: %@)", sender, NSStringFromSelector(sender.action), sender.target);
	if (sender.action) {
		iTM2ValidationStatus status = [self.class target4iTM3:self validateUserInterfaceItem:sender];
		if (status == iTM2ValidationStatusYES) {
			return YES;
		}
		if (status == iTM2ValidationStatusNO) {
			[self.class target4iTM3:self validateUserInterfaceItem:sender];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self SWZ_iTM2Valid_selectTabViewItem:tabViewItem];
	[[self.selectedTabViewItem view] validateUserInterfaceItems4iTM3];
//END4iTM3;
    return;
}
@end

@implementation NSToolbar(iTM2Validation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isContentValid4iTM3
- (BOOL)isContentValid4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
	for (NSToolbarItem * item in self.items) {
		[item validate];
	}
    //END4iTM3;
	return YES;
}
@end


@implementation NSToolbarItem(iTM2ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Valid_validate
- (void)SWZ_iTM2Valid_validate;
/*"This is the validation protocol "invented". Sends a validateUserInterfaceItems4iTM3 to the view if any, or calls the inherited method.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Test, blinkering? don't call super ?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * view = self.view;
    if (view) {
        [view validateUserInterfaceItems4iTM3];
	} else {
        [self SWZ_iTM2Valid_validate];
	}
//END4iTM3;
    return;
}
@end

@implementation iTM2MainInstaller(ValidationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareValidationKitCompleteInstallation4iTM3
+ (void)prepareValidationKitCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSTextView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_validateMenuItem:) error:NULL];
	[NSToolbarItem swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_validate) error:NULL];
	[NSTabView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_selectTabViewItem:) error:NULL];
	[NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_validateMenuItem:) error:NULL];
	[NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_orderWindow:relativeTo:) error:NULL];
	[NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_orderFrontRegardless) error:NULL];
	[NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_becomeKeyWindow) error:NULL];
	[NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Valid_resignKeyWindow) error:NULL];
//END4iTM3;
    return;
}
@end
//__iTM2_AUTO_VALIDATION_OFF__

#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSView(Validate)

